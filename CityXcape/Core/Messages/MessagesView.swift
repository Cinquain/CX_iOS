//
//  MessagesView.swift
//  CityXcape
//
//  Created by James Allan on 9/5/23.
//

import SwiftUI

struct MessagesView: View {
    
    @StateObject var vm = MessageViewModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Header()
                
                Spacer()
                    .frame(height: 40)
                
                ScrollView {
                    ForEach(vm.connections) {
                        MessagePreview(user: $0)
                    }
                }
            }
            .navigationBarHidden(true)
            
        }
        .colorScheme(.dark)
        //End of some view
    }
    
    @ViewBuilder
    func Header() -> some View {
        HStack{
            Spacer()
            Image("dot")
                .resizable()
                .scaledToFit()
            .frame(height: 20)
            Text("\(vm.connections.count) Connections")
                .fontWeight(.thin)
            Spacer()
            Button {
                //New Message Box
            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.title2)
            }
        }
        .padding(.horizontal, 10)
    }
    

}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
