//
//  WaveViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/20/23.
//

import Foundation
import UserNotifications



class WaveViewModel: ObservableObject {
    

    @Published var lastCardIndex: Int = 1
    @Published var waveCount: Int = 1
    @Published var showMatch: Bool = false
    @Published var messages: [Message] = []
    
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var matchedUrl: String?
    
    init() {
        fetcConnectionRequests()
    }
 
    
    
    func fetcConnectionRequests() {
        DataService.shared.fetchRequests { result in
            switch result {
            case .success(let newMessages):
                self.messages = newMessages
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlert.toggle()
            }
        }
    }
    
    func removeNotification(uid: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uid])
    }
    
    func match(message: Message) {
        showMatch.toggle()
        removeNotification(uid: message.id)
        matchedUrl = message.profileUrl
        do {
            try DataService.shared.acceptRequest(message: message)
        } catch {
            errorMessage = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func deleteWave(id: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            self.showMatch = false
        })
        Task {
            do {
                try await DataService.shared.deleteRequest(id: id)
            } catch {
                errorMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    
    
    
}
