//
//  MessageBubble.swift
//  CityXcape
//
//  Created by James Allan on 9/5/23.
//

import SwiftUI
import FirebaseAuth

struct MessageBubble: View {
    var message: Message
    
    var body: some View {
        if message.fromId == Auth.auth().currentUser?.uid ?? "" {
            HStack {
                Spacer()
                HStack {
                    Text(message.content)
                        .foregroundColor(.orange)
                }
                .padding()
                .background(.gray)
                .cornerRadius(8)
            }
        } else {
            HStack {
                HStack {
                    Text(message.content)
                        .foregroundColor(.black)
                }
                .padding()
                .background(.orange)
                .cornerRadius(8)
                Spacer()
            }
        }
        //End of body
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message.demo)
    }
}
