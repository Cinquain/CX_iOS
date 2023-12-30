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
    @Published var currentIndex: Int = 0
    @Published var showExtraImage: Bool =  false
    
    @Published var offset: CGFloat = 550
    @Published var showSignUp: Bool = false
    @Published var statuses: [Bool] = [false, false, false, false, false, false,]
    @Published var extraImages: [String] = []
    
    @Published var showDetails: Bool = false
    @Published var showGallery: Bool = false 
    @Published var showCheckinList: Bool = false
    @Published var showBucketList: Bool = false 
    @Published var showStamp: Bool = false
    @Published var isCheckedIn: Bool = false 
    
    @Published var opacity: Double = 0
    @Published var basicAlert: Bool = false
    
    @Published var checkins: [Message] = []
    @Published private(set) var locations: [Location] = []
    @Published var saves: [Location] = []
    @Published var chatInput: String = ""
    @Published var showBuy: Bool = false 
    @Published var user: User?
    
    
    func getOwnerInfo(uid: String) {
        Task {
            do {
                let user = try await DataService.shared.getUserFrom(id: uid)
                self.user = user
            } catch {
                print("Error finding user who owns the spot", error.localizedDescription)
            }
        }
    }
    
    func checkAuth(message: String) -> Bool {
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to \(message) this location"
            showAlert.toggle()
            return false
        } else {
            return true
        }
    }
    
    func checkDistance(spot: Location) -> Bool {
        if spot.distanceFromUser < 100 {
            return true
        } else {
            normalAlert.toggle()
            alertMessage = "You have to be inside to checkin"
            print("Distance from user is: \(spot.distanceFromUser)")
            showAlert.toggle()
            return false
        }
    }

 
    //MARK: TOP 3 BUTTONS
    func seeMoreInfo() {
        
        statuses[0].toggle()
        statuses[1] = false; statuses[2] = false
        showDetails.toggle()
        
        //Animation the view
        self.opacity = showDetails ? 1 : 0
        Analytic.shared.viewedSpotInfo()
    }
    
    func likeLocation(spot: Location) {
        if checkAuth(message: "like") == false {return}
        
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
        if checkAuth(message: "bookmark") == false {return}
        
        statuses[2].toggle(); statuses[0] = false; statuses[1] = false
        statuses[3] = false; statuses[4] = false; statuses[5] = false

        showDetails = false
        
        Task {
            do {
                statuses[2] ? try await  DataService.shared.saveLocation(spot: spot) :
                try await  DataService.shared.unsaveLocation(spotId: spot.id)
                if statuses[2] {
                    let savesIds = try await DataService.shared.fetchBucketlist()
                    self.saves = try await DataService.shared.getSpotsFromIds(ids: savesIds)
                    self.showBucketList.toggle()
                    Analytic.shared.savedLocation()
                }
            } catch {
                normalAlert.toggle()
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    //MARK: BOTTOM 3 BUTTONS
    func showDirections(spot: Location) {
        if checkAuth(message: "GPS") == false {return}
        statuses[3].toggle();statuses[0] = false; statuses[1] = false
        statuses[2] = false; statuses[4] = false; statuses[5] = false
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                            UIApplication.shared.open(url, options: [:])
                        }
        } else {
            //Opens in browser
            if let url = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                            UIApplication.shared.open(url)
                        }
        }
        
    }
    
    func showImages() {
        //        if checkAuth(message: "see images of") == false {return}
        if extraImages.isEmpty || extraImages.count == 1 {return}
        showExtraImage = true
        statuses[4].toggle();statuses[0] = false; statuses[1] = false
        statuses[2] = false; statuses[3] = false; statuses[5] = false
        if currentIndex < extraImages.count - 1  {
            currentIndex += 1
            return
        } else {
            currentIndex = 0
            return
        }
        
       
        
    }
    
    func dismissView() {
        statuses[5].toggle();statuses[0] = false; statuses[1] = false
        statuses[2] = false; statuses[3] = false; statuses[4] = false
    }
    
    func printImageName(spot: Location) {
        let url = URL(string: spot.imageUrl)
        if  let name = url?.pathComponents.last {
            print("image name from url is: \(name)")
        }
    }
   
    
    //MARK: CHECK-IN LOCATION
    func checkinLocation(spot: Location) {
        if checkAuth(message: "checkin") == false {return}
        if checkDistance(spot: spot) == false {return}
        //Give User a Stamp
        //Increment Wave Count On User Object
        Task {
            do {
                try await DataService.shared.checkinLocation(spot: spot)
                DispatchQueue.main.async {
                    self.showStamp = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.normalAlert = true
                        self.alertMessage = "\(spot.name) has been added to your passport"
                        self.showAlert = true
                    })
                }
             
                
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
    
    func updateViewCount(spot: Location) {
        Task {
            do {
                try await DataService.shared.updateViewCount(spotId: spot.id)
                getOwnerInfo(uid: spot.ownerId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getAllLocations() {
        Task {
            do {
                self.locations = try await DataService.shared.fetchAllLocations()
                self.locations.sort(by: {$0.distanceFromUserinMiles < $1.distanceFromUserinMiles})
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
