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
    var message: RecentMessage
    
    var id: String {
           message.id
       }
    
    var body: some View {
            VStack {
                header()

                userBubble()
               
                Spacer()
                
                HStack {
                    location()
                    Spacer()
                    timerView()
                }
                .padding(.bottom)
                .padding(.horizontal)
            }
            .background(background())
            .frame(width: 370, height: 600)
            .overlay(
                   RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.7), lineWidth: 2)
               )
            .cornerRadius(12)
            .padding(.horizontal)
            .onAppear {
                withAnimation {
                    vm.startTimer()
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
            BubbleView(width: 300, imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FoVbS9qDAccXS0aqwHtWXvCYfGv62%2Fpexels-mahdi-chaghari-13634600.jpg?alt=media&token=81e87218-43fa-4cd7-80ea-c556cde704d8", type: .stranger)
            }
            .sheet(isPresented: $vm.showPass) {
                PublicStreetPass(user: User.demo)
            }
            Text("Amanda")
                .fontWeight(.thin)
                .font(.title2)
            Button {
                vm.showPass.toggle()
            } label: {
                Text("\(Image(systemName: "globe.americas.fill")) 80% Match")
                    .fontWeight(.thin)
                    .font(.callout)
            }
            
        }
        .foregroundColor(.white)

    }
    
    @ViewBuilder
    func header() -> some View {
        HStack(spacing: 3){
            Image(systemName: "hands.sparkles.fill")
                .foregroundColor(.white)
                .opacity(0.8)
            
            Text("How are you liking this place?")
                .font(.title3)
                .foregroundColor(.white)
                .fontWeight(.thin)
       
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    @ViewBuilder
    func location() -> some View {
        Image("Pin")
            .resizable()
            .scaledToFit()
            .frame(height: 30)
        Text("Four Seasons")
            .foregroundColor(.white)
            .fontWeight(.thin)
            .font(.title2)
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("network")
                 .resizable()
                 .scaledToFill()
                 .rotationEffect(Angle(degrees: 180))
                 .opacity(0.5)
            LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom)

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
                            .stroke(Color.green, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                            .frame(width: 90, height: 90)
                            .rotationEffect(.init(degrees: -90))

                        VStack {
                            Text(vm.timerString)
                                .font(.title3)
                                .fontWeight(.thin)
                         
                            
                        }
                        .foregroundColor(.green)

                    }
                    Text("CONNECT")
                        .font(.callout)
                        .foregroundColor(.green)
                        .fontWeight(.thin)
                        .tracking(3)
                }
            }
            

        

    }
    
  
}



struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(message: RecentMessage.demo)
            .previewLayout(.sizeThatFits)
    }
}
