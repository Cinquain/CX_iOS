//
//  OnboardingI.swift
//  CityXcape
//
//  Created by James Allan on 8/11/23.
//

import SwiftUI
import AsyncButton

struct StartScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var startOnboarding: Bool = false

    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack {
                Logo()
                    .offset(y: 100)
                Spacer()
                StartButton()
                    .padding(.bottom, 40)
            }
            .frame(width: size.width, height: size.height)
            .background(Background())
           
            
           
            
        }
        .ignoresSafeArea()

    }
    @ViewBuilder
    func Logo() -> some View {
        VStack(spacing: 0) {

            Text("CREATE A WORLD")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.thin)
                .tracking(5)
                .multilineTextAlignment(.center)
            
            Text("A world is a group of people \n who share secret spots")
                .font(.title3)
                .foregroundColor(.white)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    func StartButton() -> some View {
        Button {
            startOnboarding.toggle()
        } label: {
            Text("Get Started")
                .foregroundColor(.black)
                .fontWeight(.light)
                .background(
                    Rectangle()
                        .fill(.white)
                        .frame(width: 250, height: 40)
                        .cornerRadius(20)
                )
                .padding(.top, 20)
                .shadow(color: .white, radius: 2)
               
        }
    }
    
    @ViewBuilder
    func Background() -> some View {
        GeometryReader {
            let size  = $0.size
            Image("moon_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                .black.opacity(0.1),
                                .black.opacity(0.2),
                                .black.opacity(0.8),
                                .black], startPoint: .bottom, endPoint: .top))
                            .frame(height: size.height)
                    }
                }
        }
    }
    
}

struct OnboardingI_Previews: PreviewProvider {
    static var previews: some View {
        StartScreen()
    }
}
