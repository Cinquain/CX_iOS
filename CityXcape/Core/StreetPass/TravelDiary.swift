//
//  TravelDiary.swift
//  CityXcape
//
//  Created by James Allan on 10/4/23.
//

import SwiftUI

struct TravelDiary: View {
    @Environment(\.dismiss) private var dismiss

    @State var stamps: [Stamp]
    @State var currentStamp: Stamp?
    @State var showstamp: Bool = false
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 180))
    ]
    var body: some View {
        VStack {
            header()
            Spacer()
                .frame(height: 40)
            scrollView()

        }
        .background(background())
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Image(systemName: "airplane.departure")
                .font(.title)
                .foregroundColor(.black)
            VStack(alignment: .leading) {
                Text("My Journey")
                    .font(.title)
                .fontWeight(.thin)
                Text("\(stamps.count) Locations")
                    .fontWeight(.thin)
                    .font(.caption)
            }
            .foregroundColor(.black)
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.square.fill")
                    .foregroundColor(.black)
                    .font(.title2)
            }

        }
        .padding(.horizontal, 20)
    }
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.vintage
            Image("Compass")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .opacity(0.1)
                
        }
        .edgesIgnoringSafeArea(.all)
    }
    @ViewBuilder
    func scrollView() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(stamps) { stamp in
                    Button {
                        currentStamp = stamp
                    } label: {
                        stampView(stamp: stamp)
                    }
                    .sheet(item: $currentStamp) { stamp in
                        StampDetail(stamp: stamp)
                            .presentationDetents([.medium])
                    }

                }
            }
        }
    }
    
    @ViewBuilder
    func stampView(stamp: Stamp) -> some View {
        VStack {
            StampThumbnail(stamp: stamp, width: 120)
            HStack(spacing: 2) {
                Image("pin_feed")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .frame(height: 15)
                Text(stamp.spotName)
                    .foregroundColor(.black)
                    .fontWeight(.thin)
                    .font(.caption)
            }
            .frame(width: 180)
        }
    }
    
}

struct TravelDiary_Previews: PreviewProvider {
    static var previews: some View {
        TravelDiary(stamps: [Stamp.demo, Stamp.demo2, Stamp.demo3, Stamp.demo4])
    }
}
