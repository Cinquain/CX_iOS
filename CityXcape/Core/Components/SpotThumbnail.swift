//
//  SpotThumbnail.swift
//  CityXcape
//
//  Created by James Allan on 8/17/23.
//

import SwiftUI

struct SpotThumbnail: View {
    var body: some View {
        HStack {
            Image("Example")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack(spacing: 4) {
                    Image("Pin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                    
                    Text("Graffiti Pier")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                 
                    }
                
               
                    HStack {
                        Image("dot")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                        Text("5 Interested")
                            .font(.callout)
                            .foregroundColor(.white)
                        .fontWeight(.thin)
                        
                        Image(systemName: "figure.walk.circle.fill")
                            .foregroundColor(.white)
                        Text("3 miles")
                            .font(.callout)
                            .foregroundColor(.white)
                        .fontWeight(.thin)
                    }
                    
                                
            }
            .padding(.leading, 10)
            
            Spacer(minLength: 0)
        }
        .background(Color.black)
    }
}

struct SpotThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        SpotThumbnail()
            .previewLayout(.sizeThatFits)
    }
}
