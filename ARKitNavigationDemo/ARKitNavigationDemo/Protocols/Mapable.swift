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
    var annons: [POIAnnotation] { get set }
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
    
    //    func showPointsOfInterestInMap(currentLegs: [[CLLocationCoordinate2D]]) {
    //        mapView.removeAnnotations(mapView.annotations)
    //        for leg in currentLegs {
    //            for item in leg {
    //                let poi = POIAnnotation(point: PointOfInterest(name: String(describing: item), coordinate: item))
    //                mapView.addAnnotation(poi)
    //            }
    //        }
    //    }
    //
    //    func addAnnotations() {
    //        mapView?.addAnnotations(annons)
    //        let overlays = annons.map { MKCircle(center: $0.coordinate, radius: 0.2) }
    //        mapView?.addOverlays(overlays)
    //    }
}

