//
//  WaveViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/20/23.
//

import Foundation



class WaveViewModel: ObservableObject {
    
    @Published var cardView: CardView? = CardView(wave: Wave.demo)

    @Published var lastCardIndex: Int = 1
    @Published var waveCount: Int = 1
    @Published var showMatch: Bool = false
    @Published var waves: [Wave] = []
    
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    init() {
        fetchAllWaves()
    }
 
    
    
    func fetchAllWaves() {
        Task {
            do {
                self.waves = try await DataService.shared.fetchWaves()
            } catch {
                errorMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func match(wave: Wave) {
        showMatch.toggle()
        do {
            try DataService.shared.acceptWave(wave: wave)

        } catch {
            errorMessage = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func deleteWave(id: String) {
        Task {
            do {
                try await DataService.shared.deleteWave(waveId: id)
                if let index = waves.firstIndex(where: {$0.id == id}) {
                    waves.remove(at: index)
                }
            } catch {
                errorMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    
    
    
}
