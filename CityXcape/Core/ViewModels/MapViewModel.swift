//
//  MapViewModel.swift
//  CityXcape
//
//  Created by James Allan on 8/28/23.
//

import Foundation
import SwiftUI
import MapKit
import Combine




class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var isSearching: Bool = false
    @Published var searchQuery: String = ""
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var mapItem: MKMapItem?
    @Published var mapItems: [MKMapItem] = []
    @Published var annotations: [MKPointAnnotation] = []
    @Published var region: MKCoordinateRegion?
    
    @Published var selectedMapItem: MKMapItem?
    @Published var showForm: Bool = false
    @Published var keyboardHeight: CGFloat = 0

    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @ObservedObject var manager = LocationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    var placeHolder: String = "Search a Locations"
    
    override init() {
        super.init()
        manager.checkAuthorizationStatus()
        setupSubscribers()
        listenForKeyboardNotification()
    }
    
    
    func performSearch(query: String) {
        if query == "" {
            self.mapItems = []
            return
        }
        
        var results: [MKPointAnnotation] = []
        isSearching = true
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        if let region = self.region {
            request.region = region
        }
        let localSearch = MKLocalSearch(request: request)
        
        localSearch.start { [weak self] response, error in
            guard let self = self else {return}
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            self.mapItems = response?.mapItems ?? []
            response?.mapItems.forEach({
                let annotation = MKPointAnnotation()
                annotation.title = $0.name
                annotation.coordinate = $0.placemark.coordinate
                results.append(annotation)
            })
            self.annotations = results
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.isSearching = false
            })
        }
    }
    
    func setupSubscribers() {
      manager.$userLocation
            .sink { location in
                self.currentLocation = location
            }
            .store(in: &cancellables)
        
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink {  search in
                self.performSearch(query: search)
            }
            .store(in: &cancellables)
        
        manager.$region
            .sink { region in
                self.region = region
            }
            .store(in: &cancellables)
    }
    
    fileprivate func listenForKeyboardNotification() {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
                guard let self = self else {return}
                guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
                let keyboardFrame = value.cgRectValue
                let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
                
                withAnimation(.easeOut(duration: 0.3)) {
                    self.keyboardHeight = keyboardFrame.height - (window!.safeAreaInsets.bottom + 20)
                }
            }
            
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] notification in
                guard let self = self else {return}
                
                withAnimation(.easeOut(duration: 0.5)) {
                    self.keyboardHeight = 0
                }
            }
            
           
        }

  

    
    
    
    
    
}
