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
    
    @Published var selectedItem: UIImage? {
        didSet {
            setProfileImage(from: selectedItem)
        }
    }
    
    @Published var stampSelection: UIImage?
    
    @Published var profileImage: UIImage?
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var isUploading: Bool = false
    @Published var editSP: Bool = false 
  
    var username: String = ""
    @Published var profileUrl: String = ""
    @Published var bio: String = ""
    @Published var changedGender: Bool = false
    @Published var changedAge: Bool = false
    @Published var changedStatus: Bool = false
    @Published var success: Bool = false

    @Published var showBucketList: Bool = false
    @Published var bucketList: [Location] = []
    
    @Published var showPicker: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showActionSheet: Bool = false 
    
    
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
    
    
    @Published var stampImageUrl = ""
    @Published var spotImageUrl = ""
    @Published var imageSelection: UIImage?  = nil {
        didSet {
            setSpotImage(from: imageSelection)
        }
    }
    @Published var isMale: Bool = true {
        didSet {
            changedGender = true
        }
    }
    @Published var single: Bool = false {
        didSet {
            changedStatus = true
        }
    }
    
    @Published var age: Int = 0 {
        didSet {
            changedAge = true
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
                DispatchQueue.main.async {
                    self.showBucketList.toggle()
                }
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
                DispatchQueue.main.async {
                    self.showDiary.toggle()
                }
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func editStreetPass() {
        editSP.toggle()
    }
   
    
    //MARK: LOCATION EDIT FUNCTIONS
    func setSpotImage(from selection: UIImage?) {
        guard let selection else {return}
        isUploading = true
        Task {
            do {
                spotImageUrl = try await ImageManager.shared.uploadLocationImage(id: spotId, image: selection)
                spotImage = selection
                isUploading = false
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
                isUploading = false 
                return
            }
        }
    }
    
    func submitLocationChanges(spotId: String) {
        if !editTitle.isEmpty {
            changeTitle(id: spotId)
        }
        if !editDetails.isEmpty {
            changeDetails(id: spotId)
        }
        if !longitude.isEmpty {
            changeLong(id: spotId)
        }
        if !latitude.isEmpty {
            changeLat(id: spotId)
        }
    }
    
    func changeTitle(id: String) {
        Task {
            do {
                try await DataService.shared.updateTitle(spotId: id, title: editTitle)
                errorMessage = "Updated Successfully"
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
                errorMessage = "Updated Successfully"
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

    private func setProfileImage(from selection: UIImage?) {
        guard let selection else {return}
        let uid = Auth.auth().currentUser?.uid ?? ""
        Task {
            do {
                profileImage = selection
                let imageUrl = try await ImageManager.shared.uploadProfileImage(uid: uid, image: selection)
                try await DataService.shared.updateImageUrl(url: imageUrl)
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
        
        if username.isEmpty {
            errorMessage = "Please create a username 😤"
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
                try AuthService.shared.signOut()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    
    func submitProfileChanges() {
        
        if !username.isEmpty {
            UserDefaults.standard.set(username, forKey: AppUserDefaults.username)
            let data: [String: Any] = [
                User.CodingKeys.username.rawValue: username
            ]
            updateData(data: data)
            username = ""
        }
        if !bio.isEmpty {
            UserDefaults.standard.set(bio, forKey: AppUserDefaults.bio)
            let data: [String: Any] = [
                User.CodingKeys.bio.rawValue: bio
            ]
            updateData(data: data)
            bio = ""
        }
        
        if changedStatus {
            let data: [String: Any] = [
                "single": single
            ]
            updateData(data: data)
            changedStatus = false 
        }
        
        if changedGender {
            let data: [String: Any] = [
                "isMale": isMale
            ]
            updateData(data: data)
            changedGender = false
        }
        
        if changedAge {
            UserDefaults.standard.set(age, forKey: AppUserDefaults.age)
            let data: [String: Any] = [
                "Age": age
            ]
            updateData(data: data)
            age = 0
            changedAge = false
        }
      
    }
    
    func updateData(data: [String: Any]) {
        Task {
            do {
                try await DataService.shared.updateStreetPass(data: data)
                errorMessage = "StreetPass Successfully Updated!"
                showError.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    
    
}
