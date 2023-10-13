//
//  SecretSpotView.swift
//  CityXcape
//
//  Created by James Allan on 8/15/23.
//

import SwiftUI
import AsyncButton
import SDWebImageSwiftUI

struct LocationView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var spM: StreetPassViewModel


    let spot: Location
    
    var body: some View {
        
            ZStack {
                   MainImage()
                    .fullScreenCover(isPresented: $vm.showSignUp) {
                        SignUpView()
                    }
                    
                    if vm.showStamp {
                        StampView(spot: spot)
                            .padding(.bottom, 20)
                    }
                    
                    ZStack {
                        BlurView(style: .systemMaterialDark)
                        DrawerView()
                            .animation(.easeIn(duration: 0.3), value: vm.showCheckinList)
                    }
                    .cornerRadius(12)
                    .offset(y: vm.offset)
                   
                
                        

                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            let startLocation = value.startLocation
                            vm.offset = startLocation.y + value.translation.height
                        })
                )
                .onAppear {
                    vm.updateViewCount(id: spot.id)
                }
                .onDisappear {
                    vm.showStamp = false
                    vm.statuses[2] = false
                    vm.showCheckinList = false 
                }
        
        
    }
    
    @ViewBuilder
    func MainImage() -> some View {
        GeometryReader {
            let size = $0.size
            WebImage(url: URL(string: spot.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .overlay {
                 CustomLayer(size: size)
                }
                .sheet(isPresented: $vm.showBucketList) {
                    BucketList(locations: vm.saves)
                        .presentationDetents([.height(500)])
                }
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
            
                ButtonRow()
            
               
            CheckInButton()
            
            if vm.showDetails {
                VStack(alignment: .leading, spacing: 10) {
                    Text(spot.description)
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                        .opacity(vm.opacity)
                        .multilineTextAlignment(.leading)
                        .animation(.easeIn(duration: 0.5), value: vm.opacity)
                    
                    Text("Address: \(spot.address ?? "")")
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                        .opacity(vm.opacity)
                        .animation(.easeIn(duration: 0.5), value: vm.opacity)


                }
                .padding(20)
            }
            
            if vm.showCheckinList {
                withAnimation {
                    CheckinList(spot: spot, users: vm.users)
                   
                }
            }
                
                            
            
            Spacer()
        }

    }
    
    @ViewBuilder func TitleView() -> some View {
        HStack {
            Image("Pin")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            Text(spot.name)
                .font(.system(size: 32))
                .foregroundColor(.white)
                .fontWeight(.thin)
            
            Spacer()
            
            Button {
                vm.isCheckedIn ? vm.showCheckOutAlert() : dismiss()
            } label: {
                Image(systemName: "arrow.uturn.down.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }

        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func CustomLayer(size: CGSize) -> some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(.linearGradient(colors: [
                    .black.opacity(0.1),
                    .black.opacity(0.2),
                    .black], startPoint: .bottom, endPoint: .top))
                .frame(height: size.height)
            TitleView()
                .padding(.top, size.height / 18)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func ButtonRow() -> some View {
        HStack(alignment: .center) {
            
            Button {
                withAnimation(.easeIn(duration: 0.5)) {
                    vm.seeMoreInfo()
                }
            } label: {
                Image(systemName: "info.circle.fill")
                    .font(.title2)
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
                    .scaleEffect(vm.statuses[0] ? 0.9 : 1)

            }
            .alert(isPresented: $vm.showAlert) {
                vm.normalAlert ? Alert(title: Text(vm.alertMessage)) :
                Alert(title: Text(vm.alertMessage), primaryButton: .default(Text("Ok")) {
                    vm.showSignUp.toggle()
                }, secondaryButton: .cancel {
                    withAnimation {
                        vm.statuses[1] = false; vm.statuses[2] = false
                    }
                })
            }
            
         
            
            Button {
                vm.likeLocation(spot: spot)
            } label: {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(vm.statuses[1] ? .red : .white)
                    .particleEffect(
                        systemName: "person.2.fill",
                        font: .title2,
                        status: vm.statuses[1],
                        activeTint: .red,
                        inactiveTint: .pink)
                    .frame(width: 55, height: 55)
                    .background(vm.statuses[1] ? .red.opacity(0.25) : .pink.opacity(0.75))
                    .clipShape(Circle())
                    .scaleEffect(vm.statuses[1] ? 0.9 : 1)

            }
            
            Button {
                vm.saveToBookmark(spot: spot)
            } label: {
                Image(systemName: "bookmark.fill")
                    .font(.title2)
                    .foregroundColor(vm.statuses[2] ? .orange : .white)
                    .particleEffect(
                        systemName: "checkmark.seal.fill",
                        font: .title2,
                        status: vm.statuses[2],
                        activeTint: .orange,
                        inactiveTint: .yellow)
                    .frame(width: 55, height: 55)
                    .background(vm.statuses[2] ? .orange.opacity(0.25) : .yellow.opacity(0.8))
                    .clipShape(Circle())
                    .scaleEffect(vm.statuses[2] ? 0.9 : 1)

            }
            
        }
        .padding(.top, 5)
    }
    
    @ViewBuilder
    func CheckInButton() -> some View {
        Button {
            vm.isCheckedIn ? vm.checkOut() :
            vm.checkinLocation(spot: spot)
        } label: {
            Text(vm.isCheckedIn ? "Check Out": "CHECK IN")
                .font(.subheadline)
                .fontWeight(.thin)
                .foregroundColor(.white)
                .background(Capsule()
                    .fill(vm.showCheckinList ? .purple : .black)
                    .frame(width: 150, height: 40))
                .padding(.top, 25)
        }
    }
    
}

struct SecretSpotView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(spot: Location(data: Location.data))
            .environmentObject(LocationsViewModel())
    }
}
