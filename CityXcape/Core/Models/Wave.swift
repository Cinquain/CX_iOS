//
//  Wave.swift
//  CityXcape
//
//  Created by James Allan on 9/26/23.
//

import Foundation
import FirebaseFirestore

struct Wave: Identifiable, Equatable, Codable {
    let id: String
    let fromId: String
    let toId: String
    let content: String
    let timestamp: Date
    let location: String
    let displayName: String
    let profileUrl: String
    
    enum codingKeys: String, CodingKey {
        case id
        case fromId
        case toId
        case content
        case timestamp
        case location
        case displayName
        case profileUrl
    }
    
    static func == (lhs: Wave, rhs: Wave) -> Bool {
            return lhs.id == rhs.id
        }
    
    init(data: [String: Any]) {
        self.id = data[Wave.codingKeys.id.rawValue] as? String ?? ""
        self.fromId = data[Wave.codingKeys.fromId.rawValue] as? String ?? ""
        self.toId = data[Wave.codingKeys.toId.rawValue] as? String ?? ""
        self.content = data[Wave.codingKeys.content.rawValue] as? String ?? ""
        let time = data[Wave.codingKeys.timestamp.rawValue] as? Timestamp
        self.timestamp = time?.dateValue() ?? Date()
        self.location = data[Wave.codingKeys.location.rawValue] as? String ?? ""
        self.displayName = data[Wave.codingKeys.displayName.rawValue] as? String ?? ""
        self.profileUrl = data[Wave.codingKeys.profileUrl.rawValue] as? String ?? ""
    }
    
    static let data: [String: Any] = [
        Wave.codingKeys.id.rawValue: "fihoiahwiuhiuhfuhfu",
        Wave.codingKeys.fromId.rawValue: "hsjfkjhkjshkdhkjbhf",
        Wave.codingKeys.toId.rawValue: "fhkjhshodihjoh0w8ue0wu",
        Wave.codingKeys.content.rawValue: "How are you",
        Wave.codingKeys.timestamp.rawValue: Date(),
        Wave.codingKeys.location.rawValue: "Four Seasons",
        Wave.codingKeys.displayName.rawValue: "Amanda",
        Wave.codingKeys.profileUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FoVbS9qDAccXS0aqwHtWXvCYfGv62%2Fpexels-mahdi-chaghari-13634600.jpg?alt=media&token=81e87218-43fa-4cd7-80ea-c556cde704d8"
    ]
    
    static let demo = Wave(data: data)
    
}
