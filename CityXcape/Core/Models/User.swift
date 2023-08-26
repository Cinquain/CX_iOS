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
    let username: String?
    let imageUrl: String?
    let bio: String?
    let fcmToken: String?
    
    //World Information
    let worldName: String?
    let worldImageUrl: String?
    let joinDate: Date
    
    //User Profile
    let age: Int?
    let gender: String?
    let StreetCred: Int?
    let rank: String?
    let worldId: String?
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
        self.username = data[User.CodingKeys.username.rawValue] as? String ?? nil
        self.imageUrl = data[User.CodingKeys.imageUrl.rawValue] as? String ?? nil
        self.bio = data[User.CodingKeys.bio.rawValue] as? String ?? nil
        self.fcmToken = data[User.CodingKeys.fcmToken.rawValue] as? String ?? nil
        self.worldName = data[User.CodingKeys.worldName.rawValue] as? String ?? nil
        self.worldImageUrl = data[User.CodingKeys.worldImageUrl.rawValue] as? String ?? nil
        let timestamp = data[User.CodingKeys.joinDate.rawValue] as? Timestamp
        self.joinDate = timestamp?.dateValue() ?? Date()
        self.age = data[User.CodingKeys.age.rawValue] as? Int ?? nil
        self.gender = data[User.CodingKeys.gender.rawValue] as? String ?? nil
        self.StreetCred = data[User.CodingKeys.StreetCred.rawValue] as? Int ?? nil
        self.rank = data[User.CodingKeys.rank.rawValue] as? String ?? nil
        self.worldId = data[User.CodingKeys.worldId.rawValue] as? String ?? nil
        self.footprint = data[User.CodingKeys.footprint.rawValue] as? [String: Int] ?? nil
        self.saves = data[User.CodingKeys.saves.rawValue] as? [String: Int] ?? nil
        self.email = data[User.CodingKeys.email.rawValue] as? String ?? nil
        self.phone = data[User.CodingKeys.phone.rawValue] as? String ?? nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case imageUrl
        case bio
        case fcmToken
        case worldName = "world_name"
        case worldImageUrl = "world_ImageUrl"
        case joinDate
        case age
        case gender
        case StreetCred
        case rank
        case worldId
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
    
    static let demo = User(data: data)
}
