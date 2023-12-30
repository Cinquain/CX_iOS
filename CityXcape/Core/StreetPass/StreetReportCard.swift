//
//  StreetReportCard.swift
//  CityXcape
//
//  Created by James Allan on 10/7/23.
//

import SwiftUI
import Charts

struct StreetReportCard: View {
    @StateObject var vm: StreetPassViewModel
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        VStack {
            header()
            Spacer()
                .frame(height: 40)
            Chart(vm.data, id: \.name) {
                BarMark(
                    x: .value("Impact", $0.name),
                    y: .value("Total", $0.count))
            

            }
            .frame(height: 300)
            .foregroundColor(.blue)
            .colorScheme(.dark)
            
          
            
            Text("Total Performance")
                .font(.caption)
                .foregroundColor(.white)
                .fontWeight(.thin)
                .padding(.bottom, 20)
            
            Text("Your Locations")
                .foregroundColor(.white)
                .font(.title2)
                .fontWeight(.thin)
            
            viewCount()
            
            Spacer()
        }
        .background(.black)
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Text("Your Street Report Card")
                .font(.title2)
                .foregroundColor(.white)
                .fontWeight(.thin)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.square.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func viewCount() -> some View {
        
        ScrollView {
            ForEach(vm.uploads.sorted(by: {$0.viewCount > $1.viewCount})) { spot in
                Button(action: {
                    vm.spotId = spot.id
                    vm.spotImageUrl = spot.imageUrl
                    vm.currentSpot = spot
                }, label: {
                    HStack {
                        PinView(height: 40, url: spot.imageUrl)
                        Text(spot.name)
                            .fontWeight(.thin)
                            .foregroundColor(.white)
                        Spacer()
                        
                        Text("\(spot.viewCount) views")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                })
                .padding(.horizontal, 20)
                .fullScreenCover(item: $vm.currentSpot) { spot in
                    SpotAnalytics(spot: spot)
                }
                
                Divider()
                    .foregroundColor(.white)
                    .frame(height: 0.5)
               
            }
        }
    }
    
    @ViewBuilder
    func likeCount() -> some View {
        ForEach(vm.uploads.sorted(by: {$0.likeCount > $1.likeCount})) { spot in
            Button(action: {
                vm.spotId = spot.id
                vm.currentSpot = spot
            }, label: {
                HStack {
                    PinView(height: 40, url: spot.imageUrl)
                    Text(spot.name)
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                    Spacer()
                    
                    Text("\(spot.likeCount) likes")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .fontWeight(.thin)
                }
            })
            .padding(.horizontal, 20)
            
            Divider()
                .foregroundColor(.white)
                .frame(height: 0.5)
           
        }
    }
    
    @ViewBuilder
    func stampCount() -> some View {
        ForEach(vm.uploads.sorted(by: {$0.checkinCount > $1.checkinCount})) { spot in
            Button(action: {
                vm.spotId = spot.id
                vm.currentSpot = spot
            }, label: {
                HStack {
                    PinView(height: 40, url: spot.imageUrl)
                    Text(spot.name)
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                    Spacer()
                    
                    Text("\(spot.checkinCount) check ins")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .fontWeight(.thin)
                }
            })
            .padding(.horizontal, 20)
            
            Divider()
                .foregroundColor(.white)
                .frame(height: 0.5)
           
        }
    }
}

struct StreetReportCard_Previews: PreviewProvider {
    static var previews: some View {
        StreetReportCard(vm: StreetPassViewModel())
    }
}
