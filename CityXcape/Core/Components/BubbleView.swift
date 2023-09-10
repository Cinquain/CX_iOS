//
//  BubbleView.swift
//  CityXcape
//
//  Created by James Allan on 8/25/23.
//

import SwiftUI
import SDWebImageSwiftUI


struct BubbleView: View {
    
    @State private var animate: Bool = false
    
    let width: CGFloat
    let imageUrl: String
    let type: StreetPasType
    
    var body: some View {
        
        ZStack {
       
            Circle()
              .fill(type == .stranger ? .orange.opacity(0.45) :
                    .blue.opacity(0.45))
              .frame(width: width, height: width)
              .scaleEffect(self.animate ? 1.08 : 0.5)
              .animation(Animation.linear(duration: 2.2)
                  .repeatForever(autoreverses: true), value: animate)
              .shadow(color: type == .stranger ? .orange.opacity(0.5) :
                    .blue.opacity(0.5), radius: 10)

           
            
            Image(type == .stranger ? "dot" : "dot_blue")
                .resizable()
                .scaledToFit()
                .frame(width: width, height: width)
                .overlay {
                    WebImage(url: URL(string: imageUrl))
                        .resizable()
                        .frame(width: width * 3/4, height: width * 3/4)
                        .clipShape(Circle())
                }
                .shadow(color:type == .stranger ? .orange.opacity(0.5) :
                        .blue.opacity(0.5), radius: 10)
            
        }
        .onAppear {
            self.animate.toggle()
        }
        
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            BubbleView(width: 300, imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FW6EUJxka1OihhJ0Iyest%2F2-min.jpg?alt=media&token=1930940d-704f-42b1-aa2b-cd8c919b0161", type: .stranger)
                .previewLayout(.sizeThatFits)
            
            Spacer()
            HStack {
                Spacer()
            }
        }
        .background(.black)
    }
}
