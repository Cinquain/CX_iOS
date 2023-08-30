//
//  PostForm.swift
//  CityXcape
//
//  Created by James Allan on 8/30/23.
//

import SwiftUI
import MapKit
import PhotosUI

struct PostForm: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var vm: MapViewModel

    var body: some View {
        NavigationView {
            Form {
                TextField(vm.selectedMapItem?.name ?? "Location Name", text: $vm.spotName)
                TextField("Describe this location", text: $vm.spotDescription)
                    .frame(height: 40)
                TextField("#hashtag", text: $vm.hashtags)
                
                Section("\(Image(systemName: "photo")) Location Image (Portrait)") {
                    
                    PhotosPicker(selection: $vm.imageSelection, matching: .images) {
                            if let image = vm.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(12)
                                    .clipped()
                            } else {
                                Image("spot_image")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: .infinity)
                            }
                    }
                    .listRowInsets(EdgeInsets())
                    
                }
                
                Section("Address") {
                    locationView()
                }
                
                Section("Finish") {
                    finishButton()
                }
                
            }
            .navigationBarTitle("Create Location", displayMode: .inline)
            .navigationBarItems(trailing: closeButton)


        }
        .colorScheme(.dark)

    }
    
    @ViewBuilder
    func finishButton() -> some View {
        Button(action: {
            //
        }, label: {
                
            HStack {
                Spacer()
                Image("Pin")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                Text("Create Spot")
                    .font(.headline)
                Spacer()
            }
            .foregroundColor(.cx_blue)
        })

    }

    
    private var closeButton: some View {
        Button(action: {
                   dismiss()
               }, label: {
                   Image(systemName: "xmark.seal")
                       .resizable()
                       .scaledToFit()
                       .foregroundColor(.white)
                       .frame(height: 25)
               })
    }
    
    @ViewBuilder
    func locationView() -> some View {
        HStack {
                 Spacer()
                  Image(systemName: "location.fill")
                      .resizable()
                      .scaledToFit()
                      .frame(height: 20)
                  
            Text(vm.selectedMapItem?.getAddress() ?? "")
                      .multilineTextAlignment(.center)
                      .lineLimit(1)
                 Spacer()
              }
              .foregroundColor(.white)
    }
    
}

struct PostForm_Previews: PreviewProvider {
    static var previews: some View {
        PostForm(vm: MapViewModel())
            
    }
}
