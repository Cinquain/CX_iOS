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
        Button {
            vm.showPicker.toggle()
        } label: {
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
        .fullScreenCover(isPresented: $vm.showPicker) {
            ImagePicker(imageSelected: $vm.spotImage, sourceType: $vm.sourceType)
                .colorScheme(.dark)
        }

           
    }
 
    @ViewBuilder
    func chart() -> some View {
        VStack {
            Text("Location Performance")
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
        
        Form {
            TextField("Change Title", text: $vm.editTitle)
      
            TextField("Add Description", text: $vm.editDetails)
            
            TextField("Edit Longitude", text: $vm.longitude)
               
            TextField("Edit Latitude", text: $vm.latitude)
            
            
            Section {
                finishButton()
            }
            
        }
        .colorScheme(.dark)

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
    
    @ViewBuilder
    func finishButton() -> some View {
        Button {
            vm.submitLocationChanges(spotId: spot.id)
        } label: {
            HStack(spacing: 2) {
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                Text("Done")
                    .font(.headline)
                Spacer()
            }
            .foregroundColor(.cx_blue)
        }

    }
    
}

struct SpotAnalytics_Previews: PreviewProvider {
    static var previews: some View {
        SpotAnalytics(spot: Location.demo, vm: StreetPassViewModel())
    }
}
