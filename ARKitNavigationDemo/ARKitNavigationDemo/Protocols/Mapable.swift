//
//  Mapable.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit

protocol Mapable: AnyObject  {
    var startingLocation: CLLocation! { get set }
    var mapView: MKMapView! { get set }
}

extension Mapable {
    
    func centerMapInInitialCoordinates() {
        if startingLocation != nil {
            DispatchQueue.main.async {
                self.mapView.setCenter(self.startingLocation.coordinate, animated: true)
                let latDelta: CLLocationDegrees = 0.004
                let lonDelta: CLLocationDegrees = 0.004
                let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
                let region = MKCoordinateRegion(center: self.startingLocation.coordinate, span: span)
                self.mapView.setRegion(region, animated: false)
            }
        }
    }

}
