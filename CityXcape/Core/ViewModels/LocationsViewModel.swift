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
    @AppStorage(AppUserDefaults.streetcred) var streetcred: Int?
    @AppStorage(AppUserDefaults.uid) var uid: String?

    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var normalAlert: Bool = false
    
    
    @Published var offset: CGFloat = 550
    @Published var showSignUp: Bool = false
    @Published var statuses: [Bool] = [false, false, false]
  
    
    @Published var showDetails: Bool = false
    @Published var showCheckinList: Bool = false
    @Published var showBucketList: Bool = false 
    @Published var showStamp: Bool = false
    @Published var isCheckedIn: Bool = false 
    
    @Published var opacity: Double = 0
    @Published var basicAlert: Bool = false
    
    @Published var checkins: [Message] = [Message.demo, Message.demo2, Message.demo3]
    @Published private(set) var locations: [Location] = []
    @Published var saves: [Location] = []
    @Published var chatInput: String = ""
    @Published var showBuy: Bool = false 
    
    func seeMoreInfo() {
        
        statuses[0].toggle()
        statuses[1] = false; statuses[2] = false
        showDetails.toggle()
        
        //Animation the view
        self.opacity = showDetails ? 1 : 0
    }
    
    func likeLocation(spot: Location) {
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to checkin"
            showAlert.toggle()
            return
        }
        
        statuses[1].toggle()
        statuses[0] = false; statuses[2] = false
        showDetails = false
        
        Task {
            do {
                statuses[1] ? try await DataService.shared.like(spot: spot) :
                              try await DataService.shared.dislike(spot: spot)
            } catch {
                normalAlert.toggle()
                alertMessage = error.localizedDescription
                showAlert.toggle()
                normalAlert = false
            }
        }
        
    }
    
    func saveToBookmark(spot: Location) {
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to like this location"
            showAlert.toggle()
            return
        }
        
        statuses[2].toggle()
        statuses[0] = false; statuses[1] = false
        showDetails = false
        
        Task {
            do {
                statuses[2] ? try await  DataService.shared.saveLocation(spot: spot) :
                try await  DataService.shared.unsaveLocation(spotId: spot.id)
                if statuses[2] {
                    let savesIds = try await DataService.shared.fetchBucketlist()
                    self.saves = try await DataService.shared.getSpotsFromIds(ids: savesIds)
                    self.showBucketList.toggle()
                }
            } catch {
                normalAlert .toggle()
                alertMessage = error.localizedDescription
                showAlert.toggle()
                normalAlert = false
            }
        }
        
    }

    func checkinLocation(spot: Location) {
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to checkin"
            showAlert.toggle()
            return
        }
        
        //Check if user distance is at location
//        guard spot.distanceFromUser < 100 else {
//            alertMessage = "You Need to be Inside to Checkin"
//            showAlert.toggle()
//            return
//        }
        
        //Give User a Stamp
        //Increment Wave Count On User Object
        Task {
            do {
                try await DataService.shared.checkinLocation(spot: spot)
                self.showStamp = true
                loadCheckin(id: spot.id)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    //Show user list of others in the spot
                    self.showCheckinList = true
                    self.statuses[2] = true
                    self.isCheckedIn = true
                    UserDefaults.standard.set(spot.name, forKey: AppUserDefaults.location)
                    UserDefaults.standard.set(spot.id, forKey: AppUserDefaults.spotId)
                })
            } catch {
                normalAlert.toggle()
                alertMessage = error.localizedDescription
                self.showAlert = true
                normalAlert = false 
            }
        }
    }
    
    func loadCheckin(id: String) {
        DataService.shared.fetchUsersCheckedIn(spotId: id) { result in
            switch result {
            case .success(let messages):
                self.checkins = messages
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                self.showAlert.toggle()
            }
        }
    }
    
    func updateViewCount(id: String) {
        Task {
            do {
                try await DataService.shared.updateViewCount(spotId: id)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getAllLocations() {
        Task {
            do {
                self.locations = try await DataService.shared.fetchAllLocations()
                self.locations.sort(by: {$0.distanceFromUser < $1.distanceFromUser})
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func checkOut(spot: Location) {
        isCheckedIn = false
        //Make network call to remove user from checkin list
        showStamp = false 
        showCheckinList = false
        statuses[2] = false; statuses[0] = false; statuses[1] = false
        Task {
            do {
                try await DataService.shared.checkoutLocation(spot: spot)
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func sendMessage(id: String) {
        Task {
            do {
                try await DataService.shared.sendLobbyMessage(content: chatInput, spotId: id)
                chatInput = ""
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func showCheckOutAlert() {
        alertMessage = "Please check out before closing location"
        showAlert.toggle()
    }
    
    
    
}
