//
//  WavesView.swift
//  CityXcape
//
//  Created by James Allan on 9/18/23.
//

import SwiftUI

struct ConnectionView: View {
    
    @Binding var tabIndex: Int
    @GestureState private var dragState: DragState = .inactive
    var dragThreshold: CGFloat = 65.0
    @State private var offset: CGFloat = 0

    @StateObject var vm: WaveViewModel
    var body: some View {
        VStack {
            
            header()
                .opacity(dragState.isDragging ? 0.0 : 1)
                .animation(.default)

            Divider()
                .background(Color.orange)
                .frame(height: 0.5)
            
            Spacer()
                .frame(height: 30)
            
            ZStack {
                if !vm.messages.isEmpty {
                    ForEach(vm.messages) { message in
                        CardView(message: message)
                            .zIndex(1)
                            .overlay(LikeorDislike())
                            .offset(x: self.dragState.translation.width, y:  self.dragState.translation.height)
                            .scaleEffect(self.dragState.isDragging ? 0.85 : 1)
                            .rotationEffect(Angle(degrees:  Double(dragState.translation.width / 12)))
                            .animation(.interpolatingSpring(stiffness: 120, damping: 120))
                            .offset(x: offset)
                            .gesture(LongPressGesture(minimumDuration: 0.01)
                                .sequenced(before: DragGesture())
                                .updating(self.$dragState, body: { (value, state, transaction) in
                                    switch value {
                                    case .first(true):
                                        state = .pressing
                                    case .second(true, let drag):
                                        state = .dragging(translation: drag?.translation ?? .zero)
                                    default:
                                        break
                                    }
                                })
                                .onEnded({ (value) in
                                    guard case .second(true, let drag?) = value else {return}
                                    if drag.translation.width < -self.dragThreshold {
                                        //User is dismissed
                                        vm.deleteWave(id: message.id)
                                    }
                                    if drag.translation.width > self.dragThreshold {
                                        offset = 1000
                                        vm.match(message: message)
                                        DispatchQueue.main
                                            .asyncAfter(deadline: .now() + 5, execute: {
                                            withAnimation {
                                                tabIndex = 3
                                                vm.deleteWave(id: message.id)
                                            }
                                        })
                                    }
                                })
                            )
                    }
                       
                    if vm.showMatch {
                        MatchAnimation(matchUrl: vm.matchedUrl ?? "")
                    }
                    
                } else {
                    withAnimation(.easeOut(duration: 0.5)) {
                        emptyState()
                    }
                    
                }
                        
            }

            Spacer()
                
       
            
         
        }
        .background(AnimationView().edgesIgnoringSafeArea(.all))
    }
    
    
    @ViewBuilder
    func header() -> some View {
        HStack {
     
            Image("dot")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            
        
            Text("Pending Connection")
                .font(.title3)
                .fontWeight(.thin)
            
            Spacer()
        }
        .foregroundColor(.white.opacity(0.8))
        .padding(.horizontal)
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
    func LikeorDislike() -> some View {
        ZStack {
            VStack {
                Image(systemName: "x.circle")
                    .modifier(swipeModifier())
                    .foregroundColor(.red)
                   
                Text("Dismiss!")
                    .foregroundColor(.red)
                    .font(.title2)
                    .fontWeight(.medium)
                    
            }
            .opacity(dragState.translation.width <  -dragThreshold ? 1 : 0)
            
            
            VStack {
                Image(systemName: "heart.circle")
                    .modifier(swipeModifier())
                    .foregroundColor(.white)
               
                Text("Connect!")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            .opacity(dragState.translation.width >  dragThreshold ? 1 : 0.0)
        }
        
    }
    
    @ViewBuilder
    func emptyState() -> some View {
        VStack {
            Image("hive")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .opacity(0.7)
            
            Text("No Request Pending \n Check in a location to meet people")
                .font(.title3)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
            
            Button {
                tabIndex = 0
            } label: {
                Text("Find Location")
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                    .padding()
                    .background(.white)
                    .clipShape(Capsule())
            }

        }
        .foregroundColor(.white)
        .padding(.top, 40)
    }
    
    
    
    
}

struct WavesView_Previews: PreviewProvider {
    @State static var isSelected: Int = 0

    static var previews: some View {
        ConnectionView(tabIndex: $isSelected, vm: WaveViewModel())
    }
}
