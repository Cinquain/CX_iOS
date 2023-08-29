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
    @Published var showFavorites: Bool = false 
    @Published var showStamp: Bool = false
    //Animation Values
    @Published var opacity: Double = 0
    @Published var users: [User] = []
    @Published var basicAlert: Bool = false 
    @Published private(set) var locations: [Location] = []
    @Published var myJourney: [Location] = [Location.demo2, Location.demo1]

    
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
    
    func saveToBookmark(spot: Location) {
        statuses[1].toggle()
        statuses[0] = false; statuses[2] = false
        showDetails = false 
//        if AuthService.shared.uid == nil {
//            alertMessage = "You need an account to like this location"
//            showAlert.toggle()
//            return
//        }
        //Save Location to saves collection of User
        
        //Save user to likes collection of Location
        
        //Update location dictionary of user,
        //then show a pop showing the list of saved locations
        //place most recent saves at the top
        
        //Update match capability of user
        
        //Show user save list
        myJourney.append(spot)
        self.myJourney = myJourney.unique()
        showFavorites.toggle()
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
            self.offset = 100
        }
    }
    
    func checkinLocation(id: String) {
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to checkin"
            showAlert.toggle()
            return
        }
        
        //Check if user distance is at location
        
        //Increment the spot checkin count by 1
        
        //Increment the user footrail
        
        //Save the stamp to user stamp archives
        
        
        //Give user a stamp, show user list of others in the spot
        showStamp.toggle()
        

    }
    
    
    func getAllLocations() async throws {
        self.locations = try await DataService.shared.fetchAllLocations()
    }
    
    
    
    
    
}
