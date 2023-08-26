//
//  PublicStreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/25/23.
//

import SwiftUI

struct PublicStreetPass: View {
    let user: User
    var body: some View {
        GeometryReader {
            let size = $0.size
            VStack {
                
                HStack {
                    Text("STREETPASS")
                        .font(.system(size: 24))
                        .fontWeight(.ultraLight)
                        .foregroundColor(.white)
                        .tracking(4)
                        .opacity(0.5)
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.horizontal, 25)
                
                VStack(spacing: 3) {
                    BubbleView(width: 300, imageUrl: user.imageUrl ?? "")
                    Text(user.username ?? "")
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.ultraLight)
                }
                
                Spacer()
                
                Button {
                    //
                } label: {
                    Text("Message")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .background(Capsule().fill(.cyan.opacity(0.5)).frame(width: 150, height: 40))
                }
                
                Spacer()
                
            }
            .frame(width: size.width, height: size.height)
           
            
            

        }
        .background(Background())
       


    }
    
    @ViewBuilder
    func Background() -> some View {
        ZStack {
            Color.black
            Image("street-paths")
                .resizable()
                .scaledToFill()
                .opacity(0.4)
            
           
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct PublicStreetPass_Previews: PreviewProvider {
    static var previews: some View {
        PublicStreetPass(user: User.demo)
    }
}
