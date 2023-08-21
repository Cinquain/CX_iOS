//
//  LocationsViewModel.swift
//  CityXcape
//
//  Created by James Allan on 8/21/23.
//

import Foundation
import Combine


class LocationsViewModel: ObservableObject {
    
    
    @Published var offset: CGFloat = 550
    @Published var showSignUp: Bool = false
    @Published var statuses: [Bool] = [false, false, false]
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    
    
}
