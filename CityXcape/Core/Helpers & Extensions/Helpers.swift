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
    case discover = "dot.radiowaves.left.and.right"
    case post = "tab2"
    case profile = "person.fill"
    
    var title: String {
        switch self {
        case .discover:
            return "Discover"
        case .post:
            return "Post"
        case .profile:
            return "Profile"
        }
    }
    
}

enum MyError: Error {
    case failedCompression(String)
}
