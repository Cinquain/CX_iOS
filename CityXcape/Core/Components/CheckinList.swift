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
                
                HStack {
                    Image("Pin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .overlay {
                            Text("\(users.count)")
                                .font(.caption)
                                .fontWeight(.thin)
                                .foregroundColor(.white)
                                .padding(.bottom, 2)
                        }
                    Text("Currently Inside \(spot.name)")
                        .font(.headline)
                        .fontWeight(.thin)
                    
                    .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.top, 15)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.white)
                
                ScrollView {
                    ForEach(users) { user in
                        HStack {
                            VStack(spacing: 2) {
                                Button {
                                    currentUser = user
                                } label: {
                                    UserDot(width: 80, user: user)
                                }
                                .sheet(item: $currentUser) { user in
                                    PublicStreetPass(user: user)
                                }
                                
                                Text(user.username ?? "")
                                    .fontWeight(.thin)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            
                          
                            Spacer()
                            
                            Button {
                                //
                            } label: {
                                Image(systemName: "hands.sparkles.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 55, height: 55)
                                    .background(.orange.opacity(0.3))
                                    .clipShape(Circle())
                                
                            }

                        }
                        .padding(.horizontal, 10)
                       
                    }
                }
            }
            .background(.black)
            .edgesIgnoringSafeArea(.bottom)

        
     

    }
}

struct CheckinList_Previews: PreviewProvider {
    static var previews: some View {
        CheckinList(spot: Location(data: Location.data), users: [User.demo])
    }
}
