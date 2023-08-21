//
//  SecretSpotView.swift
//  CityXcape
//
//  Created by James Allan on 8/15/23.
//

import SwiftUI

struct LocationView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        
            ZStack {
               MainImage()
                    .fullScreenCover(isPresented: $vm.showSignUp) {
                        SignUpView()
                    }
      
                ZStack {
                    BlurView(style: .systemMaterialDark)
                    DrawerView()
                }
                .offset(y: vm.offset)

            }
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let startLocation = value.startLocation
                        vm.offset = startLocation.y + value.translation.height
                    })
            )
            
      
        
    }
    
    @ViewBuilder
    func MainImage() -> some View {
        GeometryReader {
            let size = $0.size
            Image("Example")
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func DrawerView() -> some View {
        VStack {
            Capsule()
                .frame(width: 100, height: 7)
                .foregroundColor(.white)
                .padding(.top, 7)
            
            HStack(alignment: .center) {
                
                Button {
                    vm.statuses[0].toggle()
                    if AuthService.shared.uid == nil {vm.showAlert.toggle()}
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(vm.statuses[0] ? .purple : .white)
                        .particleEffect(
                            systemName: "plus.circle.fill",
                            font: .title2,
                            status: vm.statuses[0],
                            activeTint: .purple,
                            inactiveTint: .blue)
                        .frame(width: 55, height: 55)
                        .background(vm.statuses[0] ? .purple.opacity(0.25) : .blue)
                        .clipShape(Circle())
                }
                .alert(isPresented: $vm.showAlert) {
                    Alert(title: Text("You need an account to add location to your List"), primaryButton: .default(Text("Ok")) {
                        vm.showSignUp.toggle()
                    }, secondaryButton: .cancel())
                }
                
                Button {
                    vm.statuses[1].toggle()
                } label: {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(vm.statuses[1] ? .red : .white)
                        .particleEffect(
                            systemName: "checkmark.seal.fill",
                            font: .title2,
                            status: vm.statuses[1],
                            activeTint: .red,
                            inactiveTint: .green)
                        .frame(width: 55, height: 55)
                        .background(vm.statuses[1] ? .red.opacity(0.25) : .green.opacity(0.8))
                        .clipShape(Circle())
                }
                
                Button {
                    vm.statuses[2].toggle()
                } label: {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(vm.statuses[2] ? .orange : .white)
                        .particleEffect(
                            systemName: "person.2.fill",
                            font: .title2,
                            status: vm.statuses[2],
                            activeTint: .orange,
                            inactiveTint: .yellow)
                        .frame(width: 55, height: 55)
                        .background(vm.statuses[2] ? .orange.opacity(0.25) : .yellow.opacity(0.8))
                        .clipShape(Circle())
                }
                
            }
            .padding(.top, 5)
            
            Button {
                dismiss()
            } label: {
                Text("DISMISS")
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .background(Capsule().fill(.black).frame(width: 100, height: 35))
                    .padding(.top, 100)
            }
            

            
            
            Spacer()
        }
    }
    
}

struct SecretSpotView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
            .environmentObject(LocationsViewModel())
    }
}
