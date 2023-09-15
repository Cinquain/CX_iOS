//
//  Stamp.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import Foundation
import FirebaseFirestore

struct Stamp: Identifiable, Equatable, Codable {
    
    let id: String
    let spotName: String
    let spotId: String
    let timestamp: Date
    let longitude: Double
    let latitude: Double
    let stampImageUrl: String
    let likeCount: Int
    let ownerId: String
 
    
    static func == (lhs: Stamp, rhs: Stamp) -> Bool {
            return lhs.id == rhs.id
        }
    
    init(data: [String: Any]) {
        self.id = data[Stamp.CodingKeys.id.rawValue] as? String ?? ""
        self.spotId = data[Stamp.CodingKeys.spotId.rawValue] as? String ?? ""
        self.spotName = data[Stamp.CodingKeys.spotName.rawValue] as? String ?? ""
        self.longitude = data[Stamp.CodingKeys.longitude.rawValue] as? Double ?? 0
        self.latitude = data[Stamp.CodingKeys.latitude.rawValue] as? Double ?? 0
        self.stampImageUrl = data[Stamp.CodingKeys.stampImageUrl.rawValue] as? String ?? ""
        self.likeCount = data[Stamp.CodingKeys.likeCount.rawValue] as? Int ?? 0
        self.ownerId = data[Stamp.CodingKeys.ownerId.rawValue] as? String ?? ""
        let timestamp =  data[Stamp.CodingKeys.timestamp.rawValue] as? Timestamp
        self.timestamp = timestamp?.dateValue() ?? Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case spotName
        case spotId
        case timestamp
        case longitude
        case latitude
        case stampImageUrl = "stamp_imageUrl"
        case likeCount = "like_count"
        case ownerId = "owner_id"
    }
}
