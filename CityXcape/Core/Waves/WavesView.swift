//
//  WavesView.swift
//  CityXcape
//
//  Created by James Allan on 9/18/23.
//

import SwiftUI

struct WavesView: View {
    
    @GestureState private var dragState: DragState = .inactive
    var dragThreshold: CGFloat = 65.0

    @StateObject var vm = WaveViewModel()
    var body: some View {
        VStack {
            header()
            Divider()
                .background(Color.orange)
                .frame(height: 0.5)
            
            Spacer()
                .frame(height: 30)
            
            ZStack {
                ForEach(vm.cardViews) { cardView in
                    cardView
                        .zIndex(vm.isTopCard(cardView: cardView) ? 1 : 0)
                        .overlay(LikeorDislike(cardView: cardView))
                }
            }

            Spacer()
                
       
            
         
        }
        .background(AnimationView().edgesIgnoringSafeArea(.all))
    }
    
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Image(systemName: "hands.sparkles.fill")
                .resizable()
                .foregroundColor(.orange)
                .scaledToFit()
                .frame(height: 30)
            
            Text("Waves Pending")
                .font(.title3)
                .foregroundColor(.orange)
                .fontWeight(.thin)
            Spacer()
        }.padding(.horizontal)
    }
    
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
           Image("network")
                .resizable()
                .scaledToFill()
                .rotationEffect(Angle(degrees: 90))
                .opacity(0.3)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func LikeorDislike(cardView: CardView) -> some View {
        ZStack {
            VStack {
                Image(systemName: "x.circle")
                    .modifier(swipeModifier())
                   
                Text("dismiss!")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.medium)
                    
            }
            .opacity(dragState.translation.width <  -dragThreshold && vm.isTopCard(cardView: cardView) ? 1 :0.0)
        
            
            VStack {
                Image(systemName: "heart.circle")
                    .modifier(swipeModifier())
               
                Text("Connected!")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            .opacity(dragState.translation.width >  dragThreshold && vm.isTopCard(cardView: cardView) ? 1 :0.0)

           
        }
        .opacity(0)
    }
}

struct WavesView_Previews: PreviewProvider {
    static var previews: some View {
        WavesView()
    }
}
