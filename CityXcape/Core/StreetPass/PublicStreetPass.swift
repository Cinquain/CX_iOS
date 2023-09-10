//
//  PublicStreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/25/23.
//

import SwiftUI

struct PublicStreetPass: View {
    @State private var showMenu: Bool = false
    
    let user: User
    var body: some View {
        GeometryReader {
            let size = $0.size
            VStack {
                StreetPassHeader()
                UserDot()
                Spacer()
                WaveButton()
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
            Image("orange-paths")
                .resizable()
                .scaledToFill()
                .opacity(0.8)
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
                .padding(.top, 5)
                .popover(isPresented: $showMenu) {
                    BuyWavesView()
                        .presentationDetents([.height(380)])
                }
            Spacer()
        }
        .padding(.horizontal, 25)
    }
    
    @ViewBuilder
    func UserDot() -> some View {
        VStack(spacing: 3) {
            BubbleView(width: 300,
                       imageUrl: user.imageUrl ?? "",
                     type: .stranger)
            Text(user.username ?? "")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.thin)
        }
    }
    
    @ViewBuilder
    func WaveButton() -> some View {
        Button {
            showMenu.toggle()
        } label: {
            HStack(spacing: 2) {
                Image(systemName: "hands.sparkles.fill")
                    .foregroundColor(.white)
                
                Text("Wave")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .background(Capsule()
                .fill(.orange.opacity(0.5))
                .frame(width: 150, height: 40))
        }
    }
}

struct PublicStreetPass_Previews: PreviewProvider {
    static var previews: some View {
        PublicStreetPass(user: User.demo)
    }
}
