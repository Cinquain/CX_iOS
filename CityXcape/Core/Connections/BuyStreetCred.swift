//
//  BuyWavesView.swift
//  CityXcape
//
//  Created by James Allan on 9/2/23.
//

import SwiftUI

struct BuyStreetCred: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: Store
    @AppStorage(AppUserDefaults.streetcred) var wallet: Int?

    @State private var message: String = ""
    @State private var showMessage: Bool = false
    
    var body: some View {
            
            VStack {
                Headline()
                    .padding(.top, 25)
                    .alert(isPresented: $showMessage) {
                        return Alert(title: Text(message))
                    }

                VStack(spacing: 12) {
                    
                    Button {
                        if let product = store.product(for: Product.streetcred.rawValue) {
                            store.purchaseProduct(product) { result in
                                switch result {
                                case .success(_):
                                    updateStreetCred(count: Product.streetcred.count)
                                case .failure(let error):
                                    message = error.localizedDescription
                                    showMessage.toggle()
                                }
                            }
                        }
                    } label: {
                        WaveCapsule(count: 10, price: 9.99)
                    }
                    
                    Button {
                        if let product = store.product(for: Product.streetcred_50.rawValue) {
                            store.purchaseProduct(product) { result in
                                switch result {
                                case .success(_):
                                    updateStreetCred(count: Product.streetcred_50.count)
                                case .failure(let error):
                                    message = error.localizedDescription
                                    showMessage.toggle()
                                }
                            }
                        }
                    } label: {
                        WaveCapsule(count: 50, price: 29.99)
                    }
                    
                    Button {
                        if let product = store.product(for: Product.streetcred_100.rawValue) {
                            store.purchaseProduct(product) { result in
                                switch result {
                                case .success(_):
                                    updateStreetCred(count: Product.streetcred_100.count)
                                case .failure(let error):
                                    message = error.localizedDescription
                                    showMessage.toggle()
                                }
                            }
                        }                    } label: {
                        WaveCapsule(count: 100, price: 74.99)
                    }
                    
                    Spacer()
                    
                }
                .padding(.bottom, 40)
                
                
            }
            .cornerRadius(24)
            .background(Background())
            .edgesIgnoringSafeArea(.bottom)
            .colorScheme(.dark)
            
           
        


    }
    

    
    @ViewBuilder
    func WaveCapsule(count: Int, price: Double) -> some View {
        let rounded = String(format: "%.2f", price)
        HStack {
            Text("\(count) StreetCred $\(rounded)")
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(width: 275, height: 50)
                .background(.orange.opacity(0.6))
                .clipShape(Capsule())

        }
        .padding(10)
        .background(.black.opacity(0.6))
    }
    
    @ViewBuilder
    func Background() -> some View {
        GeometryReader {
            let size = $0.size
            Image("network")
                .resizable()
                .scaledToFill()
                .overlay(Color.black.opacity(0.80))
                .frame(width: size.width, height: size.height)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    @ViewBuilder
    func Headline() -> some View {
        VStack(spacing: 5) {
            Button {
                dismiss()
            } label: {
                Image("StreetCred")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.8)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }

            
            HStack {
                Spacer()
                VStack {
                    Text("Buy StreetCred to Connect")
                        .font(Font.custom("times new roman", size: 20))
                        .fontWeight(.semibold)
                    .opacity(0.8)
                    Text("Balance: \(wallet ?? 0)")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .font(.caption)
                }
                Spacer()
            }
          
        }
        .padding(.top, 25)
        .foregroundColor(.white)
    }
    
    fileprivate func updateStreetCred(count: Int) {
        var streetcred = wallet ?? 0
        streetcred += count
        let data: [String: Any] = [
            User.CodingKeys.streetCred.rawValue: streetcred
        ]
        UserDefaults.standard.set(streetcred, forKey: AppUserDefaults.streetcred)
        Task {
            do {
                try await  DataService.shared.updateStreetPass(data: data)
                message = "Your wallet has now \(streetcred) STC"
                showMessage.toggle()
            } catch {
                message = error.localizedDescription
                showMessage.toggle()
            }
        }
       
    }
}

struct BuyWavesView_Previews: PreviewProvider {
    static var previews: some View {
        BuyStreetCred()
    }
}
