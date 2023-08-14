//
//  World.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import Foundation


struct World: Identifiable, Equatable, Codable {
    
    let id: String
    let name: String
    let description: String
    let bannerImageUrl: String
    let symbolImageUrl: String
    let values: [String]
    let dateCreated: Date
    
    let spotCount: Int
    let memberCount: Int
    
    
    static func == (lhs: World, rhs: World) -> Bool {
            return lhs.id == rhs.id
        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.bannerImageUrl = try container.decode(String.self, forKey: .bannerImageUrl)
        self.symbolImageUrl = try container.decode(String.self, forKey: .symbolImageUrl)
        self.values = try container.decode([String].self, forKey: .values)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.spotCount = try container.decode(Int.self, forKey: .spotCount)
        self.memberCount = try container.decode(Int.self, forKey: .memberCount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.bannerImageUrl, forKey: .bannerImageUrl)
        try container.encode(self.symbolImageUrl, forKey: .symbolImageUrl)
        try container.encode(self.values, forKey: .values)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.spotCount, forKey: .spotCount)
        try container.encode(self.memberCount, forKey: .memberCount)
    }
 
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case bannerImageUrl = "banner_imageUrl"
        case symbolImageUrl = "symbol_imageUrl"
        case values
        case dateCreated = "date_created"
        case spotCount = "spot_count"
        case memberCount = "member_count"
    }
}
