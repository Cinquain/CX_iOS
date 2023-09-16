//
//  User.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Equatable, Codable {
    
    let id: String
    let username: String
    let imageUrl: String
    
    let bio: String?
    let fcmToken: String?
    
    //World Information
    let joinDate: Date?
    
    //User Profile
    let streetCred: Int?
    let footprint: [String: Int]?
    let saves: [String: Int]?
//
    //Contact Info
    let email: String?
    let phone: String?
    
    static func == (lhs: User, rhs: User) -> Bool {
            return lhs.id == rhs.id
        }
    
    init(data: [String: Any]) {
        self.id = data[User.CodingKeys.id.rawValue] as? String ?? ""
        self.username = data[User.CodingKeys.username.rawValue] as? String ?? ""
        self.imageUrl = data[User.CodingKeys.imageUrl.rawValue] as? String ?? ""
        self.bio = data[User.CodingKeys.bio.rawValue] as? String ?? nil
        self.fcmToken = data[User.CodingKeys.fcmToken.rawValue] as? String ?? nil
        let timestamp = data[User.CodingKeys.joinDate.rawValue] as? Timestamp
        self.joinDate = timestamp?.dateValue() ?? Date()
        self.streetCred = data[User.CodingKeys.streetCred.rawValue] as? Int ?? nil
        self.footprint = data[User.CodingKeys.footprint.rawValue] as? [String: Int] ?? nil
        self.saves = data[User.CodingKeys.saves.rawValue] as? [String: Int] ?? nil
        self.email = data[User.CodingKeys.email.rawValue] as? String ?? nil
        self.phone = data[User.CodingKeys.phone.rawValue] as? String ?? nil
    }
    
    init(message: RecentMessage) {
        self.id = message.fromId
        self.imageUrl = message.profileUrl
        self.username = message.displayName
        self.bio = nil
        self.fcmToken = nil
        self.streetCred = nil
        self.joinDate = nil
        self.email = nil
        self.phone = nil
        self.footprint = nil
        self.saves = nil
    }
    
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case imageUrl
        case bio
        case fcmToken
        case joinDate
        case streetCred
        case footprint
        case saves
        case email
        case phone
    }
    
    static let data : [String: Any] = [
        User.CodingKeys.id.rawValue: "oVbS9qDAccXS0aqwHtWXvCYfGv62",
        User.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FoVbS9qDAccXS0aqwHtWXvCYfGv62%2Fpexels-mahdi-chaghari-13634600.jpg?alt=media&token=81e87218-43fa-4cd7-80ea-c556cde704d8",
        User.CodingKeys.joinDate.rawValue: Timestamp(),
        User.CodingKeys.username.rawValue: "Amanda"
    ]
    
    static let data2: [String: Any] =  [
        User.CodingKeys.id.rawValue: "oVbr47547757DAccXS0aqwHtWXvCYfGv62",
        User.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2Foyda5lEqnnt4dqqUr8oV%2F5-min.jpg?alt=media&token=781a7ed9-c9ff-4b89-94f9-ee1f52254f8c",
        User.CodingKeys.joinDate.rawValue: Timestamp(),
        User.CodingKeys.username.rawValue: "Chris"
    ]
    
    static let data3: [String: Any] =  [
        User.CodingKeys.id.rawValue: "r884775857757DAccXS0aqwHtWXvCYfGv62",
        User.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FyI176yL3l9bTrWgAVzyj3z6ML1E3%2Fpexels-marlon-schmeiski-3115708-min.jpg?alt=media&token=7a735586-6e9e-4d05-90eb-a5baee8d40a3",
        User.CodingKeys.joinDate.rawValue: Timestamp(),
        User.CodingKeys.username.rawValue: "Jannette"
    ]
    
    
    static let data4: [String: Any] =  [
        User.CodingKeys.id.rawValue: "r8847t0t009y9y0y95047757DAccXS0aqwHtWXvCYfGv62",
        User.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FW6EUJxka1OihhJ0Iyest%2F2-min.jpg?alt=media&token=1930940d-704f-42b1-aa2b-cd8c919b0161",
        User.CodingKeys.joinDate.rawValue: Timestamp(),
        User.CodingKeys.username.rawValue: "Cinquain"
    ]
    
    
    static let demo = User(data: data)
    static let demo2 = User(data: data2)
    static let demo3 = User(data: data3)
    static let demo4 = User(data: data4)

}
