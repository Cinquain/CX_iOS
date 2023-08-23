//
//  SpotThumbnail.swift
//  CityXcape
//
//  Created by James Allan on 8/17/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SpotThumbnail: View {
    
    let spot: Location
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: spot.imageUrl))
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 10) {
                
                    
                    
                    Text(spot.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                 
                    
                
                    Text(spot.description)
                        .font(.caption)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .fontWeight(.thin)
                        .frame(width: 120, height: 10)
                    
                    HStack(alignment: .bottom, spacing: 3) {
                        Image("dot")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                        Text(getSaveText())
                            .font(.callout)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        
                        Spacer()
                        Image("Pin")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        Text(spot.distanceFromUser)
                            .font(.callout)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 5)
                                        
                                
            }
            .padding(.leading, 10)
            
        
            Spacer(minLength: 0)
            
          
        

        }
        .background(Color.black)
    }
    
    func getSaveText() -> String {
        return spot.saveCount > 1 ? "\(spot.saveCount) saves" : "\(spot.saveCount) save"
    }
}

struct SpotThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        SpotThumbnail(spot: Location(data: Location.data))
            .previewLayout(.sizeThatFits)
    }
}
