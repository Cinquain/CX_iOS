//
//  StreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/29/23.
//

import SwiftUI
import PhotosUI

struct StreetPass: View {
    
    let user: User
    @StateObject var vm: StreetPassViewModel
    
    var body: some View {
        
            VStack {
                StreetPassHeader()
                UserDot()
                Spacer()
                    .frame(height: 70)
                MyJourney()
                 
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
        HStack {
            Text("STREETPASS")
                .font(.system(size: 24))
                .fontWeight(.thin)
                .foregroundColor(.white)
                .tracking(4)
                .opacity(0.5)
            Spacer()
            Menu {
                //Sign out user
                Button(action: signOut) {
                       Label("Signout", systemImage: "point.filled.topleft.down.curvedto.point.bottomright.up")
                   }
                
                Button(action: signOut) {
                       Label("Delete Account", systemImage: "power.circle")
                   }
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.5))
            }

        }
        .padding(.horizontal, 25)
    }
    
    @ViewBuilder
    func UserDot() -> some View {
        
        PhotosPicker(selection: $vm.selectedItem, matching: .images) {
            VStack(spacing: 3) {
                BubbleView(width: 300, imageUrl: vm.profileUrl, type: .personal)
                
                Text(user.username ?? "Create Username")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                  
            }
        }
        
    }
    
    @ViewBuilder
    func MyJourney() -> some View {
  
        Button {
            //
        } label: {
            HStack {
                Image("Journey")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
                Text("My Journey")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
            }
            
        }
        
    }
    
    func signOut() {
        //Sign out & clear user defaults
    }
    
    func deleteAccount() {
        //Delete auth
        
        //Delete Firestorage photos
        
        //Delete Firestore database
        
        //Delete all location user posted
    }
    
    
}

struct StreetPass_Previews: PreviewProvider {
    static var previews: some View {
        StreetPass(user: User.demo, vm: StreetPassViewModel())
    }
}
