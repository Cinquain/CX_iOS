//
//  CongratsView.swift
//  CityXcape
//
//  Created by James Allan on 9/4/23.
//

import SwiftUI

struct CongratsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: MapViewModel
    @State var angle: Double = 0
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 100)
            Image("StreetCred")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .rotationEffect(Angle(degrees: angle))
                .animation(.easeOut(duration: 1.5), value: angle)
            
            Text("You Earned 1 StreetCred")
                .font(.title2)
                .fontWeight(.thin)
                .foregroundColor(.white)
            HStack{Spacer()}
            Spacer()
        }
        .background(Background())
        .onAppear {
            angle = 360
        }
    }
    
    
    @ViewBuilder
    func Background() -> some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                Color.black
                Image("black-paths")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width, height: size.height)
            }
            .edgesIgnoringSafeArea(.all)
        }
     
    }
}

struct CongratsView_Previews: PreviewProvider {
    static var previews: some View {
        CongratsView(vm: MapViewModel())
    }
}
