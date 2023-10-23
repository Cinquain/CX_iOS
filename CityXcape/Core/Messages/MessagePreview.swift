//
//  MessagePreview.swift
//  CityXcape
//
//  Created by James Allan on 9/5/23.
//

import SwiftUI

struct MessagePreview: View {
    
    //User for now, Message Model Later
    var message: Message
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                UserDot(width: 60, imageUrl: message.profileUrl)

                VStack(alignment: .leading) {
                    Text(message.displayName)
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                    
                    Text(message.content)
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .lineLimit(1)
                    
                }
                
                Spacer()

                Text(message.timestamp.timeAgo())
                    .font(.system(size: 14, weight: .semibold))
                    .fontWeight(.light)
                    .frame(width: 70)
                    .foregroundColor(.white)
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
        MessagePreview(message: Message.demo)
    }
}
