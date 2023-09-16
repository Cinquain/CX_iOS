//
//  ConnectionsView.swift
//  CityXcape
//
//  Created by James Allan on 9/16/23.
//

import SwiftUI

struct ConnectionsView: View {
    @StateObject var vm: MessageViewModel
    
    var body: some View {
            VStack {
                ForEach(vm.connections) { user in
                    NavigationLink {
                        ChatView(user: user, vm: vm)
                    } label: {
                        userRow(user: user)
                    }
                    Divider()
                        .frame(height: 0.5)
                        .background(.white)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .background(.black)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Friends")
          

       
        
    }
    
    @ViewBuilder
    func userRow(user: User) -> some View {
        HStack {
            UserDot(width: 60, imageUrl: user.imageUrl)
            Text(user.username)
                .foregroundColor(.white)
                .fontWeight(.thin)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Image("dot")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            Text("\(vm.connections.count) Connections")
                .font(.title2)
                .foregroundColor(.white)
                .fontWeight(.thin)
        }
    }
}

struct ConnectionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionsView(vm: MessageViewModel())
    }
}
