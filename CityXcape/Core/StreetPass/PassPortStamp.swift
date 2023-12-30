//
//  PassPortStamp.swift
//  CityXcape
//
//  Created by James Allan on 10/5/23.
//

import SwiftUI

struct PassPortStamp: View {
    
    let stamp: Stamp
    @State private var animate: Bool = true
    let random: Color = Color.stamp
    var body: some View {
        Image("Stamp")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundColor(random)
            .frame(width: 220)
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
            
            Text(stamp.timestamp.formattedDate())
                .font(.callout)
                .fontWeight(.medium)
            
            Text(stamp.timestamp.timeFormatter())
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(random)
        .rotationEffect(Angle(degrees: -32))

    }
}


struct PassPortStamp_Previews: PreviewProvider {
    static var previews: some View {
        PassPortStamp(stamp: Stamp.demo)
    }
}
