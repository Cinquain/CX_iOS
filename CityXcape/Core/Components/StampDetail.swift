//
//  StampDetail.swift
//  CityXcape
//
//  Created by James Allan on 10/5/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct StampDetail: View {
    @State var stamp: Stamp
    @State var showPicker: Bool = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary
    @State var imageUrl: String
    @State var stampImage: UIImage?
    
    @State var errorMessage: String = ""
    @State var showError: Bool = false

    var body: some View {
        VStack {
            postalStamp()
            title()
            passportSeal()
        }
        .background(background())
    }
    
    @ViewBuilder
    func postalStamp() -> some View {
        HStack {
            Button {
                showPicker.toggle()
            } label: {
                ZStack {
                    Image("postmark")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .offset(x: 120, y: -22)
                    
                    Image("postal")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(height: 200)
                        .overlay(
                            WebImage(url: URL(string: imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 180, maxHeight: 180)
                                .clipped()
                    )
                }
            }
            .sheet(isPresented: $showPicker, onDismiss: {
                setStampImage()
            }) {
                ImagePicker(imageSelected: $stampImage, sourceType: $source)
                    .colorScheme(.dark)
            }


            Spacer()
        }
        .padding(.horizontal,20)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func title() -> some View {
        HStack(spacing: 3) {
            Image("Pin")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
                .alert(isPresented: $showError) {
                    return Alert(title: Text(errorMessage))
                }
            
            Text(stamp.spotName)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal, 20)
      
    }
    
    @ViewBuilder
    func passportSeal() -> some View {
        HStack {
            Spacer()
            PassPortStamp(stamp: stamp)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("America")
                .resizable()
                .scaledToFill()
                .opacity(0.6)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func setStampImage() {
        print("Setting stamp image")

        guard let image = stampImage else {return}
        Task {
            do {
                let url = try await DataService.shared.updateStampImage(image: image, stampId: stamp.id)
                self.imageUrl = url
                } catch {
                    print("error upload stamp image", error.localizedDescription)
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
        
    }
}

struct StampDetail_Previews: PreviewProvider {
    static var previews: some View {
        StampDetail(stamp: Stamp.demo, imageUrl: "")
    }
}
