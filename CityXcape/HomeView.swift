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

    @State var selection: Int = 0
    @State var currentSpot: Location?
    
    
    @State private var showDetails: Bool = false
    var body: some View {
        TabView(selection: $selection) {
            LocationsView()
                .environmentObject(vm)
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
            
            
            MessagesView()
                .tag(2)
                .tabItem {
                    Image(systemName: Tab.connections.rawValue)
                    Text(Tab.connections.title)
                }
            
           
            StreetPass(user: User.demo)
                .tag(3)
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
