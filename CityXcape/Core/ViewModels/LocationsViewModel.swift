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
        self.opacity = showDetails ? 1 : 0
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
            self.offset = 100
        }
    }
    
    func checkinLocation(spot: Location) {
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to checkin"
            showAlert.toggle()
            return
        }
        
        //Check if user distance is at location
            //Give User a Stamp
            showStamp.toggle()

            
            
            

            Task {
                self.users = try await DataService.shared.fetchUsersCheckedIn(spotId: spot.id)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    //Show user list of others in the spot
                    self.showCheckinList.toggle()
                    self.statuses[2] = true
                    self.offset = 100
                })
            }
        
//            alertMessage = "You Need to be Inside to Checkin"
//            showAlert.toggle()
            return
        
    }
    
    
    func getAllLocations() async throws {
        self.locations = try await DataService.shared.fetchAllLocations()
    }
    
    
    
    
    
}
