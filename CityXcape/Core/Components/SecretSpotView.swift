//
//  SecretSpotView.swift
//  CityXcape
//
//  Created by James Allan on 8/15/23.
//

import SwiftUI

struct SecretSpotView: View {
    
    @State private var offset: CGFloat = 550
    var body: some View {
        
            ZStack {
               MainImage()
                
      
                ZStack {
                    BlurView(style: .systemMaterialDark)
                    DrawerView()
                }
                .offset(y: offset)

            }
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let startLocation = value.startLocation
                        offset = startLocation.y + value.translation.height
                    })
            )
            
      
        
    }
    
    @ViewBuilder
    func MainImage() -> some View {
        GeometryReader {
            let size = $0.size
            Image("Example")
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func DrawerView() -> some View {
        VStack {
            Capsule()
                .frame(width: 100, height: 7)
                .foregroundColor(.white)
                .padding(.top, 7)
            
            HStack(alignment: .center) {
                
                
                CustomButton(systemName: "checkmark.seal.fill", status: false, activeTint: .red, background: .green) {
                    //Checkin User
                }
                                
                
                CustomButton(systemName: "bubble.left.fill", status: false, activeTint: .purple, background: .blue) {
                    //Leave a Comment
                }
                
                CustomButton(systemName: "person.2.fill", status: false, activeTint: .orange, background: .yellow.opacity(0.8)) {
                    //View others who saved
                }
                
                
            }
            .padding(.top, 5)
            
            Spacer()
        }
    }
    
}

struct SecretSpotView_Previews: PreviewProvider {
    static var previews: some View {
        SecretSpotView()
    }
}
