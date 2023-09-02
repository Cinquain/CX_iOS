//
//  StampView.swift
//  CityXcape
//
//  Created by James Allan on 8/26/23.
//

import SwiftUI

struct StampView: View {
    let spot: Location
    let day = Date.formattedDate(Date())
    let hour = Date.timeFormatter(Date())
    
    @State private var animate: Bool = true
    
    var body: some View {
        Image("Stamp")
            .resizable()
            .scaledToFit()
            .frame(width: 325)
            .overlay(timeStamp())
            .rotationEffect(animate ? Angle(degrees: 0) : Angle(degrees: -35))
            .scaleEffect(animate ? 4 : 1)
            .animation(.easeIn(duration: 0.25), value: animate)
            .animation(.spring(), value: animate)
            .onAppear {
                SoundManager.shared.playStamp()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    animate = false
                })
            }
    }
    
    @ViewBuilder
    func timeStamp() -> some View {
        VStack(alignment: .center, spacing: 0) {
            Text(spot.name)
                .font(.caption)
                .fontWeight(.medium)
            
            Text(day())
                .font(.title2)
                .fontWeight(.medium)
            
            Text(hour())
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(Color("Stamp_Red"))
        .rotationEffect(Angle(degrees: -32))

    }
    
}

struct StampView_Previews: PreviewProvider {
    static var previews: some View {
        StampView(spot: Location.demo)
    }
}
