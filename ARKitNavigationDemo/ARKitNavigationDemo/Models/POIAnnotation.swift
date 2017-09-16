//
//  POIAnnotation.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/28/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import MapKit

class POIAnnotation: NSObject, MKAnnotation {
    let pointOfInterest: PointOfInterest
    var coordinate: CLLocationCoordinate2D {
        return pointOfInterest.coordinate
    }
    
    var title: String? {
        return pointOfInterest.name
    }
    
    var subtitle: String? {
        return "(\(pointOfInterest.coordinate.latitude),\(pointOfInterest.coordinate.longitude))"
    }
    
    init(point: PointOfInterest) {
        pointOfInterest = point
        super.init()
    }
}
