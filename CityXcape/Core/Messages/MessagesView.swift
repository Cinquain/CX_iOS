//
//  MessagesView.swift
//  CityXcape
//
//  Created by James Allan on 9/5/23.
//

import SwiftUI

struct MessagesView: View {

    @EnvironmentObject var vm: MessageViewModel

    var body: some View {
        
        NavigationView {
            
            VStack {
                Header()
                
                Spacer()
                    .frame(height: 40)
                
                ScrollView {
                    ForEach(vm.recentMessages) { message in
                        NavigationLink {
                            ChatView(user: User(message: message), vm: vm)
                        } label: {
                            WavePreview(message: message)
                        }
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
        HStack(spacing: 2){
            Spacer()
            Image("dot")
                .resizable()
                .scaledToFit()
            .frame(height: 20)
            Text("Messages")
                .fontWeight(.thin)
            Spacer()
            Button {
                //Show connections view
            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.title3)
            }

         
        }
        .padding(.horizontal, 10)
    }
    

    

    

}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
            .environmentObject(MessageViewModel())
    }
}
