//
//  Extensions.swift
//  CityXcape
//
//  Created by James Allan on 8/9/23.
//

import Foundation
import SwiftUI
import AuthenticationServices
import MapKit
import CoreLocation



extension View {
    
    func particleEffect(systemName: String, font: Font, status: Bool, activeTint: Color, inactiveTint: Color) -> some View {
        self
            .modifier(
                ParticleModifier(systemName: systemName, font: font, status: status, activeTint: activeTint, inactiveTint: inactiveTint)
            )
        
    }
    
    func glow(color: Color, radius: CGFloat) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }    
    func hideKeyboard() {
             let resign = #selector(UIResponder.resignFirstResponder)
             UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
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

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension MKMapItem {
    func getAddress() -> String {
            
            let placemark = self.placemark
            var addressString : String = ""
            
            if placemark.subThoroughfare != nil {
                addressString = addressString + placemark.subThoroughfare! + " "
            }
            
            if placemark.thoroughfare != nil {
                addressString = addressString + placemark.thoroughfare! + ", "
           }
            if placemark.locality != nil {
                addressString = addressString + placemark.locality! + ", "
           }
         
            if placemark.postalCode != nil {
                addressString = addressString + placemark.postalCode! + " "
           }
            if addressString == "" {
                return "Long: \(String(format: "%.4f", self.placemark.coordinate.longitude)), Lat:\(String(format: "%.4f", self.placemark.coordinate.latitude))"
            } else {
                return addressString
            }
            
        }
        
        func getCity() -> String {
            let placemark = self.placemark
            var city: String = ""
            
            if placemark.locality != nil {
                city = placemark.locality!
            }
            return city
        }
        
}

extension CLLocationCoordinate2D {
    func getCity() -> String? {
        var city: String?
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemark, error in
            if let error = error {
                print("Error reverse geocoding location", error.localizedDescription)
                return
            }
            
          city = placemark?.first?.locality
        }
        return city
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
          self = self.capitalizingFirstLetter()
      }
    
    func isValidEmail() -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           
           let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: self)
       }
       
}

extension Date {
    func formattedDate() -> String {
           
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMM dd, yyyy"
           let date = dateFormatter.string(from: self)
           return date
       }
    
    func stringDescription() -> String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
            let date = dateFormatter.string(from: self)
            return date
        }
    
    func ribbonFormat() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            let date = dateFormatter.string(from: self)
            return date
        }
    
    func timeFormatter() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let date = dateFormatter.string(from: self)
            return date
        }
    
    func timeAgo() -> String {

            let secondsAgo = Int(Date().timeIntervalSince(self))

            let minute = 60
            let hour = 60 * minute
            let day = 24 * hour
            let week = 7 * day
            let month = 4 * week

            let quotient: Int
            let unit: String
            if secondsAgo < minute {
                quotient = secondsAgo
                unit = "second"
            } else if secondsAgo < hour {
                quotient = secondsAgo / minute
                unit = "min"
            } else if secondsAgo < day {
                quotient = secondsAgo / hour
                unit = "hour"
            } else if secondsAgo < week {
                quotient = secondsAgo / day
                unit = "day"
            } else if secondsAgo < month {
                quotient = secondsAgo / week
                unit = "week"
            } else {
                quotient = secondsAgo / month
                unit = "month"
            }
            return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        }
}

