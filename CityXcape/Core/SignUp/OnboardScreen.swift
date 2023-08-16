//
//  OnboardScreen.swift
//  CityXcape
//
//  Created by James Allan on 8/15/23.
//

import SwiftUI

struct OnboardScreen: View {
    var body: some View {
        
            TabView {
              OnboardI()
            }
            .background(Color.black)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        
    }
}

struct OnboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardScreen()
    }
}
