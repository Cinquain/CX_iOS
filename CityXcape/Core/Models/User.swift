//
//  User.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import Foundation


struct User: Identifiable, Equatable, Codable {
    
    let id: String
    let username: String
    let profileUrl: String
    let bio: String?
    let fcmToken: String?
    
    //World Information
    let worldName: String
    let wordImageUrl: String
    let joinDate: Date
    
    //User Profile
    let age: Int
    let gender: String
    let StreetCred: Int
    let rank: String
    let worldId: String
    let footprint: [String: Int]
    let saves: [String: Int]
    
    //Contact Info
    let email: String
    let phone: String
    
    static func == (lhs: User, rhs: User) -> Bool {
            return lhs.id == rhs.id
        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.profileUrl = try container.decode(String.self, forKey: .profileUrl)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
        self.fcmToken = try container.decodeIfPresent(String.self, forKey: .fcmToken)
        self.worldName = try container.decode(String.self, forKey: .worldName)
        self.wordImageUrl = try container.decode(String.self, forKey: .wordImageUrl)
        self.joinDate = try container.decode(Date.self, forKey: .joinDate)
        self.age = try container.decode(Int.self, forKey: .age)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.StreetCred = try container.decode(Int.self, forKey: .StreetCred)
        self.rank = try container.decode(String.self, forKey: .rank)
        self.worldId = try container.decode(String.self, forKey: .worldId)
        self.footprint = try container.decode([String : Int].self, forKey: .footprint)
        self.saves = try container.decode([String : Int].self, forKey: .saves)
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.profileUrl, forKey: .profileUrl)
        try container.encodeIfPresent(self.bio, forKey: .bio)
        try container.encodeIfPresent(self.fcmToken, forKey: .fcmToken)
        try container.encode(self.worldName, forKey: .worldName)
        try container.encode(self.wordImageUrl, forKey: .wordImageUrl)
        try container.encode(self.joinDate, forKey: .joinDate)
        try container.encode(self.age, forKey: .age)
        try container.encode(self.gender, forKey: .gender)
        try container.encode(self.StreetCred, forKey: .StreetCred)
        try container.encode(self.rank, forKey: .rank)
        try container.encode(self.worldId, forKey: .worldId)
        try container.encode(self.footprint, forKey: .footprint)
        try container.encode(self.saves, forKey: .saves)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.phone, forKey: .phone)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case profileUrl
        case bio
        case fcmToken
        case worldName = "world_name"
        case wordImageUrl = "world_ImageUrl"
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
}
