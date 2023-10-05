//
//  StampThumb.swift
//  CityXcape
//
//  Created by James Allan on 10/4/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct StampThumbnail: View {
    
    var stamp: Stamp
    var width: CGFloat
    
    var body: some View {
        VStack {
            Image("postal")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: width)
                .overlay(
                    WebImage(url: URL(string: stamp.imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: width - 10, maxHeight: width - 10)
                        .clipped()
            )
            
            
        }
    }
    
    
}

struct StampThumb_Previews: PreviewProvider {
    static var previews: some View {
        StampThumbnail(stamp: Stamp.demo, width: 180)
    }
}
