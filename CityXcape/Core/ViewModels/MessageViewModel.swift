//
//  MessagesViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/5/23.
//

import Foundation


class MessageViewModel: ObservableObject {
    
    @Published var connections: [User] = [User.demo, User.demo3, User.demo, User.demo3, User.demo2, User.demo3, User.demo2,]

    @Published var messages: [Message] = []
    @Published var convo: [Message] = []
    
    @Published var count: Int = 0
    @Published var message: String = ""
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var showConnections: Bool = false 
 
    init() {
        fetchAllMessages()
    }
    
    
    func fetchMessages(uid: String) {
        DataService.shared.getMessages(userId: uid) { result in
            switch result {
            case .success(let messages):
                self.convo = messages
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlert.toggle()
            }
        }

    }
    
    func fetchAllMessages(){
        DataService.shared.fetchAllMessages { result in
            switch result {
            case .success(let recent):
                self.messages = recent
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlert.toggle()
            }
        }
    }
    
    func deleteRecentMessage(uid: String) {
        messages.removeAll(where: {$0.fromId == uid})
        DataService.shared.deleteRecentMessage(userId: uid)
    }
    
    func removeListener() {
        DataService.shared.removeChatListener()
    }
    
    func sendMessage(user: User) {
        Task {
            do {
                try await  DataService.shared.sendMessage(user: user, content: message)
                message = ""
            } catch {
                errorMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
   
}
