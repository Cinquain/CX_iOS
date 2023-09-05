//
//  StreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/29/23.
//

import SwiftUI
import PhotosUI

struct StreetPass: View {
    
    let user: User
    @StateObject var vm = StreetPassViewModel()
    
    var body: some View {
        
            VStack {
                StreetPassHeader()
                UserDot()
                Spacer()
                    .frame(height: 70)
                MyJourney()
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
        
        PhotosPicker(selection: $vm.selectedItem, matching: .images) {
            VStack(spacing: 3) {
                BubbleView(width: 300, imageUrl: vm.profileUrl)
                Text(user.username ?? "")
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
            }
        }
        
    }
    
    @ViewBuilder
    func MyJourney() -> some View {
  
        Button {
            //TBD
        } label: {
            HStack {
                Image("Journey")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
                Text("My Journey")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
            }
            
        }
        
    }
    
    
}

struct StreetPass_Previews: PreviewProvider {
    static var previews: some View {
        StreetPass(user: User.demo)
    }
}
