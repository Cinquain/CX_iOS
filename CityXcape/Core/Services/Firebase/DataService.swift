//
//  DataService.swift
//  CityXcape
//
//  Created by James Allan on 8/9/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth



let db = Firestore.firestore()

final class DataService {
    
    static let shared = DataService()
    private init() {}
    
    var usersRef = db.collection(Server.users)
    var spotsRef = db.collection(Server.spots)
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
            User.CodingKeys.email.rawValue: email
        ]
        
        usersRef.document(uid).setData(data)
        
    }
  
    
}
