//
//  LocationsViewModel.swift
//  CityXcape
//
//  Created by James Allan on 8/21/23.
//

import Foundation
import Combine
import SwiftUI

class LocationsViewModel: ObservableObject {
    
    
    @Published var offset: CGFloat = 550
    @Published var showSignUp: Bool = false
    @Published var statuses: [Bool] = [false, false, false]
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showDetails: Bool = false
    @Published var showCheckinList: Bool = false
    
    //Animation Values
    @Published var opacity: Double = 0
    @Published var users: [User] = []
    @Published private(set) var locations: [Location] = []
    
    func seeMoreInfo() {
        
        statuses[0].toggle()
        statuses[1] = false; statuses[2] = false
        showDetails.toggle()
        
        //Animation the view
        if showDetails {
            opacity = 1
        } else {
            opacity = 0
        }
        
    }
    
    func saveToBookmark() {
        statuses[1].toggle()
        statuses[0] = false; statuses[2] = false
        showDetails = false 
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to like this location"
            showAlert.toggle()
            return
        }
        //Save Location to User Bookmark DB list
        
    }
    
    func viewCheckinList(id: String) {
        statuses[2].toggle()
        statuses[0] = false; statuses[1] = false
        showDetails = false
//        if AuthService.shared.uid == nil {
//            alertMessage = "Please check-in to see who's in this location"
//            showAlert.toggle()
//            return
//        }
        
        Task {
            print("fetching users")
            self.users = try await DataService.shared.fetchUsersCheckedIn(spotId: id)
            showCheckinList.toggle()
            statuses[2] = false 
        }
    }
    
    func checkinLocation(id: String) {
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to checkin"
            showAlert.toggle()
            return
        }
        //Give user a stamp, show user list of others in the spot
        

    }
    
    
    func getAllLocations() async throws {
        self.locations = try await DataService.shared.fetchAllLocations()
    }
    
    
    
    
    
}
