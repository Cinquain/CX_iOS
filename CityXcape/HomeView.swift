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
            DiscoverView()
                .environmentObject(vm)
                .tag(0)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(Tab.discover.title)
                }
            
            MapView(vm: mapVM)
                .tag(1)
                .tabItem {
                    Image(Tab.post.rawValue)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .font(.title)
                    Text(Tab.post.title)
                }
            
            StreetPass(user: User.demo)
                .tag(2)
                .tabItem {
                    Image(systemName: "person.fill")
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
