//
//  LocationsViewModel.swift
//  CityXcape
//
//  Created by James Allan on 8/21/23.
//

import Foundation
import Combine


class LocationsViewModel: ObservableObject {
    
    
    @Published var offset: CGFloat = 550
    @Published var showSignUp: Bool = false
    @Published var statuses: [Bool] = [false, false, false]
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showDetails: Bool = false
    
    
    func seeMoreInfo() {
        statuses[0].toggle()
        statuses[1] = false; statuses[2] = false
        showDetails.toggle()
    }
    
    func saveToBookmark() {
        statuses[1].toggle()
        statuses[0] = false; statuses[2] = false
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to save this location"
            showAlert.toggle()
            return
        }
        //Save Location to User Bookmark DB list
        
    }
    
    func viewSaveList() {
        statuses[2].toggle()
        statuses[0] = false; statuses[1] = false
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to see others interested this location"
            showAlert.toggle()
            return
        }
    }
    
    func checkinLocation() {
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to checkin"
            showAlert.toggle()
            return
        }
        //Give user a stamp, show user list of others in the spot
        
    }
    
    
    
    
}
