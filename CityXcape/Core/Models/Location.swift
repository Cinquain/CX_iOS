//
//  SecretSpot.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Equatable, Codable {
    
    //Basic Properities
    let id: String
    let name: String
    let description: String
    let imageUrl: String
    let extraImages: [String]?
    let longitude: Double
    let latitude: Double
    let city: String
    let address: String
    let dateCreated: Date
    
    
    //Social Component
    let savedCount: Int
    let verifiedCount: Int
    let commentCount: Int
    
    //World Component
    let worldId: String?
    let worldName: String?
    let worldImageUrl: String?
    
    
    static func == (lhs: Location, rhs: Location) -> Bool {
            return lhs.id == rhs.id
        }
    
    var distanceFromUser: String {
            let manager = LocationService.shared.manager
            
            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                let destination = CLLocation(latitude: latitude, longitude: longitude)
                let userlocation = CLLocation(latitude: (manager.location?.coordinate.latitude) ?? 0, longitude: (manager.location?.coordinate.longitude) ?? 0)
                let distance = userlocation.distance(from: destination) * 0.000621
                if distance < 1 {
                    return "\(distance * 3.28084) mi"
                } else {
                    return "\(distance) ft"
                }
            } else {
                manager.requestWhenInUseAuthorization()
                return "Permission Not Granted"
            }

        }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.extraImages = try container.decode([String].self, forKey: .extraImages)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.city = try container.decode(String.self, forKey: .city)
        self.address = try container.decode(String.self, forKey: .address)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.savedCount = try container.decode(Int.self, forKey: .savedCount)
        self.verifiedCount = try container.decode(Int.self, forKey: .verifiedCount)
        self.commentCount = try container.decode(Int.self, forKey: .commentCount)
        self.worldId = try container.decode(String.self, forKey: .worldId)
        self.worldName = try container.decode(String.self, forKey: .worldName)
        self.worldImageUrl = try container.decode(String.self, forKey: .worldImageUrl)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.imageUrl, forKey: .imageUrl)
        try container.encode(self.extraImages, forKey: .extraImages)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.city, forKey: .city)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.savedCount, forKey: .savedCount)
        try container.encode(self.verifiedCount, forKey: .verifiedCount)
        try container.encode(self.commentCount, forKey: .commentCount)
        try container.encode(self.worldId, forKey: .worldId)
        try container.encode(self.worldName, forKey: .worldName)
        try container.encode(self.worldImageUrl, forKey: .worldImageUrl)
    }
  
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageUrl
        case extraImages = "extra_images"
        case longitude
        case latitude
        case city
        case address
        case dateCreated = "date_created"
        case savedCount = "saved_count"
        case verifiedCount = "verified_count"
        case commentCount = "comment_count"
        case worldId = "world_id"
        case worldName = "world_name"
        case worldImageUrl = "world_imageUrl"
    }
}
