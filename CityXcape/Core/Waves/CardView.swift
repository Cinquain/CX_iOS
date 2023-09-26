//
//  CardView.swift
//  CityXcape
//
//  Created by James Allan on 9/18/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardView: View, Identifiable {
    
    @StateObject var vm = CardViewModel()
    var wave: Wave
    
    var id: String {
           wave.id
       }
    
    var body: some View {
            VStack {
                userBubble()
               
                Spacer()
                waveMessage()
                HStack {
                    Spacer()
                    timerView()
                    Spacer()
                }
                .padding(.bottom)
                .padding(.horizontal)
            }
            .background(background())
            .frame(width: 370, height: 600)
            .overlay(
                   RoundedRectangle(cornerRadius: 12)
                    .stroke(.orange.opacity(0.7), lineWidth: 2)
               )
            .cornerRadius(12)
            .padding(.horizontal)
            .onAppear {
                withAnimation {
                    vm.startTimer(username: wave.displayName)
                }
                vm.requestNotifications()
            }
            .onReceive(vm.timer, perform: { (_) in
                withAnimation {
                    vm.updateTimer()
                }
            })
          
          

            
        
  
    }
    
    @ViewBuilder
    func userBubble() -> some View {
        VStack(spacing: 2) {
            Button {
                vm.showPass.toggle()
            } label: {
                BubbleView(width: 300, imageUrl: wave.profileUrl, type: .stranger)
            }
            .sheet(isPresented: $vm.showPass) {
                PublicStreetPass(user: User.demo)
            }
            Text(wave.displayName)
                .fontWeight(.thin)
                .font(.title2)
            HStack(alignment: .bottom, spacing: 2) {
                Image("pin_feed")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    
                Text(wave.location)
                    .fontWeight(.thin)
                    .font(.callout)
            }
            
        }
        .foregroundColor(.white)

    }
    
    @ViewBuilder
    func waveMessage() -> some View {
        
        VStack {
            Spacer()
            Text(wave.content)
                    .font(.callout)
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                    .padding()
                    .background(.orange)
                    .clipShape(Capsule())
                    .fontWeight(.thin)

            Spacer()
        }
       
        
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
                .opacity(0.9)
            Image("black-paths")
                 .resizable()
                 .scaledToFill()
                 .rotationEffect(Angle(degrees: 180))
            
          

        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func timerView() -> some View {
            Button {
                //Connect user
            } label: {
                VStack {
                    ZStack {
                        
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                            .frame(width: 90, height: 90)
                        
                        
                        Circle()
                            .trim(from: 0, to: vm.to)
                            .stroke(Color.orange, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                            .frame(width: 90, height: 90)
                            .rotationEffect(.init(degrees: -90))

                        VStack {
                            Text(vm.timerString)
                                .font(.title3)
                                .fontWeight(.thin)
                         
                            
                        }
                        .foregroundColor(.white)

                    }
                    Text("CONNECT")
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .tracking(3)
                }
            }
            

        

    }
    
  
}



struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(wave: Wave.demo)
            .previewLayout(.sizeThatFits)
    }
}
