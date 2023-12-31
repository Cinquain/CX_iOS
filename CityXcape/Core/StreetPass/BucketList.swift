//
//  BucketList.swift
//  CityXcape
//
//  Created by James Allan on 10/2/23.
//

import SwiftUI

struct BucketList: View {
    @State var locations: [Location]
    @EnvironmentObject private var vm: LocationsViewModel
    @State private var currentSpot: Location?
    
    @State var errorMessage: String = ""
    @State var showAlert: Bool = false
    var body: some View {
        VStack {
            header()
        
            spotList()
            Spacer()
        }
        .background(background())
    }
    
    @ViewBuilder
    func header() -> some View {
        VStack {
            HStack {
                Image("Pin")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                Text("\(locations.count) Spots to Visit")
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .font(.title2)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            Divider()
                .background(.white)
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            
            Image("bricks")
                .resizable()
                .scaledToFill()
                .opacity(0.25)
            
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func spotList() -> some View {
            ForEach(locations) { spot in
                HStack {
                    Button {
                        currentSpot = spot
                    } label: {
                        PinView(height: 40, url: spot.imageUrl)
                        Text(spot.name)
                            .fontWeight(.thin)
                            .foregroundColor(.white)
                    }

                    
                    Spacer()
                    Button {
                        delete(spot: spot)
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.callout)
                    }

                    
                }
                .padding(.horizontal, 20)
                .fullScreenCover(item: $currentSpot) { spot in
                    LocationView(spot: spot)
                }
               
                Divider()
                    .foregroundColor(.white)
                    .frame(height: 0.5)
               
            }
           
    }
    
    fileprivate func delete(spot: Location) {
        Task {
            do {
                try await DataService.shared.unsaveLocation(spotId: spot.id)
                if let index = locations.firstIndex(where: {$0.id == spot.id}) {
                    locations.remove(at: index)
                }
            } catch {
                errorMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
}

struct BucketList_Previews: PreviewProvider {
    static var previews: some View {
        BucketList(locations: [])
    }
}
