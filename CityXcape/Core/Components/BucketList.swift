//
//  BucketList.swift
//  CityXcape
//
//  Created by James Allan on 10/2/23.
//

import SwiftUI

struct BucketList: View {
    @State var saves: [Save]
    
    @State var errorMessage: String = ""
    @State var showAlert: Bool = false
    var body: some View {
        VStack {
            header()
        
            spotList()
            Spacer()
        }
        .background(.black)
    }
    
    @ViewBuilder
    func header() -> some View {
        VStack {
            HStack {
                Image("Pin")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                Text("\(saves.count) Spots to Visit")
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
                
            Image("Compass")
                .resizable()
                .scaledToFit()
                .rotationEffect(Angle(degrees: 45))
                .opacity(0.1)
                .padding(.bottom, 60)
            
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func spotList() -> some View {
            ForEach(saves) { spot in
                HStack {
                    PinView(height: 40, url: spot.imageUrl)
                    Text(spot.name)
                        .fontWeight(.thin)
                        .foregroundColor(.white)
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
                Divider()
               
            }
           
    }
    
    fileprivate func delete(spot: Save) {
        Task {
            do {
                try await DataService.shared.unsaveLocation(spotId: spot.id)
                if let index = saves.firstIndex(where: {$0.id == spot.id}) {
                    saves.remove(at: index)
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
        BucketList(saves: [])
    }
}
