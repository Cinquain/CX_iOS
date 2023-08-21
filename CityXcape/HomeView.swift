//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: LocationsViewModel
    
    @State private var showDetails: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .zIndex(0)
            
            GeometryReader { mainView in
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(1..<30) { num in
                            GeometryReader { item in
//                                SpotThumbnail(saves: num)
//                                    .scaleEffect(scaleValue(mainView.frame(in: .global).minY, item.frame(in: .global).minY), anchor: .bottom)
//                                    .opacity(Double(scaleValue(mainView.frame(in: .global).minY, item.frame(in: .global).minY)))
//                                    .onTapGesture {
//                                        showDetails.toggle()
//                                    }
                                    
                                
                            }
                            .frame(height: 100)
                            .fullScreenCover(isPresented: $showDetails) {
                                LocationView()
                            }
                           
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 25)
                }
                .zIndex(1)
            }
            
            
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func scaleValue(_ mainFrame: CGFloat, _ minY: CGFloat) -> CGFloat {
        withAnimation(.easeOut) {
            let scale = (minY - 25) / mainFrame
            print(scale, minY, mainFrame)
            if scale > 1 {
                return 1
            } else {
                return scale
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(spacing: 0) {
            HStack {
                    Image("Logo White")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                
                Spacer()
                
                Button {
                    //
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.title)
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .padding(.trailing, 10)
                }

            }
            
            Divider()
                .background(Color.white)
                .frame(height: 0.5)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
