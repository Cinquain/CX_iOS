//
//  TimerView.swift
//  CityXcape
//
//  Created by James Allan on 9/9/23.
//

import SwiftUI
import UserNotifications

struct WaveRequestView: View {
    @State private var to: CGFloat = 0
    @State private var count: Int = 60
    @State private var timer = Timer.publish(every: 1, on: .main, in:.common)
                                    .autoconnect()
    
    @State private var minutes: Int = 15
    @State private var seconds: Int = 0
    @State private var isStarted: Bool = false
    @State private var timerString: String = ""
    @State private var totalSeconds: Int = 0
    @State private var staticTotalSeconds: Int = 0
    
    var body: some View {
        ZStack {
            background()
            
            VStack {
                
                VStack(spacing: 2) {
                    BubbleView(width: 350, imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FW6EUJxka1OihhJ0Iyest%2F2-min.jpg?alt=media&token=1930940d-704f-42b1-aa2b-cd8c919b0161", type: .stranger)
                    Text("\(Image(systemName: "globe.americas.fill")) 80% Match")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .font(.callout)
                }
                
                Text("Cinquain wants to connect with you")
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .font(.title2)
                    .padding(.top, 10)
               
                Spacer()
                    .frame(height: 50)
                
                ZStack {
                    
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                        .frame(width: 90, height: 90)
                    
                    
                    Circle()
                        .trim(from: 0, to: to)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                        .frame(width: 90, height: 90)
                        .rotationEffect(.init(degrees: -90))

                    VStack {
                        Text(timerString)
                            .font(.title2)
                            .fontWeight(.thin)
                            .foregroundColor(.blue)
                    }
                }
               
                HStack(spacing: 10) {
                    
                    Button(action: {
                        //TBD
                    }, label: {
                        HStack(spacing: 2) {
                            Text("Nah")
                                .foregroundColor(Color.red.opacity(0.7))
                            Image(systemName: "scissors")
                                .foregroundColor(Color.red.opacity(0.7))
                                .font(.callout)
                        }
                        .padding(.vertical)
                        .frame(width: 150)
                        .background(
                            Capsule()
                                .stroke(Color.red.opacity(0.7), lineWidth: 2)
                        )
                        .shadow(radius: 6)
                        
                    })
                    
                    Button(action: {
                        //TBD
                    }, label: {
                        HStack(spacing: 2) {
                            Text("Accept")
                                .foregroundColor(.white)
                            Image(systemName: "bubble.left.fill")
                                .foregroundColor(.white)
                                .font(.callout)
                        }
                        .padding(.vertical)
                        .frame(width: 150)
                        .background(Color.green.opacity(0.7))
                        .clipShape(Capsule())
                        .shadow(radius: 6)
                    })
                }
                .padding(.top, 25)
            }
        }
        .onAppear {
            startTimer()
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { _, _ in
                //
            }
        }
        .onReceive(self.timer, perform: { (_) in
           updateTimer()
        })
    }
    
    func notify() {
        let content = UNMutableNotificationContent()
        content.title = "Wave has Expired"
        content.body = "Cinquain's request to connect with you has run out of time!"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false)
        let request = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
    }
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("orange-paths")
                .resizable()
                .scaledToFill()
                .opacity(0.35)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.3)) {isStarted = true}
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
        withAnimation {
            isStarted = false
            minutes = 0
            seconds = 0
            to = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerString = "00:00"
        timer.upstream.connect().cancel()
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        WaveRequestView()
    }
}
