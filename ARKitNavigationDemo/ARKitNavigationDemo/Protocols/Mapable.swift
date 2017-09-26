//
//  Mapable.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit

protocol Mapable: class  {
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
                let span = MKCoordinateSpanMake(latDelta, lonDelta)
                let region = MKCoordinateRegionMake(self.startingLocation.coordinate, span)
                self.mapView.setRegion(region, animated: false)
            }
        }
    }

}
