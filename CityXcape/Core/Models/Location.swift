//
//  SecretSpot.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct Location: Identifiable, Equatable, Codable, Hashable {
    
    //Basic Properities
    let id: String
    let name: String
    let description: String
    let imageUrl: String
    let longitude: Double
    let latitude: Double
    let city: String
    let address: String?
    let timestamp: Date
    let ownerId: String
    let hashtags: String
    //Social Component
    let saveCount: Double
    let likeCount: Double
    let checkinCount: Double
    let commentCount: Double
    let connections: Double
    
    //World Component
    let worldId: String?
    let worldName: String?
    let worldImageUrl: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
            return lhs.id == rhs.id
        }
    
    var distanceString: String {
            let manager = LocationService.shared.manager
            
            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                let destination = CLLocation(latitude: latitude, longitude: longitude)
                let userlocation = CLLocation(latitude: (manager.location?.coordinate.latitude) ?? 0, longitude: (manager.location?.coordinate.longitude) ?? 0)
                let distance = userlocation.distance(from: destination) * 0.000621
                let distanceinFt = distance * 3.28084
                let roundedDistance = String(format: "%.0f", distance)
                let roundedDistanceInFt  = String(format: "%.0f", distanceinFt)
                if distance > 1 {
                    return "\(roundedDistance) mi"
                } else {
                    return "\(roundedDistanceInFt) ft"
                }
            } else {
                manager.requestWhenInUseAuthorization()
                return "N/A"
            }

        }
    
    var distanceFromUser: Double {
        let manager = LocationService.shared.manager
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            let destination = CLLocation(latitude: latitude, longitude: longitude)
            let userlocation = CLLocation(latitude: (manager.location?.coordinate.latitude) ?? 0, longitude: (manager.location?.coordinate.longitude) ?? 0)
            let distance = userlocation.distance(from: destination) * 0.000621
            let distanceinFt = distance * 3.28084
            return distanceinFt
        } else {
            manager.requestWhenInUseAuthorization()
            return 1000
        }
    }
    
    
    init(data: [String: Any]) {
        self.id = data[Location.CodingKeys.id.rawValue] as? String ?? ""
        self.name = data[Location.CodingKeys.name.rawValue] as? String ?? ""
        self.description = data[Location.CodingKeys.description.rawValue] as? String ?? ""
        self.imageUrl = data[Location.CodingKeys.imageUrl.rawValue] as? String ?? ""
        self.hashtags = data[Location.CodingKeys.hashtags.rawValue] as? String ?? ""
        self.latitude = data[Location.CodingKeys.latitude.rawValue] as? Double ?? 0
        self.longitude = data[Location.CodingKeys.longitude.rawValue] as? Double ?? 0
        self.city = data[Location.CodingKeys.city.rawValue] as? String ?? ""
        self.address = data[Location.CodingKeys.address.rawValue] as? String ?? ""
        let timestamp = data[Location.CodingKeys.timestamp.rawValue] as? Timestamp
        self.timestamp = timestamp?.dateValue() ?? Date()
        self.saveCount = data[Location.CodingKeys.saveCount.rawValue] as? Double ?? 1
        self.commentCount = data[Location.CodingKeys.commentCount.rawValue] as? Double ?? 0
        self.likeCount = data[Location.CodingKeys.likeCount.rawValue] as? Double ?? 0
        self.checkinCount = data[Location.CodingKeys.checkinCount.rawValue] as? Double ?? 0
        self.worldId = data[Location.CodingKeys.worldId.rawValue] as? String ?? nil
        self.worldName = data[Location.CodingKeys.worldName.rawValue] as? String ?? nil
        self.worldImageUrl = data[Location.CodingKeys.worldImageUrl.rawValue] as? String ?? nil
        self.ownerId = data[Location.CodingKeys.ownerId.rawValue] as? String ?? ""
        self.connections = data[Location.CodingKeys.connections.rawValue] as? Double ?? 0
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageUrl
        case longitude
        case latitude
        case likeCount
        case city
        case timestamp
        case connections
        case address
        case hashtags
        case ownerId = "owner_id"
        case saveCount = "save_count"
        case checkinCount = "checkin_count"
        case commentCount = "comment_count"
        case worldName = "world_name"
        case worldId = "world_id"
        case worldImageUrl =  "world_imageUrl"
  
    }
    
    static let data: [String: Any] = [
        Location.CodingKeys.id.rawValue: "uFAFkCFpvl39e85Q07Ez",
        Location.CodingKeys.name.rawValue: "Graffiti Pier",
        Location.CodingKeys.description.rawValue: "Graffiti Pier is a landmark in the street art scene, attracting graf writers and artists from clear across the eastern seaboard, proudly exhibiting why Philadelphia is a hotspot of cultural production. It’s also a place reflective of the culture of industry and the working class roots of Port Richmond and many Philadelphians. The 6-acre site is a place of mystique, offering a sense of discovery and adventure. It’s a place known, but unknown; familiar, but found. Graffiti Pier is a place that offers unique prospect over the river and a valuable space of reflection in the midst of everyday urban life.",
        Location.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Locations%2FDdRzArPrhQvEKBJfppIe%2FExample.jpg?alt=media&token=718582c2-7b49-4585-b2d0-0c78ba51253f",
        Location.CodingKeys.city.rawValue: "Philadelphia",
        Location.CodingKeys.address.rawValue: "Philadelphia, PA 19125",
        Location.CodingKeys.latitude.rawValue: 39.971779951285704,
        Location.CodingKeys.longitude.rawValue: -75.1136488197242,
        Location.CodingKeys.timestamp.rawValue: Date(),
        Location.CodingKeys.likeCount.rawValue: 12,
        Location.CodingKeys.saveCount.rawValue: 10,
        Location.CodingKeys.hashtags.rawValue: "Street Art",
        Location.CodingKeys.checkinCount.rawValue: 3,
        Location.CodingKeys.commentCount.rawValue: 4
    ]
    
    static let data1: [String: Any] = [
        Location.CodingKeys.id.rawValue: "uFAFkCF245pvl39e85Q07Ez",
        Location.CodingKeys.name.rawValue: "The Vessel",
        Location.CodingKeys.description.rawValue: "Graffiti Pier is a landmark in the street art scene, attracting graf writers and artists from clear across the eastern seaboard, proudly exhibiting why Philadelphia is a hotspot of cultural production. It’s also a place reflective of the culture of industry and the working class roots of Port Richmond and many Philadelphians. The 6-acre site is a place of mystique, offering a sense of discovery and adventure. It’s a place known, but unknown; familiar, but found. Graffiti Pier is a place that offers unique prospect over the river and a valuable space of reflection in the midst of everyday urban life.",
        Location.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Locations%2FnS32I8rSz1Xly5IGwYPx%2Fpexels-alteredsnaps-12167671.jpg?alt=media&token=e8ad1850-30f5-42c8-88d3-100b98a5faef",
        Location.CodingKeys.city.rawValue: "New York",
        Location.CodingKeys.address.rawValue: "Philadelphia, PA 19125",
        Location.CodingKeys.latitude.rawValue: 39.971779951285704,
        Location.CodingKeys.longitude.rawValue: -75.1136488197242,
        Location.CodingKeys.timestamp.rawValue: Date(),
        Location.CodingKeys.likeCount.rawValue: 21,
        Location.CodingKeys.saveCount.rawValue: 10,
        Location.CodingKeys.hashtags.rawValue: "Nightlife",
        Location.CodingKeys.checkinCount.rawValue: 3,
        Location.CodingKeys.commentCount.rawValue: 4
    ]
    
    static let data2: [String: Any] = [
        Location.CodingKeys.id.rawValue: "uFAFkCFpvl39e667785Q07Ez",
        Location.CodingKeys.name.rawValue: "One57 Bar",
        Location.CodingKeys.description.rawValue: "Graffiti Pier is a landmark in the street art scene, attracting graf writers and artists from clear across the eastern seaboard, proudly exhibiting why Philadelphia is a hotspot of cultural production. It’s also a place reflective of the culture of industry and the working class roots of Port Richmond and many Philadelphians. The 6-acre site is a place of mystique, offering a sense of discovery and adventure. It’s a place known, but unknown; familiar, but found. Graffiti Pier is a place that offers unique prospect over the river and a valuable space of reflection in the midst of everyday urban life.",
        Location.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Locations%2FuFAFkCFpvl39e85Q07Ez%2Fpexels-cottonbro-studio-4694309.jpg?alt=media&token=8ee09f94-bb69-4c72-9290-544737def64a",
        Location.CodingKeys.city.rawValue: "New York",
        Location.CodingKeys.address.rawValue: "Philadelphia, PA 19125",
        Location.CodingKeys.latitude.rawValue: 39.971779951285704,
        Location.CodingKeys.longitude.rawValue: -75.1136488197242,
        Location.CodingKeys.timestamp.rawValue: Date(),
        Location.CodingKeys.saveCount.rawValue: 10,
        Location.CodingKeys.likeCount.rawValue: 60,
        Location.CodingKeys.hashtags.rawValue: "Foodie",
        Location.CodingKeys.checkinCount.rawValue: 3,
        Location.CodingKeys.commentCount.rawValue: 4
    ]
    
    static let demo = Location(data: data)
    static let demo1 = Location(data: data1)
    static let demo2 = Location(data: data2)
}
