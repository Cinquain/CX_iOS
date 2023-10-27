//
//  PublicStreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/25/23.
//

import SwiftUI

struct PublicStreetPass: View {
    
    //MARK: USER DEFAULTS
    @AppStorage(AppUserDefaults.streetcred) var streetcred: Int?

    //MARK: STATE PROPERTIES
    @State private var showMenu: Bool = false
    @State private var message: String = ""
    @State private var isWaving: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessgae: String = ""
    
    let user: User
    var body: some View {
        GeometryReader {
            let size = $0.size
            VStack {
                StreetPassHeader()
                UserDot()
                Spacer()
                    .frame(height: 80)
                TextMessage()
                WaveButton()
                Spacer()
                
            }
            .frame(width: size.width, height: size.height)
           
        }
        .background(Background())
       


    }
    
    @ViewBuilder
    func Background() -> some View {
        ZStack {
            Color.black
            Image("orange-paths")
                .resizable()
                .scaledToFill()
                .opacity(0.8)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func TextMessage() -> some View {
        TextField("  Write a Message", text: $message)
            .frame(width: 250, height: 40)
            .background(.white.opacity(0.9))
            .clipShape(Capsule())
            .padding(.bottom, 30)
            .opacity(isWaving ? 1 : 0)
            .animation(.easeOut(duration: 0.5), value: isWaving)
    }
    
    @ViewBuilder
    func StreetPassHeader() -> some View {
        HStack {
            Text("STREETPASS")
                .font(.system(size: 24))
                .fontWeight(.thin)
                .foregroundColor(.white)
                .tracking(4)
                .padding(.top, 5)
                .popover(isPresented: $showMenu) {
                    BuyStreetCred()
                        .presentationDetents([.height(380)])
                }
            Spacer()
        }
        .padding(.horizontal, 25)
    }
    
    @ViewBuilder
    func UserDot() -> some View {
        VStack(spacing: 3) {
            BubbleView(width: 300,
                       imageUrl: user.imageUrl,
                     type: .stranger)
            Text(user.username)
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.thin)
                .alert(isPresented: $showAlert) {
                    return Alert(title: Text(alertMessgae))
                }
        }
    }
    
    @ViewBuilder
    func WaveButton() -> some View {
        Button {
            sendWave()
        } label: {
            HStack(spacing: 2) {
                Image(systemName: "hands.sparkles.fill")
                    .foregroundColor(.white)
                
                Text(isWaving ? "Send" : "Connect")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .background(Capsule()
                .fill(.orange.opacity(0.5))
                .frame(width: 150, height: 40))
        }
    }
    
    func sendWave() {
        if streetcred == nil || streetcred == 0 {showMenu.toggle(); return}
        
        if !isWaving {
            isWaving.toggle()
            return
        }
        
        if message.count < 3 {
            alertMessgae = "Your message must be at least 3 characters long"
            showAlert.toggle()
            return
        }

        Task {
            do {
                try await DataService.shared.sendRequest(userId: user.id, message: message)
                isWaving.toggle()
                alertMessgae = "Message Sent"
                showAlert.toggle()
            } catch {
                alertMessgae = error.localizedDescription
                showAlert.toggle()
                }
            }
        }
    
    }
        
    


struct PublicStreetPass_Previews: PreviewProvider {
    static var previews: some View {
        PublicStreetPass(user: User.demo)
    }
}
