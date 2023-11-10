//
//  MatchAnimation.swift
//  CityXcape
//
//  Created by James Allan on 9/24/23.
//

import SwiftUI

struct MatchAnimation: View {
    
    @AppStorage(AppUserDefaults.profileUrl) var profileUrl: String?
    
    @State var matchUrl: String
    @State private var rotation: Double = 90
    @State private var lenght: CGFloat = 120
    @State private var opacity: Double = 0
    var body: some View {
        VStack {
            Spacer()
            HStack {
                UserDot(width: 125, imageUrl: profileUrl ?? "")
                    .rotationEffect(Angle(degrees: rotation))
                    .animation(.easeOut(duration: 0.5), value: rotation)
               
                Divider()
                    .frame(width: lenght, height: 0)
                    .background(.orange)
                
                
                
                UserDot(width: 125, imageUrl: matchUrl)
                    .rotationEffect(Angle(degrees: rotation))
                    .animation(.easeOut(duration: 0.5), value: rotation)

            }
            .padding(.horizontal, 20)
            HStack {Spacer()}
            VStack {
                Image("connect")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text("New Connection!")
                    .foregroundColor(.orange)
                    .fontWeight(.thin)
                    .font(.title2)
                    
            }
            .opacity(opacity)
            .animation(.easeOut(duration: 0.5), value: opacity)
            
            Spacer()
            Spacer()
            
        }
        .onAppear {
            withAnimation(.easeOut(duration: 3)) {
                rotation = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    withAnimation {
                        lenght = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            opacity = 1
                        })
                    }
                })
            }
           
        }
        
    }
}

struct MatchAnimation_Previews: PreviewProvider {
    static var previews: some View {
        MatchAnimation(matchUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FoVbS9qDAccXS0aqwHtWXvCYfGv62%2Fpexels-mahdi-chaghari-13634600.jpg?alt=media&token=81e87218-43fa-4cd7-80ea-c556cde704d8")
    }
}
