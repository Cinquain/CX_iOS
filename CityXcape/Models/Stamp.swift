//
//  Stamp.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import Foundation

struct Stamp: Identifiable, Equatable, Codable {
    
    let id: String
    let spotName: String
    let spotId: String
    let dateCreated: Date
    let longitude: Double
    let latitude: Double
    let stampImageUrl: String
    
    let likeCount: Int
    let commentCount: Int
    let comments: [String: String]
    let likes: [String: String]
    let reactions: [String]
    
    static func == (lhs: Stamp, rhs: Stamp) -> Bool {
            return lhs.id == rhs.id
        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.spotName = try container.decode(String.self, forKey: .spotName)
        self.spotId = try container.decode(String.self, forKey: .spotId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.stampImageUrl = try container.decode(String.self, forKey: .stampImageUrl)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.commentCount = try container.decode(Int.self, forKey: .commentCount)
        self.comments = try container.decode([String : String].self, forKey: .comments)
        self.likes = try container.decode([String : String].self, forKey: .likes)
        self.reactions = try container.decode([String].self, forKey: .reactions)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.spotName, forKey: .spotName)
        try container.encode(self.spotId, forKey: .spotId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.stampImageUrl, forKey: .stampImageUrl)
        try container.encode(self.likeCount, forKey: .likeCount)
        try container.encode(self.commentCount, forKey: .commentCount)
        try container.encode(self.comments, forKey: .comments)
        try container.encode(self.likes, forKey: .likes)
        try container.encode(self.reactions, forKey: .reactions)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case spotName
        case spotId
        case dateCreated = "date_created"
        case longitude
        case latitude
        case stampImageUrl = "stamp_imageUrl"
        case likeCount = "like_count"
        case commentCount = "comment_count"
        case comments
        case likes
        case reactions
    }
}
