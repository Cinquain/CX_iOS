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
    let imageUrl: String
    let ownerId: String
    let displayName: String
    let ownerImageUrl: String
 
    
    static func == (lhs: Stamp, rhs: Stamp) -> Bool {
            return lhs.id == rhs.id
        }
    
    init(data: [String: Any]) {
        self.id = data[Stamp.CodingKeys.id.rawValue] as? String ?? ""
        self.spotId = data[Stamp.CodingKeys.spotId.rawValue] as? String ?? ""
        self.spotName = data[Stamp.CodingKeys.spotName.rawValue] as? String ?? ""
        self.longitude = data[Stamp.CodingKeys.longitude.rawValue] as? Double ?? 0
        self.latitude = data[Stamp.CodingKeys.latitude.rawValue] as? Double ?? 0
        self.imageUrl = data[Stamp.CodingKeys.imageUrl.rawValue] as? String ?? ""
        self.ownerId = data[Stamp.CodingKeys.ownerId.rawValue] as? String ?? ""
        let timestamp =  data[Stamp.CodingKeys.timestamp.rawValue] as? Timestamp
        self.timestamp = timestamp?.dateValue() ?? Date()
        self.displayName = data[Stamp.CodingKeys.displayName.rawValue] as? String ?? ""
        self.ownerImageUrl = data[Stamp.CodingKeys.ownerImageUrl.rawValue] as? String ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case spotName
        case spotId
        case timestamp
        case longitude
        case latitude
        case imageUrl = "stamp_imageUrl"
        case ownerId = "owner_id"
        case displayName
        case ownerImageUrl
    }
    
    static let data: [String: Any] = [
        Stamp.CodingKeys.id.rawValue: "fooisjiojsiojsoihoih",
        Stamp.CodingKeys.spotId.rawValue: "D1r1VyJUouRQjrgAN5IB",
        Stamp.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Locations%2FD1r1VyJUouRQjrgAN5IB%2Fmagic%20garden.png?alt=media&token=b246a0b6-3d1f-4b9d-a3f9-35c29b308ffc",
        Stamp.CodingKeys.longitude.rawValue: -75.15926702356003,
        Stamp.CodingKeys.latitude.rawValue: 39.943056535392984,
        Stamp.CodingKeys.timestamp.rawValue: Date(),
        Stamp.CodingKeys.spotName.rawValue: "The Magic Garden",
        Stamp.CodingKeys.ownerId.rawValue: "jhoihoiowioiwj",
    ]
    
    static let data2: [String: Any] = [
        Stamp.CodingKeys.id.rawValue: "fooisjiojsiojsokjkjdigsdghsgjhdsjhgbihoih",
        Stamp.CodingKeys.spotId.rawValue: "nS32I8rSz1Xly5IGwYPx",
        Stamp.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Locations%2FnS32I8rSz1Xly5IGwYPx%2Fpexels-alteredsnaps-12167671.jpg?alt=media&token=e8ad1850-30f5-42c8-88d3-100b98a5faef",
        Stamp.CodingKeys.longitude.rawValue: -75.15926702356003,
        Stamp.CodingKeys.latitude.rawValue: 39.943056535392984,
        Stamp.CodingKeys.timestamp.rawValue: Date(),
        Stamp.CodingKeys.spotName.rawValue: "The Vessel",
        Stamp.CodingKeys.ownerId.rawValue: "jhoihoiowioflfnlkflkiwj",
    ]
    
    
    static let data3: [String: Any] = [
        Stamp.CodingKeys.id.rawValue: "fooisiuwyIUY9Q7289Q827Y97jiojsiojsokjkjdigsdghsgjhdsjhgbihoih",
        Stamp.CodingKeys.spotId.rawValue: "nS32I8A8368W7A68Sz1Xly5IGwYPx",
        Stamp.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Locations%2FDdRzArPrhQvEKBJfppIe%2FExample.jpg?alt=media&token=718582c2-7b49-4585-b2d0-0c78ba51253f",
        Stamp.CodingKeys.longitude.rawValue: -75.15926702356003,
        Stamp.CodingKeys.latitude.rawValue: 39.943056535392984,
        Stamp.CodingKeys.timestamp.rawValue: Date(),
        Stamp.CodingKeys.spotName.rawValue: "Graffiti Pier",
        Stamp.CodingKeys.ownerId.rawValue: "jhoihoiowioflkfkljkflfnlkflkiwj",
    ]
    
    static let data4: [String: Any] = [
        Stamp.CodingKeys.id.rawValue: "fooisiuwyIUY9Qfglkgkgskldkjog7289Q827Y97jiojsiojsokjkjdigsdghsgjhdsjhgbihoih",
        Stamp.CodingKeys.spotId.rawValue: "nS32I8Akfjkdjksjf8368W7A68Sz1Xly5IGwYPx",
        Stamp.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Locations%2FuFAFkCFpvl39e85Q07Ez%2Fpexels-cottonbro-studio-4694309.jpg?alt=media&token=8ee09f94-bb69-4c72-9290-544737def64a",
        Stamp.CodingKeys.longitude.rawValue: -75.15926702356003,
        Stamp.CodingKeys.latitude.rawValue: 39.943056535392984,
        Stamp.CodingKeys.timestamp.rawValue: Date(),
        Stamp.CodingKeys.spotName.rawValue: "One57 Bar",
        Stamp.CodingKeys.ownerId.rawValue: "jhooidhihjkddihoiowioflfnlkflkiwj",
    ]
    
    static let demo = Stamp(data: data)
    static let demo2 = Stamp(data: data2)
    static let demo3 = Stamp(data: data3)
    static let demo4 = Stamp(data: data4)
}
