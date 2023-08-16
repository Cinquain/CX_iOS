//
//  Extensions.swift
//  CityXcape
//
//  Created by James Allan on 8/9/23.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct Server {
    
    static let users = "users"
    static let worlds = "worlds"
    static let spots = "spots"
    static let stamps = "stamps"
    
}

extension View {
    
    func particleEffect(systemName: String, font: Font, status: Bool, activeTint: Color, inactiveTint: Color) -> some View {
        self
            .modifier(
                ParticleModifier(systemName: systemName, font: font, status: status, activeTint: activeTint, inactiveTint: inactiveTint)
            )
        
    }
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


fileprivate struct ParticleModifier: ViewModifier {
    var systemName: String
    var font: Font
    var status: Bool
    var activeTint: Color
    var inactiveTint: Color
    
    @State private var particles: [Particle] = []
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                ZStack {
                    ForEach(particles) { particle in
                        Image(systemName: systemName)
                            .foregroundColor(status ? activeTint : inactiveTint)
                            .scaleEffect(particle.scale)
                            .offset(x: particle.randomX, y: particle.randomY)
                            .opacity(particle.opacity)
                            .opacity(status ? 1 : 0)
                            .animation(.none, value: status)
                        
                    }
                }
                .onAppear {
                    if particles.isEmpty {
                        for _ in 0...15 {
                            let particle = Particle()
                            particles.append(particle)
                        }
                    }
                }
                .onChange(of: status) { newValue in
                    if !newValue {
                        for index in particles.indices {
                            particles[index].reset()
                        }
                    } else {
                        for index in particles.indices {
                            
                            let total: CGFloat = CGFloat(particles.count)
                            let progress: CGFloat = CGFloat(index) / total
                            
                            let maxX: CGFloat = (progress > 0.5) ? 100 : -100
                            let maxY: CGFloat = 80
                            
                            let randomX: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxX)
                            let randomY: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxY) + 35
                            let randomScale: CGFloat = .random(in: 0.35...1)
                            
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                
                                let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0...10) : .random(in: -10...0))
                                let extraRandomY: CGFloat = .random(in: 0...30)
                                
                                particles[index].randomX = randomX + extraRandomX
                                particles[index].randomY = -randomY + extraRandomY
                                particles[index].scale = randomScale
                            }
                            
                            withAnimation(.easeInOut(duration: 0.3)) {
                                particles[index].scale = randomScale
                            }
                            
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.25 + Double(index) * 0.005)) {
                                particles[index].scale = 0.001
                            }

                        }
                    }
                }
                
            }
    }
}