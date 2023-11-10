//
//  StreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/29/23.
//

import SwiftUI
import PhotosUI

struct StreetPass: View {
    
    @AppStorage(AppUserDefaults.username) var username: String?
    @AppStorage(AppUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(AppUserDefaults.streetcred) var streetcred: Int?

    @EnvironmentObject private var vm: StreetPassViewModel

    
    var body: some View {
        
            VStack {
                StreetPassHeader()
                UserDot()
                Spacer()
                    .frame(height: 70)
                MyJourney()
                 
                Spacer()
            }
            .background(Background())
        
    }
    
    
    @ViewBuilder
    func Background() -> some View {
        ZStack {
            Color.black
            Image("street-paths")
                .resizable()
                .scaledToFill()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func StreetPassHeader() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("STREETPASS")
                    .font(.system(size: 24))
                    .fontWeight(.thin)
                    .tracking(4)
                    .opacity(0.7)
                Text("STC Balance: \(streetcred ?? 0)")
                    .font(.caption)
                    .fontWeight(.thin)
                    .opacity(0.7)
                    .sheet(isPresented: $vm.editSP) {
                        EditProfile(vm: vm)
                    }

            }
            .foregroundColor(.white)

            Spacer()
            Menu {
                Button(action: vm.editStreetPass) {
                       Label("Edit StreetPass", systemImage: "pencil.circle")
                   }
                //Sign out user
                Button(action: vm.signOut) {
                       Label("Signout", systemImage: "point.filled.topleft.down.curvedto.point.bottomright.up")
                   }
                
                Button(action: vm.deleteAccount) {
                       Label("Delete Account", systemImage: "power.circle")
                   }
             
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.5))
            }

        }
        .padding(.horizontal, 25)
    }
    
    @ViewBuilder
    func UserDot() -> some View {
        
        PhotosPicker(selection: $vm.selectedItem, matching: .images) {
            VStack(spacing: 3) {
                BubbleView(width: 300, imageUrl: profileUrl ?? "", type: .personal)
                
                Text(username ?? "Create Username")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                  
            }
            .padding(.top, 20)
        }
        
    }
    
    @ViewBuilder
    func MyJourney() -> some View {
  
        VStack(alignment: .leading, spacing: 20) {
            Button {
                vm.fetchBucketList()
            } label: {
                HStack {
                    Image(systemName: "list.bullet.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Bucket List")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .popover(isPresented: $vm.showBucketList) {
                            BucketList(locations: vm.bucketList)
                                .presentationDetents([.medium])
                        }
                        .presentationDetents([.medium])

                }
            }
            
            Button {
                vm.fetchStamps()
            } label: {
                HStack {
                    Image(systemName: "book.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    Text("Travel Diary")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                }
                .fullScreenCover(isPresented: $vm.showDiary) {
                    TravelDiary(stamps: vm.stamps)
                }
                
            }
            
            
            Button {
                vm.fetchUploads()
            } label: {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Analytics")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                }
            }
            .fullScreenCover(isPresented: $vm.showStreetRep) {
                StreetReportCard(vm: vm)
            }
            
          

            
        }
        
    }
    

    
    
}

struct StreetPass_Previews: PreviewProvider {
    static var previews: some View {
        StreetPass()
            .environmentObject(StreetPassViewModel())
    }
}
