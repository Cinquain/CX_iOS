//
//  Wave.swift
//  CityXcape
//
//  Created by James Allan on 9/25/23.
//

import Foundation


struct Wave: Identifiable, Equatable, Codable {
    let id: String
    let message: String
    let profileUrl: String
    let timestamp: Date
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case message
        case profileUrl
        case timestamp
    }
}
