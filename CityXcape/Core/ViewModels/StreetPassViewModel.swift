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
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isUploading: Bool = false
  
    @Published var username: String = ""
    @Published var profileUrl: String = ""
    @Published var success: Bool = false

    @Published var showBucketList: Bool = false
    @Published var bucketList: [Save] = []
    
    
    @Published var showDiary: Bool = false
    @Published var stamps: [Stamp] = []
}

extension StreetPassViewModel {
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
                alertMessage = error.localizedDescription
                showAlert.toggle()
                return
            }
        }
    }
    
    func createStreetPass() {
        isUploading = true
        if profileImage == nil {
            alertMessage = "Upload a photo for your Street ID Card"
            showAlert.toggle()
            isUploading = false
            return
        }
        
        if username.count < 3 {
            alertMessage = "Username should be at least 3 characters 😤"
            showAlert.toggle()
            isUploading = false
            return
        }
        
        Task {
            do {
                try await DataService.shared.uploadStreetPass(imageUrl: profileUrl, username: username)
                self.success = true 
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
      
        
    }
    
    
    func fetchBucketList() {
        Task {
            do {
                self.bucketList = try await DataService.shared.fetchBucketlist()
                showBucketList.toggle()
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func fetchStamps() {
        Task {
            do {
                self.stamps = try await DataService.shared.fetchallstamps()
                showDiary.toggle()
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func signOut() {
        //Sign out & clear user defaults
        do {
            try AuthService.shared.signOut()
        } catch {
            alertMessage = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func deleteAccount() {
        Task {
            do {
                try await DataService.shared.deleteUser()
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    
    
}
