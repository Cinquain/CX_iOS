//
//  BlurView.swift
//  CityXcape
//
//  Created by James Allan on 8/15/23.
//

import Foundation
import SwiftUI


struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        //No updating methods required
    }
    
}
