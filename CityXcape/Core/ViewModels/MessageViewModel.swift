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
    
    
    
    func sendMessage(uid: String) {
        
    }
    
    func fetchMessages(uid: String) {
        
    }
    
    func deleteRecentMessage(uid: String) {
        
    }
    
    func removeListener() {
        
    }
}
