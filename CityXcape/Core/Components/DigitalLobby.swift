//
//  CheckinList.swift
//  CityXcape
//
//  Created by James Allan on 8/25/23.
//

import SwiftUI

struct DigitalLobby: View {
    
    let spot: Location
    @StateObject var vm: LocationsViewModel
    @State var currentMessage: Message?
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
            VStack {
                
                Header()
                status()
               
                
                UserScrollView()
                
                textInput()
               
            }
            .background(.black)

    }
    

    
    @ViewBuilder
    func Header() -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 5) {
                Image("Pin")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                
                Text(spot.name)
                    .font(.title)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .sheet(isPresented: $vm.showBuy) {
                        BuyStreetCred()
                            .presentationDetents([.medium])
                    }
                
                Spacer()
                
                Button {
                    vm.checkOut(spot: spot)
                } label: {
                    Image(systemName: "xmark.square.fill")
                        .foregroundColor(.white)
                        .font(.title)
                }

            }
            .padding(.horizontal, 10)
            .padding(.top, 15)
            
            Divider()
                .frame(height: 1)
                .background(Color.white)
        }
    }
    
    @ViewBuilder
    func status() -> some View {
        VStack {
            HStack(spacing: 4) {
                Image("hive")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                
                Text(liveCountTitle())
                    .font(.callout)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    
                Spacer()

            
            }

        }
        .padding(.horizontal, 10)
    }
    
    fileprivate func liveCountTitle() -> String {
        if spot.liveCount == 0 {
            return "Digital Lobby: 1 Person"
        } else {
            return "Digital Lobby: \(spot.liveCount + 1) People"

        }
    }
    
    @ViewBuilder
    func textInput() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                TextField("Broadcast a Message", text: $vm.chatInput)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(.gray)
                    .clipShape(Capsule())
                
                Spacer()
                
                Button {
                    vm.sendMessage(id: spot.id)
                } label: {
                    Text("Send")
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.cx_blue)
                .cornerRadius(3)
                
            }
            .padding(.horizontal)
        .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    func UserScrollView() -> some View {
        
        ScrollView {
            ForEach(vm.checkins) { message in
                HStack(alignment: .center) {
                    VStack(spacing: 2) {
                        Button {
                            currentMessage = message
                        } label: {
                            UserDot(width: 80, imageUrl: message.profileUrl)
                        }
                        .sheet(item: $currentMessage) { message in
                            PublicStreetPass(user: User(message: message))
                        }
                        
                       
                    }
                    
                    Button {
                        currentMessage = message
                    } label: {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(message.displayName)
                                .fontWeight(.thin)
                                .font(.callout)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 4) {
                                    Text(message.content)
                                        .foregroundColor(.white)
                                        .fontWeight(.thin)
                                        .lineLimit(1)
                                    Spacer()
                                }
                        
                            .frame(width: 220)
                        }
                        
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
        DigitalLobby(spot: Location(data: Location.data), vm: LocationsViewModel())
    }
}
