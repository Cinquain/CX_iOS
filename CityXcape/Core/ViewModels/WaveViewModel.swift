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
    
    
    func moveCard() {
        
        
    }
    
    func match() {
        showMatch.toggle()
        
    
    }
}
