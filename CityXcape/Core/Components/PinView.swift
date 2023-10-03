//
//  PinView.swift
//  CityXcape
//
//  Created by James Allan on 10/2/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PinView: View {
    let height: CGFloat
    let url: String
    
    var body: some View {
        Image("Pin")
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .overlay {
                WebImage(url: URL(string: url))
                    .resizable()
                    .scaledToFill()
                    .frame(height: height / 1.35)
                    .clipShape(Circle())
                    .offset(y: -(height / 16))
            }
    }
}

struct PinView_Previews: PreviewProvider {
    static var previews: some View {
        PinView(height: 200, url: Location.demo2.imageUrl)
    }
}
