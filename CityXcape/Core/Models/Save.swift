//
//  Save.swift
//  CityXcape
//
//  Created by James Allan on 10/3/23.
//

import Foundation
import FirebaseFirestore


struct Save: Codable, Identifiable, Equatable {
    let name: String
    let longitude: Double
    let latitude: Double
    let imageUrl: String
    let id: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case name
        case longitude
        case latitude
        case imageUrl
        case id
        case timestamp
    }
    
    init(data: [String: Any]) {
        self.id = data[Save.CodingKeys.id.rawValue] as? String ?? ""
        self.name = data[Save.CodingKeys.name.rawValue] as? String ?? ""
        self.longitude = data[Save.CodingKeys.longitude.rawValue] as? Double ?? 0
        self.latitude = data[Save.CodingKeys.latitude.rawValue] as? Double ?? 0
        self.imageUrl = data[Save.CodingKeys.imageUrl.rawValue] as? String ?? ""
        let timestamp = data[Save.CodingKeys.timestamp.rawValue] as? Timestamp
        self.timestamp = timestamp?.dateValue() ?? Date()
    }
}
