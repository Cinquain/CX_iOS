//
//  StreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/29/23.
//

import SwiftUI

struct StreetPass: View {
    let user: User
    var body: some View {
        
            VStack {
                StreetPassHeader()
                UserDot()
                Spacer()
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
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func StreetPassHeader() -> some View {
        HStack {
            Text("STREETPASS")
                .font(.system(size: 24))
                .fontWeight(.thin)
                .foregroundColor(.white)
                .tracking(4)
                .opacity(0.5)
            Spacer()
        }
        .padding(.horizontal, 25)
    }
    
    @ViewBuilder
    func UserDot() -> some View {
        VStack(spacing: 3) {
            BubbleView(width: 300, imageUrl: user.imageUrl ?? "")
            Text(user.username ?? "")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.thin)
        }
    }
    
    
}

struct StreetPass_Previews: PreviewProvider {
    static var previews: some View {
        StreetPass(user: User.demo)
    }
}
