//
//  WorldView.swift
//  CityXcape
//
//  Created by James Allan on 8/15/23.
//

import SwiftUI

struct WorldView: View {
    
    let world: World
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    
}

struct WorldView_Previews: PreviewProvider {
    static var previews: some View {
        WorldView(world: World.scout)
    }
}
