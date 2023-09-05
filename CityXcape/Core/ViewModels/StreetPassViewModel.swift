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
    @Published var showAlert: Bool = false
    @Published var profileUrl: String = "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FoVbS9qDAccXS0aqwHtWXvCYfGv62%2Fpexels-mahdi-chaghari-13634600.jpg?alt=media&token=81e87218-43fa-4cd7-80ea-c556cde704d8"
    
  
    
    
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
                errorMessage = error.localizedDescription
                showAlert.toggle()
                return
            }
        }
    }
    
    
    
}
