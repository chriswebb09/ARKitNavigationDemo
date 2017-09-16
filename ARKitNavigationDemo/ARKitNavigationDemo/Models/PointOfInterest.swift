//
//  PointOfInterest.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import CoreLocation

class PointOfInterest: NSObject {
    
    var name: String
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}

extension PointOfInterest {
    static func ==(lhs: PointOfInterest, rhs: PointOfInterest) -> Bool {
        return lhs.name == rhs.name && lhs.coordinate == rhs.coordinate
    }
}
