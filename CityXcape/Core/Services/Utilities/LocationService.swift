//
//  LocationService.swift
//  CityXcape
//
//  Created by James Allan on 8/21/23.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

class LocationService: NSObject, CLLocationManagerDelegate {
    
    
    static let shared = LocationService()
    private override init() {
        super.init()
        manager.delegate = self
        checkAuthorizationStatus()
    }
    
    
    let manager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    
    func checkAuthorizationStatus() {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("Updating location")
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location permission is restricted")
            break
        case .denied:
            print("Location Permission is denied")
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location.coordinate
            if let userLocation {
                region = .init(center: userLocation, span: span)
            }
            if let city = userLocation?.getCity() {
                let message = "Loading \(city)"
                UserDefaults.standard.set(message, forKey: AppUserDefaults.loadMessage)
                UserDefaults.standard.set(city, forKey: AppUserDefaults.city)
            }
        }
    }
    
    
}
