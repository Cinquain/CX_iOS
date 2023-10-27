//
//  Store.swift
//  CityXcape
//
//  Created by James Allan on 10/26/23.
//

import Foundation
import StoreKit

typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)

final class Store: NSObject, ObservableObject {
    
    static let shared = Store()
    
    
    override init() {
        super.init()
        startObservingPaymentQueue()
        fetchProducts { product in
            print(product)
        }
    }
    private let allProductsIdentifiers = Set([
            "com.cityportal.CityXcape0.streetcred",
            "com.cityportal.CityXcape0.streetcred50",
            "com.cityportal.CityXcape0.streetcred100"
        ])
    
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    
    private var productsRequest: SKProductsRequest?
    private var fetchedProducts: [SKProduct] = []
    private var completedPurchases: [String] = []
    
    
    
    private func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    
    func product(for identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: {$0.productIdentifier == identifier})
    }
    
    func fetchProducts(_ completion: @escaping FetchCompletionHandler) {
        guard self.productsRequest == nil else {return}
        fetchCompletionHandler = completion
        
        productsRequest = SKProductsRequest(productIdentifiers: allProductsIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    private func buy(_ product: SKProduct, completion: @escaping PurchaseCompletionHandler) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        purchaseCompletionHandler = completion
    }
    
    func purchaseProduct(_ product: SKProduct, completion: @escaping (Result<Bool,CustomError>) -> Void) {
        startObservingPaymentQueue()
        buy(product) { transaction in
            if transaction?.transactionState == .purchased {
                print("Product Purchased Successfully!")
                completion(.success(true))
            } else {
                print("Transaction Failed!")
                completion(.failure(.failedPurchase))
            }
        }
    }
    
}

extension Store: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            var shoudFinishTransaction = false
            
            switch transaction.transactionState {
                case .purchased, .restored:
                    completedPurchases.append(transaction.payment.productIdentifier)
                    shoudFinishTransaction = true
                case .failed:
                    shoudFinishTransaction = true
                case .deferred, .purchasing:
                    break
                @unknown default:
                    break
            }
            
            if shoudFinishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
            //End of Loop
        }
    }
}

extension Store: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else {
            print("Could not load products!")
            if !invalidProducts.isEmpty {
                print("Found invalid products: \(invalidProducts)")
            }
            return
        }
        
        fetchedProducts = loadedProducts
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedProducts)
            self.fetchCompletionHandler = nil
            self.productsRequest = nil
        }
    }
}

