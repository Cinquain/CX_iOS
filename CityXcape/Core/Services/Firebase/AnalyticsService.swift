//
//  AnalyticsService.swift
//  CityXcape
//
//  Created by James Allan on 8/11/23.
//

import Foundation
import FirebaseAnalytics


final class Analytic {
    
    static let shared = Analytic()
    private init() {}
    
    
    func googleSignUp() {
        Analytics.logEvent("chose_google_signup", parameters: nil)
    }
    
    func appleSignup() {
        Analytics.logEvent("chose_apple_signup", parameters: nil)
    }
    
    func newStamp() {
        Analytics.logEvent("new_stamp", parameters: nil)
    }
    
    func postedSpot() {
        Analytics.logEvent("spot_created", parameters: nil)
    }
    
    func editStreetPass() {
        Analytics.logEvent("edit_Profile", parameters: nil)
    }
    
    func savedLocation() {
        Analytics.logEvent("saved_location", parameters: nil)
    }
    
    func likedLocation() {
        Analytics.logEvent("liked_location", parameters: nil)
    }
    
    func viewedSpotInfo() {
        Analytics.logEvent("viewed_spotInfo", parameters: nil)
    }
    
}
