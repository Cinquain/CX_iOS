//
//  MessagesViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/5/23.
//

import Foundation


class MessageViewModel: ObservableObject {
    
    @Published var connections: [User] = [User.demo, User.demo3, User.demo, User.demo3, User.demo2, User.demo3, User.demo2,]
    @Published var messages: [Message] = [Message.demo, Message.demo2, Message.demo3, Message.demo4, Message.demo5, Message.demo6]
    @Published var recentMessages: [RecentMessage] = [RecentMessage.demo, RecentMessage.demo2, RecentMessage.demo, RecentMessage.demo2]
    
    @Published var count: Int = 0
    @Published var message: String = ""
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    
    func sendMessage(uid: String) {
        
    }
    
    func fetchMessages(uid: String) {
        DataService.shared.getMessages(userId: uid) { result in
            switch result {
            case .success(let messages):
                self.messages = messages
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlert.toggle()
            }
        }

    }
    
    func deleteRecentMessage(uid: String) {
        
    }
    
    func removeListener() {
        DataService.shared.removeChatListener()
    }
}
