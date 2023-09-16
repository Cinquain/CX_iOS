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
    var messageRef = DB.collection(Server.messages)
    var chatListener: ListenerRegistration?
    var recentMessageListener: ListenerRegistration?
    
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
    
    func createLocation(name: String, description: String, hashtag: String, image: UIImage, mapItem: MKMapItem) async throws {
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
            User.CodingKeys.streetCred.rawValue: FieldValue.increment(increment)
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
    
    func checkinLocation(spot: Location) async throws {
        let spotRef = locationsRef.document(spot.id)
        guard let uid = Auth.auth().currentUser?.uid else {return}
       
        let userStampsCollectionRef = privatesRef.document(uid).collection(Server.stamps).document()
        let spotCheckinsRef = spotRef.collection(Server.checkIns).document(uid)
        let stampId = userStampsCollectionRef.documentID
        let userRef = usersRef.document(uid)
        //Save the stamp to user stamp archives
        let data: [String: Any] = [
            Stamp.CodingKeys.id.rawValue: stampId,
            Stamp.CodingKeys.spotName.rawValue: spot.name,
            Stamp.CodingKeys.spotId.rawValue: spot.id,
            Stamp.CodingKeys.ownerId.rawValue: uid,
            Stamp.CodingKeys.latitude.rawValue: spot.latitude,
            Stamp.CodingKeys.longitude.rawValue: spot.longitude,
            Stamp.CodingKeys.likeCount.rawValue: 0,
            Stamp.CodingKeys.timestamp.rawValue: Timestamp(),
            Stamp.CodingKeys.stampImageUrl.rawValue: spot.imageUrl
        ]
        
        let spotData: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            Stamp.CodingKeys.timestamp.rawValue: Timestamp(),
            
        ]
        
        //Increment the spot checkin count by 1
        let increment: Double = 1
        let incrementData: [String: Any] = [
            Location.CodingKeys.checkinCount.rawValue: FieldValue.increment(increment)
        ]
        
        let streetcredIncrement: Double = 2
        let streetCredData: [String: Any] = [
            User.CodingKeys.streetCred.rawValue: FieldValue.increment(streetcredIncrement)
        ]
        
        try await userStampsCollectionRef.setData(data)
        try await spotCheckinsRef.setData(spotData)
        try await spotRef.updateData(incrementData)
        try await userRef.updateData(streetCredData)

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
    
    func uploadStreetPass(imageUrl: String, username: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = usersRef.document(uid)
        
        let data: [String: Any] = [
            User.CodingKeys.imageUrl.rawValue: imageUrl,
            User.CodingKeys.username.rawValue: username
        ]
        try await ref.setData(data)
    }
    
    func deleteUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        try await ImageManager.shared.deleteUserProfile(uid: uid)
        try await usersRef.document(uid).delete()
        try await Auth.auth().currentUser?.delete()
    }
    
    
    //MARK: MESSAGING FUNCTIONS
    func getMessages(userId: String, completion: @escaping(Result<[Message], Error>) -> ()) {
        guard let uid  = Auth.auth().currentUser?.uid else {return}
        var messages: [Message] = []
        chatListener = messageRef
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
        let fromReference = messageRef.document(uid).collection(user.id).document()
        let toFeference = messageRef.document(user.id).collection(uid).document()
        
        let data: [String: Any] = [
            Message.CodingKeys.id.rawValue: fromReference.documentID,
            Message.CodingKeys.fromId.rawValue: uid,
            Message.CodingKeys.toId.rawValue: user.id,
            Message.CodingKeys.content.rawValue: content,
            Message.CodingKeys.timestamp.rawValue: Timestamp()
        ]
        
        do {
            try await toFeference.setData(data)
            try await fromReference.setData(data)
            try await persistRecentMessage(id: user.id, data: data)
        }catch {
            throw error
        }
    }
    
    func persistRecentMessage(id: String, data: [String: Any]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let recentRef = privatesRef
                            .document(Server.recentMessages)
                            .collection(id).document(uid)
        
        try await recentRef.setData(data)
    }
    
    func removeChatListener() {
        chatListener?.remove()
        print("Removing chat listner")
    }
    
    func fetchRecentMessages(completion: @escaping (Result<[RecentMessage], Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var messages: [RecentMessage] = []
        
        recentMessageListener = privatesRef
                .document(Server.recentMessages)
                .collection(uid)
                .addSnapshotListener({ querySnapshot, error in
                    if let error = error {
                        print("Error fetching recent messages", error.localizedDescription)
                        completion(.failure(error))
                    }
                    
                    guard let snapshot = querySnapshot else {return}
                    
                    snapshot.documentChanges.forEach { change in
                        if change.type == .added {
                            let data = change.document.data()
                            let message = RecentMessage(data: data)
                            messages.insert(message, at: 0)
                        }
                    }
                    completion(.success(messages))
                })
    }
    
    
    func deleteRecentMessage(userId: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        privatesRef
            .document(uid)
            .collection(Server.recentMessages)
            .document(userId)
            .delete()
    }
    
    
    
}
