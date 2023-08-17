//
//  SignUpView.swift
//  CityXcape
//
//  Created by James Allan on 8/17/23.
//

import SwiftUI
import AsyncButton

struct SignUpView: View {
    
    
    var body: some View {
        GeometryReader {
            let size = $0.size
           
                VStack {
                    Spacer()
                    HeaderView()
                    SignInButtons()
    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                }
                .frame(width: size.width, height: size.height)
                .edgesIgnoringSafeArea(.bottom)
              
        }
        .background(Color.black)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            Image("Broken Pin")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .clipShape(Circle())
                .shadow(color: .orange, radius:10)
                
            Text("SIGN IN WITH")
                .foregroundColor(.white)
                .fontWeight(.thin)
                .padding(.top, 8)
                .tracking(5)
        }
    }
    
    @ViewBuilder
    func SignInButtons() -> some View {
        HStack {
            AsyncButton {
                    try? await AuthService.shared.startSignInWithGoogleFlow()
            } label: {
                Image("Google-Symbol")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                   
            }
            
            Button {
                    AuthService.shared.startSignInWithAppleFlow()
            } label: {
                Image("apple-emblem")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 78, height: 78)
                    .clipShape(Circle())
                   
            }
        }
    }
    
   
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
