//
//  EditProfile.swift
//  CityXcape
//
//  Created by James Allan on 10/19/23.
//

import SwiftUI

struct EditProfile: View {
    @StateObject var vm: StreetPassViewModel
    @AppStorage(AppUserDefaults.username) var username: String?
    @AppStorage(AppUserDefaults.bio) var bio: String?
    @AppStorage(AppUserDefaults.age) var age: Int?

    
    var body: some View {
        Form {
            Section("Edit Your Street ID Card") {
            }
            TextField(username ?? "Create/Edit Username", text: $vm.username)
            
            TextField(bio ?? "Add Short Biography", text: $vm.bio)
                .alert(isPresented: $vm.showAlert) {
                    return Alert(title: Text(vm.alertMessage))
                }
            
            Section("Gender") {
                Toggle(vm.isMale ? "Male" : "Female", isOn: $vm.isMale)
            }
            
            Section("Status") {
                Toggle(vm.single ? "Single" : "Taken", isOn: $vm.single)
            }
            
            Section("Age") {
                TextField("\(age ?? 0)", text: $vm.age)
                    .keyboardType(.numberPad)
            }
            
            Section {
                Button {
                    vm.submitProfileChanges()
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "person.fill.checkmark")
                        Text("Done")
                        Spacer()
                    }
                    .foregroundColor(.cx_blue)
                }
                
            }
            
            
        }
        .colorScheme(.dark)
        
    }

}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile(vm: StreetPassViewModel())
    }
}
