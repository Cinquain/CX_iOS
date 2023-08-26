//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: LocationsViewModel
    
    @State var selection: Int = 0
    @State var currentSpot: Location?
    
    
    @State private var showDetails: Bool = false
    var body: some View {
        TabView(selection: $selection) {
            DiscoverView()
                .environmentObject(vm)
                .tag(0)
                .tabItem {
                    Image(systemName: TabItem.item1Image)
                        .foregroundColor(.white)
                        .font(.title2)
                    Text(TabItem.item1Label)
                }
            
            MapView()
                .tag(1)
                .tabItem {
                    Image(TabItem.item2Image)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .font(.title)
                    Text(TabItem.item2Label)
                }

        }
        .colorScheme(.dark)
        .accentColor(.white)
       
    }
    
   
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(LocationsViewModel())
    }
}
