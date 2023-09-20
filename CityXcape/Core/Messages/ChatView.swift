//
//  ChatView.swift
//  CityXcape
//
//  Created by James Allan on 9/14/23.
//

import SwiftUI

struct ChatView: View {
    let user: User
    @StateObject var vm: MessageViewModel
    
    var body: some View {
        ZStack {
            messagesView()
            
            VStack {
                Spacer()
                chatBottomBar()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                header()
            }
        }
        .onAppear {
            vm.fetchMessages(uid: user.id)
            vm.deleteRecentMessage(uid: user.id)
        }
        .onDisappear {
            vm.removeListener()
        }
        
    }
    
    
    @ViewBuilder
    func messagesView() -> some View {
        ScrollView {
            ScrollViewReader { proxy in
                
                ForEach(vm.messages) {
                    MessageBubble(message: $0)
                }
                
                HStack{ Spacer() }
                    .id(Keys.proxy.rawValue)
                    .onReceive(vm.$count) { _ in
                        withAnimation {
                            proxy.scrollTo(Keys.proxy.rawValue)
                        }
                    }
            }
        }
        .background(.black)
    }
    
    @ViewBuilder
    func chatBottomBar() -> some View {
        HStack {
            Button {
                //Share a photo
            } label: {
                Image(systemName: "photo.fill")
                    .foregroundColor(.gray)
                    .font(.title)
                    .frame(height: 40)
            }
            
            TextField("write your message", text: $vm.message)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.white.opacity(0.9))
                .opacity(vm.message.isEmpty ? 0.8 : 1)
                .clipShape(Capsule())
            
            Button {
                vm.sendMessage(uid: user.id)
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.blue)
            .cornerRadius(4)


        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack(spacing: 2) {
            UserDot(width: 35, imageUrl: user.imageUrl)
            Text(user.username)
                .foregroundColor(.white)
                .fontWeight(.thin)
        }
    }
    
}



struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(user: User.demo, vm: MessageViewModel())
        }
    }
}
