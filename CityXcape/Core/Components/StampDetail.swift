//
//  StampDetail.swift
//  CityXcape
//
//  Created by James Allan on 10/5/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct StampDetail: View {
    @State var stamp: Stamp
    
    var body: some View {
        VStack {
            postalStamp()
            title()
            passportSeal()
        }
        .background(Color.vintage)
    }
    
    @ViewBuilder
    func postalStamp() -> some View {
        HStack {
            ZStack {
                Image("postmark")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .offset(x: 120, y: -22)
                Image("postal")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(height: 200)
                    .overlay(
                        WebImage(url: URL(string: stamp.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 180, maxHeight: 180)
                            .clipped()
                )
            }
            Spacer()
        }
        .padding(.horizontal,20)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func title() -> some View {
        HStack(spacing: 3) {
            Image("Pin")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
            
            Text(stamp.spotName)
                .font(.title3)
                .fontWeight(.thin)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func passportSeal() -> some View {
        HStack {
            Spacer()
            PassPortStamp(stamp: stamp)
        }
        .padding(.horizontal, 20)
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
}

struct StampDetail_Previews: PreviewProvider {
    static var previews: some View {
        StampDetail(stamp: Stamp.demo)
    }
}
