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
                
                    
                    
                HStack {
                    Text(spot.name)
                            .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    
                }
                 
                    
                
               
                    
                    HStack(alignment: .center, spacing: 3) {
                        Image("dot")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                            .overlay {
                                Image(systemName: "person.2.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 8)
                                    .foregroundColor(.black)
                            }
                        
                        Text(getCheckinText())
                            .font(.callout)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        
                        Spacer()
                        Text(spot.distanceFromUser)
                            .font(.callout)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        
                        
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                                        
                                
            }
            .padding(.leading, 10)
            
        
            Spacer(minLength: 0)
            
          
        

        }
        .background(Color.black)
    }
    
    func getCheckinText() -> String {
        if spot.checkinCount > 1{
            return "\(spot.checkinCount) inside"
        } else {
            return "\(spot.checkinCount) inside"
        }
    }
}

struct SpotThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        SpotThumbnail(spot: Location(data: Location.data))
            .previewLayout(.sizeThatFits)
    }
}
