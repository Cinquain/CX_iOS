//
//  BuyWavesView.swift
//  CityXcape
//
//  Created by James Allan on 9/2/23.
//

import SwiftUI

struct BuyWavesView: View {
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
            
            VStack {
                Headline()
                    .padding(.top, 25)

                VStack(spacing: 12) {
                    
                    Button {
                        //Make Purchase
                    } label: {
                        WaveCapsule(count: 3, price: 9.99)
                    }
                    
                    Button {
                        //Make Purchase
                    } label: {
                        WaveCapsule(count: 12, price: 29.99)
                    }
                    
                    Button {
                        //Make Purchase
                    } label: {
                        WaveCapsule(count: 50, price: 74.99)
                    }
                    
                    Spacer()
                    
                }
                .padding(.bottom, 40)
                
                
            }
            .cornerRadius(24)
            .background(Background())
            .edgesIgnoringSafeArea(.bottom)
           
        


    }
    
    @ViewBuilder
    func WaveCapsule(count: Int, price: Double) -> some View {
        let rounded = String(format: "%.2f", price)
        HStack {
            Text("\(count) Waves \(Image(systemName: "hands.sparkles.fill")) $\(rounded)")
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(width: 275, height: 50)
                .background(.orange.opacity(0.6))
                .clipShape(Capsule())

        }
        .padding(10)
        .background(.black.opacity(0.6))
    }
    
    @ViewBuilder
    func Background() -> some View {
        GeometryReader {
            let size = $0.size
            Image("network")
                .resizable()
                .scaledToFill()
                .overlay(Color.black.opacity(0.65))
                .frame(width: size.width, height: size.height)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    @ViewBuilder
    func Headline() -> some View {
        VStack(spacing: 5) {
            Button {
                dismiss()
            } label: {
                Image("cx-logo")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.8)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }

            
            HStack {
                Spacer()
                VStack {
                    Text("Connect by waving")
                        .font(Font.custom("times new roman", size: 30))
                        .fontWeight(.semibold)
                    .opacity(0.8)
                    Text("You ran out of waves. Please get more.")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .font(.caption)
                }
                Spacer()
            }
          
        }
        .padding(.top, 25)
        .foregroundColor(.white)
    }
}

struct BuyWavesView_Previews: PreviewProvider {
    static var previews: some View {
        BuyWavesView()
    }
}
