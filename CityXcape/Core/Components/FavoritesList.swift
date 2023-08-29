//
//  SavesList.swift
//  CityXcape
//
//  Created by James Allan on 8/27/23.
//

import SwiftUI

struct FavoritesList: View {
    let spot: Location
    @State var locations: [Location]
    
    var body: some View {
        VStack {
            Header()
            
            Divider()
                .frame(height: 1)
                .background(Color.white)
            
            SpotList()
        }
        .cornerRadius(12)
        .background(.black)
        .edgesIgnoringSafeArea(.bottom)

    }
    
    @ViewBuilder
    func Header() -> some View {
        HStack {
            Image(systemName: "figure.walk.circle.fill")
                .font(.title)
                .foregroundColor(.white)
                .frame(height: 30)
               
            Text("Saved to Your Journey")
                .font(.title3)
                .fontWeight(.thin)
                .foregroundColor(.white)
                .padding(.bottom, 2)
            
            .foregroundColor(.white)
            Spacer()
        }
        .background(.black)
        .padding(.horizontal, 10)
        .padding(.top, 15)
    }
    
    
    @ViewBuilder
    func SpotList() -> some View {
        ScrollView {
            
            ForEach(locations.reversed()) { location in
                HStack(spacing: 3) {
                    Image("Pin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    
                    Text(location.name)
                        .foregroundColor(.white)
                        .font(.callout)
                        .fontWeight(.thin)
                    
                    Spacer()
                    
                    Menu {
                    
                        Button(action: delete) {
                               Label("Delete", systemImage: "trash.circle.fill")
                           }

                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .frame(width: 45, height: 45)
                            .rotationEffect(Angle(degrees: 90))
                    }
                    
                }
                .padding(.horizontal, 10)
            }
            
        }
        
    }
    
    func delete() {
        
    }
    
    
}

struct SavesList_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesList(spot: Location.demo, locations: [Location.demo1, Location.demo2])
    }
}
