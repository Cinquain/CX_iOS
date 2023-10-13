//
//  StreetPassViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/4/23.
//

import SwiftUI
import MapKit
import PhotosUI
import FirebaseAuth

class StreetPassViewModel: NSObject, ObservableObject {
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            setImage(from: selectedItem)
        }
    }
    
    @Published var profileImage: UIImage?
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var isUploading: Bool = false
  
    @Published var username: String = ""
    @Published var profileUrl: String = ""
    @Published var success: Bool = false

    @Published var showBucketList: Bool = false
    @Published var bucketList: [Location] = []
    
    
    @Published var showDiary: Bool = false
    @Published var stamps: [Stamp] = []
    
    @Published var showStreetRep: Bool = false
    @Published var uploads: [Location] = []
    @Published var currentSpot: Location?
    @Published var data: [(name: String, count: Int)] = []

    @Published var metricsCategory: MetricCategory = .Views
    @Published var spotMetric: SpotMetric = .Metrics
    @Published var users: [User] = []
    
    @Published var spotId: String = ""
    @Published var editTitle: String = ""
    @Published var editDetails: String = ""
    @Published var spotImage: UIImage?
    @Published var longitude: String = ""
    @Published var latitude: String = ""
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setSpotImage(from: imageSelection)
        }
    }
    
    func fetchUploads() {
        Task {
            do {
                let uploadIds = try await DataService.shared.fetchUserUploads()
                self.uploads = try await DataService.shared.getSpotsFromIds(ids: uploadIds)
                self.calculateAnalytics()
                showStreetRep.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func calculateAnalytics() {
        let totalLikes = uploads.reduce(0, {$0 + $1.likeCount})
        let totalSaves = uploads.reduce(0, {$0 + $1.saveCount})
        let totalCheckins = uploads.reduce(0, {$0 + $1.checkinCount})
        let totalViews = uploads.reduce(0, {0 + $1.viewCount})
        data.append((name: "Likes", count: totalLikes))
        data.append((name: "Saves", count: totalSaves))
        data.append((name: "Check-ins", count: totalCheckins))
        data.append((name: "Views", count: totalViews))
    }
    
    //MARK: PRIMARY ACTIONS
    func fetchBucketList() {
        Task {
            do {
                let saveIds = try await DataService.shared.fetchBucketlist()
                self.bucketList = try await DataService.shared.getSpotsFromIds(ids: saveIds)
                showBucketList.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func fetchStamps() {
        Task {
            do {
                self.stamps = try await DataService.shared.fetchallstamps()
                showDiary.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
   
    
    //MARK: LOCATION EDIT FUNCTIONS
    func setSpotImage(from selection: PhotosPickerItem?) {
        guard let selection else {return}
        isUploading = true
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                guard let data, let uiImage = UIImage(data: data) else {return}
                let _ = try await ImageManager.shared.uploadLocationImage(id: spotId, image: uiImage)
                spotImage = uiImage
                isUploading = false
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
                isUploading = false 
                return
            }
        }
    }
    
    func changeTitle(id: String) {
        Task {
            do {
                try await DataService.shared.updateTitle(spotId: id, title: editTitle)
                errorMessage = "Title Changed Successfully"
                editTitle = ""
                showError.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func changeDetails(id: String) {
        Task {
            do {
                try await DataService.shared.updateDetail(spotId: id, detail: editDetails)
                errorMessage = "Description Changed Successfully"
                editDetails = ""
                showError.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func changeLong(id: String) {
        Task {
            do {
                try await DataService.shared.updateLongitude(spotId: id, longitude: longitude)
                errorMessage = "Longitude Changed Successfully"
                longitude = ""
                showError.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }

    }
    
    func changeLat(id: String) {
        Task {
            do {
                try await DataService.shared.updateLatitude(spotId: id, latitude: latitude)
                errorMessage = "Title Latitude Successfully"
                latitude = ""
                showError.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }

    }
    
}

extension StreetPassViewModel {
    //MARK: USER MANAGEMENT

    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else {return}
        let uid = Auth.auth().currentUser?.uid ?? ""
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                guard let data, let uiImage = UIImage(data: data) else {return}
                let imageUrl = try await ImageManager.shared.uploadProfileImage(uid: uid, image: uiImage)
                await MainActor.run(body: {
                    self.profileUrl = imageUrl
                })
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
                return
            }
        }
    }
    
    func createStreetPass() {
        isUploading = true
        if profileImage == nil {
            errorMessage = "Upload a photo for your Street ID Card"
            showError.toggle()
            isUploading = false
            return
        }
        
        if username.count < 3 {
            errorMessage = "Username should be at least 3 characters 😤"
            showError.toggle()
            isUploading = false
            return
        }
        
        Task {
            do {
                try await DataService.shared.uploadStreetPass(imageUrl: profileUrl, username: username)
                self.success = true 
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
      
        
    }
    
    func signOut() {
        //Sign out & clear user defaults
        do {
            try AuthService.shared.signOut()
        } catch {
            errorMessage = error.localizedDescription
            showError.toggle()
        }
    }
    
    func deleteAccount() {
        Task {
            do {
                try await DataService.shared.deleteUser()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    
    
}
