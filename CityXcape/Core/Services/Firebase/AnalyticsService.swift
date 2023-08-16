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
}
