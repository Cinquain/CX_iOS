//
//  DataService.swift
//  CityXcape
//
//  Created by James Allan on 8/9/23.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import MapKit
import SwiftUI

let db = Firestore.firestore()

final class DataService {
    
    static let shared = DataService()
    private init() {}
    
    var usersRef = db.collection(Server.users)
    var locationsRef = db.collection(Server.locations)
    var stampsRef = db.collection(Server.stamps)
    var worldsRef = db.collection(Server.worlds)
    
    
    func checkIfUserExist(uid: String) async -> Bool {
        do {
            return try await usersRef.document(uid).getDocument().exists
        } catch (let error) {
            print(error.localizedDescription)
            return false
        }
    }
    
    func createUserInDB(result: AuthDataResult) {
        let uid = result.user.uid
        let email = result.user.email ?? ""
        
        let data: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            User.CodingKeys.email.rawValue: email,
            User.CodingKeys.joinDate.rawValue: Timestamp()
        ]
        
        usersRef.document(uid).setData(data)
        
    }
    
    //MARK: LOCATION FUNCTIONS
    func fetchAllLocations() async throws -> [Location] {
        let ref = locationsRef
        var locations: [Location] = []
        print("Fetching all locations")
        
        let snapshot = try await ref.getDocuments()
        
         snapshot.documents.forEach {
            let location = Location(data:  $0.data())
            locations.append(location)
        }
        
        return locations
    }
    
    func createLocation(name: String, description: String, image: UIImage, mapItem: MKMapItem) async throws -> Bool {
        let ref = locationsRef.document()
        let spotId = ref.documentID
        
        let address = mapItem.getAddress()
        let longitude = mapItem.placemark.coordinate.longitude
        let latitude = mapItem.placemark.coordinate.latitude
        let city = mapItem.getCity()
        let userId = Auth.auth().currentUser?.uid ?? ""
        
   
        do {
            let imageURL = try await ImageManager.shared.uploadLocationImaeg(id: spotId, image: image)
            let data: [String: Any] = [
                Location.CodingKeys.id.rawValue: spotId,
                Location.CodingKeys.name.rawValue: name,
                Location.CodingKeys.description.rawValue: description,
                Location.CodingKeys.imageUrl.rawValue : imageURL,
                Location.CodingKeys.longitude.rawValue: longitude,
                Location.CodingKeys.latitude.rawValue: latitude,
                Location.CodingKeys.address.rawValue: address,
                Location.CodingKeys.city.rawValue: city,
                Location.CodingKeys.ownerId.rawValue: userId
            ]
            try await ref.setData(data)
            return true
        } catch (let error) {
            throw error
        }
                    
        //End of creating location function
    }
    
    
    
    
    
    
    //MARK: USER FUNCTIONS
    func fetchAllUsers() async throws -> [User] {
        let ref = usersRef
        var users: [User] = []
        let snapshot = try await ref.getDocuments()
        
        snapshot.documents.forEach {
            let user = User(data: $0.data())
            users.append(user)
        }
        return users
    }
    
    func fetchUsersCheckedIn(spotId: String) async throws -> [User] {
        var users: [User] = []
        let ref = locationsRef
                        .document(spotId)
                        .collection(Server.checkIns)
        let snapshot = try await ref.getDocuments()
        
        snapshot.documents.forEach {
            let user = User(data: $0.data())
            users.append(user)
        }
        return users
    }
  
    
}
