//
//  SignUpViewII.swift
//  CityXcape
//
//  Created by James Allan on 9/11/23.
//

import SwiftUI
import PhotosUI

struct SignUpViewII: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: StreetPassViewModel
    
    var body: some View {
        VStack(spacing: 50) {
            StreetPassHeader()
                Spacer()
            ZStack {
                PhotosPicker(selection: $vm.selectedItem) {
                    BubbleView(width: 300,
                               imageUrl: vm.profileUrl,
                               type: .personal)
                }
               
                if vm.profileUrl == "" {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                }
               
            }
            
            TextField("What's your username?", text: $vm.username)
                .padding()
                .background(.white.opacity(0.8))
                .foregroundColor(.black)
                .frame(width: 260)
                .clipShape(Capsule())
                .alert(isPresented: $vm.showAlert) {
                    return Alert(title: Text(vm.alertMessage))
                }
            Spacer()
            
            Button {
                vm.createStreetPass()
                if vm.success {dismiss()}
            } label: {
                Text("Create Streetpass")
                    .fontWeight(.thin)
                    .foregroundColor(.black)
                    .frame(width: 220, height:40)
                    .background(.orange.opacity(0.8))
                    .clipShape(Capsule())
                    
            }
            .disabled(vm.isUploading)

            Spacer()
    
                
            
        }
        .background(Background())
    }
    
    @ViewBuilder
    func Background() -> some View {
        ZStack {
            Color.black
            Image("street-paths")
                .resizable()
                .scaledToFill()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func StreetPassHeader() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Get Your STREETPASS")
                    .font(.title2)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .tracking(4)
                    .opacity(0.8)
                Spacer()

            }
            Text("A StreetPass is a key to the city \(Image("key_feed"))")
                .foregroundColor(.white)
                .font(.callout)
                .fontWeight(.thin)
        }
        .padding(.horizontal, 25)

    }
    

    
}

struct SignUpViewII_Previews: PreviewProvider {
    static var previews: some View {
        SignUpViewII(vm: StreetPassViewModel())
    }
}
