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
            TextField(username ?? "Edit Username", text: $vm.username)
            
            TextField(bio ?? "Add Short Bio", text: $vm.bio)
                .alert(isPresented: $vm.showError) {
                    return Alert(title: Text(vm.errorMessage))
                }
            
            Section("Gender") {
                Toggle(vm.isMale ? "Male" : "Female", isOn: $vm.isMale)
            }
            
            Section("Status") {
                Toggle(vm.single ? "Single" : "Taken", isOn: $vm.single)
            }
            
            Section("Age") {
                Stepper("\(vm.age)", value: $vm.age)
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
