//
//  TimerView.swift
//  CityXcape
//
//  Created by James Allan on 9/9/23.
//

import SwiftUI
import UserNotifications

struct WaveRequestView: View {
    @State private var start = false
    @State private var to: CGFloat = 0
    @State private var count: Int = 60
    @State private var timer = Timer.publish(every: 1, on: .main, in:.common)
                                    .autoconnect()
    
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
                        .frame(width: 80, height: 80)
                    
                    
                    Circle()
                        .trim(from: 0, to: to)
                        .stroke(Color.orange, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.init(degrees: -90))

                    VStack {
                        Text("\(count)")
                            .font(.title2)
                            .fontWeight(.thin)
                            .foregroundColor(.orange)
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
            self.start.toggle()
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { _, _ in
                //
            }
        }
        .onReceive(self.timer, perform: { (_) in
            if self.start {
                if self.count != 0 {
                    self.count -= 1
                    withAnimation {
                        self.to = CGFloat(count) / 60
                    }
                } else {
                    timer.upstream.connect().cancel()
                    self.notify()
                }
            }
        })
    }
    
    func notify() {
        let content = UNMutableNotificationContent()
        content.title = "Wave has Expired"
        content.body = "Cinquain's request to connect with you has run out of time!"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
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
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        WaveRequestView()
    }
}
