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
    static let stamps = "stamps"
    static let checkIns = "checkins"
}

struct AppUserDefaults {
    static let uid = "uid"
    static let city = "city"
    static let loadMessage = "loadMessage"
}


enum Tab: String, CaseIterable {
    case locations = "tab2"
    case post = "mappin.square.fill"
    case profile = "person.fill"
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
        return "Connections"
        }
       
    }
    
}

enum MyError: Error {
    case failedCompression(String)
}
