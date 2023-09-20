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
    
    @Published var minutes: Int = 15
    @Published var seconds: Int = 0
    @Published var isStarted: Bool = false
    @Published var timerString: String = ""
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    @Published var showPass: Bool = false
    
    
    func notify() {
        let content = UNMutableNotificationContent()
        content.title = "Wave has Expired"
        content.body = "Cinquain's request to connect with you has run out of time!"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false)
        let request = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func startTimer() {
        isStarted = true
        timerString = "\(minutes >= 10 ? "\(minutes):" :"0\(minutes):")\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        totalSeconds = (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        notify()
    }
    
    func updateTimer() {
        totalSeconds -= 1
        to = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        to = to < 0 ? 0 : to
        minutes = (totalSeconds / 60)
        seconds = (totalSeconds % 60)
       
        timerString = "\(minutes >= 10 ? "\(minutes):" :"0\(minutes):")\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        if minutes == 0 && seconds == 0 {
            isStarted = false
            stopTimer()
            print("Timer Finished")
        }
    }
    
    func stopTimer() {
            isStarted = false
            minutes = 0
            seconds = 0
            to = 1
        
        totalSeconds = 0
        staticTotalSeconds = 0
        timerString = "00:00"
        timer.upstream.connect().cancel()
    }
    
    func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { _, _ in
            //
        }
    }
    
    
    
    
}
