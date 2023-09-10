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

let DB = Firestore.firestore()

final class DataService {
    
    static let shared = DataService()
    private init() {}
    
    var usersRef = DB.collection(Server.users)
    var locationsRef = DB.collection(Server.locations)
    var worldsRef = DB.collection(Server.worlds)
    var privatesRef = DB.collection(Server.privates)
    var chatListener: ListenerRegistration?
    
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
    
    func createLocation(name: String, description: String, hashtag: String, image: UIImage, mapItem: MKMapItem) async throws -> Bool {
        let ref = locationsRef.document()
        let spotId = ref.documentID
        let increment: Double = 1
        let address = mapItem.getAddress()
        let longitude = mapItem.placemark.coordinate.longitude
        let latitude = mapItem.placemark.coordinate.latitude
        let city = mapItem.getCity()
        
        let userId = Auth.auth().currentUser?.uid ?? ""
        let userRef = usersRef.document(userId)


        let streetcredData: [String: Any] = [
            User.CodingKeys.StreetCred.rawValue: FieldValue.increment(increment)
        ]
              
   
        do {
            let imageURL = try await ImageManager.shared.uploadLocationImaeg(id: spotId, image: image)
            let data: [String: Any] = [
                Location.CodingKeys.id.rawValue: spotId,
                Location.CodingKeys.name.rawValue: name,
                Location.CodingKeys.description.rawValue: description,
                Location.CodingKeys.hashtags.rawValue: hashtag,
                Location.CodingKeys.imageUrl.rawValue : imageURL,
                Location.CodingKeys.longitude.rawValue: longitude,
                Location.CodingKeys.latitude.rawValue: latitude,
                Location.CodingKeys.address.rawValue: address,
                Location.CodingKeys.city.rawValue: city,
                Location.CodingKeys.ownerId.rawValue: userId
            ]
            try await ref.setData(data)
            try await userRef.updateData(streetcredData)
            return true
        } catch  {
            throw error
        }
                    
    }
    
    func saveLocation(spot: Location) async throws {
        //Update match capability of user
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let spotSaveData: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            Location.CodingKeys.dateCreated.rawValue: Timestamp()
        ]
        let userSaveData: [String: Any] = [
            Location.CodingKeys.id.rawValue: spot.id,
            Location.CodingKeys.dateCreated.rawValue: Timestamp()
        ]
        let incremenet: Double = 1
        let spotIncrementData: [String: Any] = [
            Location.CodingKeys.saveCount.rawValue: FieldValue.increment(incremenet)
        ]
        let spotSavesRef = locationsRef
                                .document(spot.id)
                                .collection(Server.saves)
                                .document(uid)
        
        let userSavesRef = privatesRef
                                .document(uid)
                                .collection(Server.saves)
                                .document(spot.id)
        let spotsRef = locationsRef.document(spot.id)
        do {
            //Save user to likes collection of Location
            try await spotSavesRef.setData(spotSaveData)
            //Save Location to saves collection of User
            try await userSavesRef.setData(userSaveData)
            //Increment likeCount of location
            try await spotsRef.updateData(spotIncrementData)
        } catch {
            throw error
        }
    }
    
    func checkinLocation(spot: Location, completion: @escaping (Result<Bool, Error>) -> Void) {
        let spotRef = locationsRef.document(spot.id)
        guard let uid = Auth.auth().currentUser?.uid else {return}
       
        let userStampsCollectionRef = privatesRef.document(uid).collection(Server.stamps).document()
        let stampId = userStampsCollectionRef.documentID

        //Save the stamp to user stamp archives
        let data: [String: Any] = [
            Stamp.CodingKeys.id.rawValue: stampId,
            Stamp.CodingKeys.spotName.rawValue: spot.name,
            Stamp.CodingKeys.spotId.rawValue: spot.id,
            Stamp.CodingKeys.ownerId.rawValue: uid,
            Stamp.CodingKeys.latitude.rawValue: spot.latitude,
            Stamp.CodingKeys.longitude.rawValue: spot.longitude,
            Stamp.CodingKeys.likeCount.rawValue: 0,
            Stamp.CodingKeys.dateCreated.rawValue: Timestamp(),
            Stamp.CodingKeys.stampImageUrl.rawValue: spot.imageUrl
        ]
        userStampsCollectionRef.setData(data) { [weak self] error in
            if let error = error {
                completion(.failure(error))
                return
            }
            //Save user to checkin collection of spot
            let spotData: [String: Any] = [
                User.CodingKeys.id.rawValue: uid,
                Stamp.CodingKeys.dateCreated.rawValue: Timestamp()
            ]
            let spotCheckinsRef = spotRef.collection(Server.checkIns).document(uid)
            spotCheckinsRef.setData(spotData)
            
            //Increment the spot checkin count by 1
            let increment: Double = 1
            let incrementData: [String: Any] = [
                Location.CodingKeys.checkinCount.rawValue: FieldValue.increment(increment)
            ]
            spotRef.updateData(incrementData)
            
            
            //Increment the user streetcred
            let streetcredIncrement: Double = 2
            let streetCredData: [String: Any] = [
                User.CodingKeys.StreetCred.rawValue: FieldValue.increment(streetcredIncrement)
            ]
            self?.usersRef.document(uid).updateData(streetCredData)
            completion(.success(true))
            return
        }
    }
    
    
    
    //MARK: USER FUNCTIONS
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
    
    func checkIfUserExist(uid: String) async -> Bool {
        do {
            return try await usersRef.document(uid).getDocument().exists
        } catch (let error) {
            print(error.localizedDescription)
            return false
        }
    }

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
    
    
    
    //MARK: MESSAGING FUNCTIONS
    func getMessages(userId: String, completion: @escaping(Result<[Message], Error>) -> ()) {
        guard let uid  = Auth.auth().currentUser?.uid else {return}
        var messages: [Message] = []
        chatListener = privatesRef
            .document(uid)
            .collection(userId)
            .addSnapshotListener({ snapshot, error in
                if let error = error {
                    print("Error fetching messages for user")
                    completion(.failure(error))
                }
                
                snapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        let message = Message(data: data)
                        messages.append(message)
                    }
                })
                DispatchQueue.main.async {
                    completion(.success(messages))
                }
            })
    }
    
    func sendMessage(user: User, content: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let fromReference = privatesRef.document(Server.messages).collection(uid).document()
        let toFeference = privatesRef.document(Server.messages).collection(user.id).document(fromReference.documentID)
        
        let data: [String: Any] = [
            Message.CodingKeys.id.rawValue: fromReference.documentID,
            Message.CodingKeys.fromId.rawValue: uid,
            Message.CodingKeys.toId.rawValue: user.id,
            Message.CodingKeys.content.rawValue: content,
            Message.CodingKeys.date.rawValue: Timestamp()
        ]
        
        do {
            try await toFeference.setData(data)
            try await fromReference.setData(data)
        }catch {
            throw error
        }
    }
    
    func removeChatListener() {
        chatListener?.remove()
        print("Removing chat listner")
    }
    
}
