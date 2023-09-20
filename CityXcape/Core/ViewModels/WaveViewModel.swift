//
//  WaveViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/20/23.
//

import Foundation



class WaveViewModel: ObservableObject {
    
    @Published var cardViews: [CardView] = [CardView(message: RecentMessage.demo), CardView(message: RecentMessage.demo2)]

    
    
    func isTopCard(cardView: CardView) -> Bool {
            guard let index = cardViews.firstIndex(where: {$0.id == cardView.id}) else {return false}
            return index == 0
    }
}
