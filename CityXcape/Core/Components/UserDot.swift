//
//  UserDot.swift
//  CityXcape
//
//  Created by James Allan on 8/25/23.
//

import SwiftUI
import SDWebImageSwiftUI


struct UserDot: View {
    let width: CGFloat
    let user: User
    let ratio: CGFloat = 1.3
    
    var body: some View {
        Image("dot")
            .resizable()
            .scaledToFit()
            .frame(width: width, height: width)
            .overlay(
                WebImage(url: URL(string: user.imageUrl ?? ""))
                    .resizable()
                    .frame(width: width / ratio, height: width / ratio)
                    .clipShape(Circle())
            )
    }
}

struct UserDot_Previews: PreviewProvider {
    static var previews: some View {
        UserDot(width: 400, user: User.demo)
            .previewLayout(.sizeThatFits)
    }
}
