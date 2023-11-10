//
//  CardViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/20/23.
//

import Foundation
import UserNotifications


class CardViewModel: ObservableObject {
    
    @Published var to: CGFloat = 0
    @Published var count: Int = 60
    @Published var timer = Timer.publish(every: 1, on: .main, in:.common)
                                    .autoconnect()
    
    @Published var minutes: Int = 10
    @Published var seconds: Int = 0
    @Published var isStarted: Bool = false
    @Published var timerString: String = ""
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    @Published var showPass: Bool = false
    
    
    func notify(username: String, id: String) {
        let content = UNMutableNotificationContent()
        content.title = "Connection Expired!"
        content.body = "\(username) request to connect with you has run out of time!"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        if minutes == 0 && seconds == 0 {
            stopTimer(messageId: id)
        }
        
    }
    
  
    func startTimer(username: String, id: String) {
        isStarted = true
        timerString = "\(minutes >= 10 ? "\(minutes):" :"\(minutes):")\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        totalSeconds = (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        notify(username: username, id: id)
    }
    
    func updateTimer(messageId: String) {
        totalSeconds -= 1
        to = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        to = to < 0 ? 0 : to
        minutes = (totalSeconds / 60)
        seconds = (totalSeconds % 60)
       
        timerString = "\(minutes >= 10 ? "\(minutes):" :"\(minutes):")\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        if minutes == 0 && seconds == 0 {
            isStarted = false
            stopTimer(messageId: messageId)
            print("Timer Finished")
        }
    }
    
    func stopTimer(messageId: String) {
            isStarted = false
            minutes = 0
            seconds = 0
            to = 1
        
        totalSeconds = 0
        staticTotalSeconds = 0
        timerString = "0:00"
        timer.upstream.connect().cancel()
        Task {
            do {
                try await DataService.shared.deleteRequest(id: messageId)
            } catch {
                print("Error deleting request from DB", error.localizedDescription)
            }
        }
    }
    
    func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { _, _ in
            //
        }
    }
    
    
    
    
}
