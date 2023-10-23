//
//  WaveViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/20/23.
//

import Foundation



class WaveViewModel: ObservableObject {
    

    @Published var lastCardIndex: Int = 1
    @Published var waveCount: Int = 1
    @Published var showMatch: Bool = false
    @Published var messages: [Message] = []
    
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    init() {
        fetcConnectionRequests()
    }
 
    
    
    func fetcConnectionRequests() {
        Task {
            do {
                self.messages = try await DataService.shared.fetchRequests()
            } catch {
                errorMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func match(message: Message) {
        showMatch.toggle()
        do {
            try DataService.shared.acceptRequest(message: message)

        } catch {
            errorMessage = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func deleteWave(id: String) {
        Task {
            do {
                try await DataService.shared.deleteRequest(id: id)
                if let index = messages.firstIndex(where: {$0.id == id}) {
                    messages.remove(at: index)
                }
            } catch {
                errorMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    
    
    
}
