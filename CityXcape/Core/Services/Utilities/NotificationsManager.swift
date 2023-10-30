//
//  NotificationsManager.swift
//  CityXcape
//
//  Created by James Allan on 10/30/23.
//

import SwiftUI
import FirebaseMessaging


class NotificationsManager: ObservableObject {
    
    @AppStorage(AppUserDefaults.fcmToken) var savedfcm: String?
    static let shared = NotificationsManager()
    let manager = UNUserNotificationCenter.current()
    
    private init(){}
    
    func checkAuthorizationStatus(completion: @escaping (_ fcmToken: String?) -> Void) {
        manager.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                let fcmToken = Messaging.messaging().fcmToken
                completion(fcmToken)
                if self.savedfcm == nil {
                    if let fcmToken = fcmToken {
                        DataService.shared.updateFcmToken(fcm: fcmToken)
                    }
                }
            } else {
                completion(nil)
                self.requestNotification()
            }
        }
    }
    
    fileprivate func requestNotification() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        manager.requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Error getting notification permissions", error.localizedDescription)
                return
            }
            if granted {
                print("Authorization granted!")
                let delegate = UIApplication.shared.delegate as? AppDelegate
                let app = UIApplication.shared
                delegate?.registerForNotifications(app: app)
            } else {
                print("Authorization request was denied!")
            }
        }
    }
    
    
    
    
}
