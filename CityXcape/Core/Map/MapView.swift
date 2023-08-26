//
//  Map.swift
//  CityXcape
//
//  Created by James Allan on 8/24/23.
//

import SwiftUI
import MapKit

struct MapView: View {
 
    var body: some View {
        ZStack {
            MapViewRepresentable()
                .edgesIgnoringSafeArea(.top)
                .colorScheme(.dark)
        }
        .colorScheme(.dark)
    }
       
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
