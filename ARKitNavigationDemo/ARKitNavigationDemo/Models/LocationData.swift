//
//  LocationData.swift
//  ARKitNavigationDemo
//
//  Created by Christopher Webb-Orenstein on 9/26/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit

struct LocationData {
    var destinationLocation: CLLocation!
    var annotations: [POIAnnotation]
    var legs: [[CLLocationCoordinate2D]]
    var steps: [MKRouteStep]
}
