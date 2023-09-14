//
//  MessagePreview.swift
//  CityXcape
//
//  Created by James Allan on 9/5/23.
//

import SwiftUI

struct MessagePreview: View {
    
    //User for now, Message Model Later
    var user: User
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                UserDot(width: 60, imageUrl: user.imageUrl ?? "")

                VStack(alignment: .leading) {
                    Text(user.username ?? "")
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                    
                    Text("When are you coming over")
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                }
                
                Spacer()
                
                Text(user.joinDate.timeAgo())
                    .font(.system(size: 14, weight: .semibold))
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .frame(width: 60)
                    .lineLimit(1)
            
            }
            
            
            Divider()
                .frame(height: 0.5)
                .background(.white)
                .padding(.leading, 80)
            
            
        }
        .padding(.horizontal)
        .background(.black)
    }
}

struct MessagePreview_Previews: PreviewProvider {
    static var previews: some View {
        MessagePreview(user: User.demo)
    }
}
