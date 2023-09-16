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
                    ForEach(vm.recentMessages) { message in
                        NavigationLink {
                            ChatView(user: User(message: message), vm: vm)
                        } label: {
                            MessagePreview(message: message)
                        }
                    }
                }
                
                newMessageButton()

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
            Text("\(vm.recentMessages.count) Pending Connections")
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
    
    @ViewBuilder
    func newMessageButton() -> some View {
        
        HStack {
            Spacer()
            NavigationLink {
                ConnectionsView(vm: vm)
            } label: {
                
            Image(systemName: "message.fill")
                .frame(width: 60, height: 60)
                .font(.title2)
                .foregroundColor(.black)
                .background(.orange)
                .cornerRadius(42)
                .padding(.horizontal)

            }
        }


    }
    

}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
