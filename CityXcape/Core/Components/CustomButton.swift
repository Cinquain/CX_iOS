//
//  CustomButton.swift
//  CityXcape
//
//  Created by James Allan on 8/15/23.
//

import SwiftUI

struct CustomButton: View {
    
    let systemName: String
    @State var status: Bool
    var activeTint: Color
    let background: Color
    var onTap: () -> ()
    
    var body: some View {
        Button {
            //TBD
            status.toggle()
        } label: {
                Image(systemName: systemName)
                    .foregroundColor(status ? activeTint : .white)
                    .particleEffect(
                        systemName: systemName,
                        font: .title2,
                        status: status,
                        activeTint: activeTint,
                        inactiveTint: background)
                    .frame(width: 55, height: 55)
                    .background(status ? activeTint.opacity(0.25) : background)
                    .clipShape(Circle())
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(systemName: "location.circle.fill", status: false, activeTint: .red, background: .blue, onTap: {
            //Do nothing
            
        })
        .colorScheme(.dark)
    }
}
