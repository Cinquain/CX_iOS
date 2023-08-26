//
//  MapViewRepresentable.swift
//  CityXcape
//
//  Created by James Allan on 8/24/23.
//

import UIKit
import MapKit
import SwiftUI
import CoreLocation


struct MapViewRepresentable: UIViewRepresentable {
    let locationManager = LocationService.shared
    let mapView = MKMapView()
    var center: CLLocationCoordinate2D?
    
    
    func makeUIView(context: Context) -> MKMapView {
        setRegionForMap()
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //TBD
    }
    
    
    fileprivate func setRegionForMap() {
        guard let location = locationManager.userLocation else {
            locationManager.checkAuthorizationStatus()
            return}
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location,span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
}
