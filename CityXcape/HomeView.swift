//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: LocationsViewModel
    @StateObject var mapVM = MapViewModel()
    @StateObject var spVM = StreetPassViewModel()
    @StateObject var mesVM = MessageViewModel()
    @StateObject var waveVM = WaveViewModel()

    @State var selection: Int = 0
    @State var currentSpot: Location?
    
    
    @State private var showDetails: Bool = false
    var body: some View {
        TabView(selection: $selection) {
            LocationsView()
                .environmentObject(vm)
                .environmentObject(spVM)
                .tag(0)
                .tabItem {
                    Image(Tab.locations.rawValue)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .font(.title)
                    Text(Tab.locations.title)
                }
            
            
            MapView(vm: mapVM)
                .tag(1)
                .tabItem {
                    Image(systemName: Tab.post.rawValue)
                    Text(Tab.post.title)
                }
            
            WavesView(tabIndex: $selection, vm: waveVM)
                .tag(2)
                .badge(waveVM.waveCount)
                .tabItem {
                    Image(Tab.waves.rawValue)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        
                    Text(Tab.waves.title)
                }
            
            
            MessagesView()
                .tag(3)
                .badge(mesVM.messages.count)
                .environmentObject(mesVM)
                .tabItem {
                    Image(systemName: Tab.messages.rawValue)
                    Text(Tab.messages.title)
                }
            
           
            StreetPass(user: User.demo)
                .tag(4)
                .environmentObject(spVM)
                .tabItem {
                    Image(systemName: Tab.profile.rawValue)
                    Text(Tab.profile.title)
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
