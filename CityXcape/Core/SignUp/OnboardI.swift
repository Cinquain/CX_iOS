//
//  OnboardI.swift
//  CityXcape
//
//  Created by James Allan on 8/15/23.
//

import SwiftUI

struct OnboardI: View {
    var body: some View {
        var worlds: [World] = []
        GeometryReader {
            let size = $0.size
            
            VStack {
                Text("CHOOSE A WORLD")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .tracking(8)
                Text("A world is a community of people who  \n shares values and locations")
                    .font(.callout)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fontWeight(.thin)
                Spacer()
                
                ScrollView {
                    ForEach(worlds) { world in
                        /*@START_MENU_TOKEN@*/Text(world.id)/*@END_MENU_TOKEN@*/
                    }
                }
            }
            .frame(width: size.width, height: size.height)
            .background(Background())
        }
        .edgesIgnoringSafeArea(.bottom)

    }
    
    @ViewBuilder
    func Background() -> some View {
        ZStack {
            Image("globe_background")
                .resizable()
                .scaledToFill()
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                .black.opacity(0.1),
                                .black.opacity(0.2),
                                .black.opacity(0.2),
                                .black.opacity(0.8),
                                .black], startPoint: .bottom, endPoint: .top))
                    }
                }
        }
    }
}

struct OnboardI_Previews: PreviewProvider {
    static var previews: some View {
        OnboardI()
    }
}
