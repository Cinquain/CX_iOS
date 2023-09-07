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
import PhotosUI



class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var isSearching: Bool = false
    @Published var searchQuery: String = ""
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var mapItems: [MKMapItem] = []
    @Published var annotations: [MKPointAnnotation] = []
    @Published var region: MKCoordinateRegion?
    
    @Published var selectedMapItem: MKMapItem?
    @Published var showForm: Bool = false
    @Published var keyboardHeight: CGFloat = 0

    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var completeForm: Bool = false
    
    @ObservedObject var manager = LocationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    var placeHolder: String = "Search a Locations"
    
    //MARK: PROPERTIES FOR POSTING
    @Published var spotName: String = ""
    @Published var spotDescription: String = ""
    @Published var hashtags: String = ""
    @Published var isPosting: Bool = false
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    @Published var selectedImage: UIImage? = nil
    @Published var showSignUp: Bool = false
    @Published var errorMessage: String = ""
    @Published var showCongrats: Bool = false
    
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

extension MapViewModel {
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else {return}
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                guard let data, let uiImage = UIImage(data: data) else {return}
                selectedImage = uiImage
            } catch {
                errorMessage = error.localizedDescription
                showAlert.toggle()
                return
            }
        }
    }
    
    private func convertoHashTags() {
        var newWords: [String] = []
        let wordsArray = hashtags.components(separatedBy: " ")
        
        wordsArray.forEach {
            if $0.count > 0 {
                if $0.contains("#") {
                    let newWord = $0.replacingOccurrences(of: "#", with: "")
                    newWords.append("#\(newWord.capitalizingFirstLetter())")
                } else {
                    let newWord = "#\($0.capitalizingFirstLetter())"
                    newWords.append(newWord)
                }
            }
        }
        self.hashtags = ""
        var count = 1
        newWords.forEach {
            if count == 3 {return}
            self.hashtags += "\($0)"
            count += 1
        }
    }
    
    func submitLocation() {
        isPosting = true 
        if spotName.count < 4 {
            alertMessage = "Name needs at least four characters"
            showAlert.toggle()
            isPosting.toggle()
            return
        }
        
        if description.count < 10 {
            alertMessage = "Description needs to be at least 10 characters long"
            showAlert.toggle()
            isPosting.toggle()
            return
        }
        
        if selectedImage == nil {
            alertMessage = "Please add an image to your location"
            showAlert.toggle()
            isPosting.toggle()
            return
        }
        
        if hashtags.count > 3 {
            alertMessage = "Please add a hashtag at least 3 characters long"
            showAlert.toggle()
            isPosting.toggle()
            return
        }
        
        
        guard let image = selectedImage, let mapitem = selectedMapItem else {return}
        Task {
            do {
                let result = try await  DataService.shared
                                        .createLocation(name: spotName,
                                                        description: description,
                                                        hashtag: hashtags,
                                                        image: image, mapItem: mapitem)
                isPosting = false
                if result {completeForm.toggle()}
            } catch {
                errorMessage = error.localizedDescription
                showAlert.toggle()
                isPosting.toggle()
                return
            }
           
        }
        //End of submitting form
    }
    
    
}


