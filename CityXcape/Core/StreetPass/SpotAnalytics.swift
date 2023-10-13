//
//  SpotAnalytics.swift
//  CityXcape
//
//  Created by James Allan on 10/12/23.
//

import SwiftUI
import Charts
import PhotosUI
import SDWebImageSwiftUI

struct SpotAnalytics: View {
    @Environment(\.dismiss) private var dismiss

    let spot: Location
    @StateObject var vm: StreetPassViewModel
    
    @State var data: [(name: String, value: Int)] = []
    @State var title: String = ""
    var body: some View {
        VStack {
            header()
            
            imageThumb()
            
            Picker("Metrics", selection: $vm.spotMetric) {
                ForEach(SpotMetric.allCases) { category in
                    Text(category.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .colorScheme(.dark)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            
            switch vm.spotMetric {
            case .Metrics:
                chart()
            case .Modify:
                editLocation()
            }
            
            Spacer()
        }
        .background(.black)
        .onAppear {
            createData()
        }
        
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Image("Pin")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            Text(spot.name)
                .font(.title2)
                .foregroundColor(.white)
                .fontWeight(.thin)
                .alert(isPresented: $vm.showError) {
                    return Alert(title: Text(vm.errorMessage))
                }
            
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.square.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }
    @ViewBuilder
    func imageThumb() -> some View {
            PhotosPicker(selection: $vm.imageSelection, matching: .images) {
                ZStack {
                    if let image = vm.spotImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(12)
                            .clipped()
                        
                    } else {
                        WebImage(url: URL(string: spot.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: .infinity)
                            .frame(maxHeight: 300)
                            .clipped()
                    }
                    ProgressView()
                        .opacity(vm.isUploading ? 1 : 0)
                        .scaleEffect(3)
                }
               
            }
           
    }
 
    @ViewBuilder
    func chart() -> some View {
        VStack {
            Text("Location Analytics")
                .font(.caption)
                .fontWeight(.thin)
                .foregroundColor(.white)
            
            Chart(data, id: \.name) {
                BarMark(
                    x: .value("KPI", $0.name),
                    y: .value("Total", $0.value))
                .foregroundStyle(by: .value("Total", $0.name))
            }
            .frame(height: 300)
        .colorScheme(.dark)
        }
    }
    @ViewBuilder
    func editLocation() -> some View {
        VStack(spacing: 0) {
            TextField(vm.editTitle, text: $vm.editTitle, onCommit: {
                vm.changeTitle(id: spot.id)
            })
                .padding()
                .foregroundColor(.white)
                .placeholder(when: vm.editTitle.isEmpty) {
                    Text("Change Name \( Image(systemName: "pencil"))")
                        .foregroundColor(.gray)
                        .fontWeight(.thin)
                        .padding(.horizontal, 20)
                }
                .background(.black)
            
            TextField(vm.editDetails, text: $vm.editDetails, onCommit: {
                vm.changeDetails(id: spot.id)
            })
                .padding()
                .foregroundColor(.white)
                .placeholder(when: vm.editDetails.isEmpty) {
                    Text("Add Description \( Image(systemName: "pencil"))")
                        .fontWeight(.thin)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .lineLimit(1)
                        
                }
                .background(.black)
            
            HStack(spacing: 0) {
                
                TextField(vm.longitude, text: $vm.longitude, onCommit: {
                    vm.changeLong(id: spot.id)
                })
                    .padding()
                    .foregroundColor(.white)
                    .placeholder(when: vm.longitude.isEmpty) {
                        Text("Longitude \( Image(systemName: "pencil"))")
                            .fontWeight(.thin)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .lineLimit(1)
                            
                    }
                    .background(.black)
                
                TextField(vm.latitude, text: $vm.latitude, onCommit: {
                    vm.changeLat(id: spot.id)
                })
                    .padding()
                    .foregroundColor(.white)
                    .placeholder(when: vm.latitude.isEmpty) {
                        Text("Latitude \( Image(systemName: "pencil"))")
                            .fontWeight(.thin)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .lineLimit(1)
                            
                    }
                    .background(.black)
                
            }
            .padding(.bottom, 10)
   

            
            
        }

    }
    
    fileprivate func createData() {
        let likes = (name: "Likes", value: Int(spot.likeCount))
        let saves = (name: "Saves", value: Int(spot.saveCount))
        let checkins = (name: "Checkins", value: Int(spot.checkinCount))
        let views = (name: "Views", value: Int(spot.viewCount))
        data.append(views)
        data.append(likes)
        data.append(saves)
        data.append(checkins)
    }
    
}

struct SpotAnalytics_Previews: PreviewProvider {
    static var previews: some View {
        SpotAnalytics(spot: Location.demo, vm: StreetPassViewModel())
    }
}
