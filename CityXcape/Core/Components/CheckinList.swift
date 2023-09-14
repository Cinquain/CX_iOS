//
//  CheckinList.swift
//  CityXcape
//
//  Created by James Allan on 8/25/23.
//

import SwiftUI

struct CheckinList: View {
    
    let spot: Location
    @State var users: [User]
    @State var currentUser: User?
    
    var body: some View {
            VStack {
                
                Header()

                Divider()
                    .frame(height: 1)
                    .background(Color.white)
                
                UserScrollView()
               
            }
           

        
     

    }
    
    func getTitle() -> String {
        if users.count > 1 {
            return "\(users.count) People Inside \(spot.name)"
        } else {
            return "\(users.count) Person Inside \(spot.name)"
        }
    }
    
    @ViewBuilder
    func Header() -> some View {
        HStack {
            Text(getTitle())
                .font(.headline)
                .fontWeight(.thin)
            
            .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.top, 15)
    }
    
    @ViewBuilder
    func UserScrollView() -> some View {
        
        ScrollView {
            ForEach(users) { user in
                HStack {
                    VStack(spacing: 2) {
                        Button {
                            currentUser = user
                        } label: {
                            UserDot(width: 80, imageUrl: user.imageUrl ?? "")
                        }
                        .sheet(item: $currentUser) { user in
                            PublicStreetPass(user: user)
                        }
                        
                        Text(user.username ?? "")
                            .fontWeight(.thin)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        currentUser = user
                    } label: {
                        VStack(spacing: 2) {
                            HStack(spacing: 4) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.white)
                                    .frame(height: 30)
                                
                                Text("\(Int.random(in: 1...100)) likes in common")
                                    .foregroundColor(.white)
                                    .fontWeight(.thin)
                                Spacer()
                            }
                            .frame(width: 220)
                            HStack(spacing: 4) {
                                Image("Stamp")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                
                                Text("\(Int.random(in: 1...100)) spots in common")
                                    .foregroundColor(.white)
                                    .fontWeight(.thin)
                                
                                Spacer()
                            }
                            .frame(width: 220)

                        }
                        .padding(20)
                    }

                  
                   

                    
                    Spacer()
                    
                }
                .padding(.horizontal, 10)
               
            }
        }
    }
}

struct CheckinList_Previews: PreviewProvider {
    static var previews: some View {
        CheckinList(spot: Location(data: Location.data), users: [User.demo])
    }
}
