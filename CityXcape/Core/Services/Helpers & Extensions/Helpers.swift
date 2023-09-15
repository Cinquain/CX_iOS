//
//  Helpers.swift
//  CityXcape
//
//  Created by James Allan on 8/21/23.
//

import Foundation



struct Server {
    static let users = "users"
    static let worlds = "worlds"
    static let locations = "locations"
    static let privates = "users_private"
    static let checkIns = "checkins"
    static let saves = "saves"
    static let messages = "messages"
    static let stamps = "stamps"
    static let recentMessages = "recentMessage"
}

struct AppUserDefaults {
    static let uid = "uid"
    static let city = "city"
    static let loadMessage = "loadMessage"
}

enum StreetPasType {
    case stranger
    case personal
}


enum Tab: String, CaseIterable {
    case locations = "tab2"
    case post = "mappin.square.fill"
    case profile = "person.text.rectangle.fill"
    case connections = "message.fill"
    
    var title: String {
        switch self {
        case .locations:
            return "Locations"
        case .post:
            return "Post"
        case .profile:
            return "Profile"
        case .connections:
        return "Messages"
        }
       
    }
    
}

enum Keys: String {
    case proxy
}

enum MyError: Error {
    case failedCompression(String)
}
