//
//  Helpers.swift
//  CityXcape
//
//  Created by James Allan on 8/21/23.
//

import Foundation
import SwiftUI



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
    static let waves = "waves"
}

struct AppUserDefaults {
    static let uid = "uid"
    static let city = "city"
    static let loadMessage = "loadMessage"
    static let profileUrl = "profileUrl"
    static let username = "username"
    static let waveCount = "waveCount"
}

enum PassType {
    case stranger
    case personal
}

enum Tab: String, CaseIterable {
    case locations = "tab2"
    case post = "mappin.square.fill"
    case profile = "person.text.rectangle.fill"
    case messages = "message.fill"
    case waves = "hive_feed"
    
    var title: String {
        switch self {
        case .locations:
            return "Locations"
        case .post:
            return "Post"
        case .profile:
            return "Profile"
        case .messages:
        return "Messages"
        case .waves:
            return "Connect"
        }
       
    }
    
}

struct swipeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 128))
            .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)), radius: 12, x: 0, y: 0)
    }
}

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .pressing, .inactive:
            return false
        case .dragging:
            return true
        }
    }
    
    var isPressing: Bool {
        switch self {
        case .inactive:
            return false
        case .pressing, .dragging:
            return true
        }
    }
}

enum Keys: String {
    case proxy
}

enum MyError: Error {
    case failedCompression(String)
}
