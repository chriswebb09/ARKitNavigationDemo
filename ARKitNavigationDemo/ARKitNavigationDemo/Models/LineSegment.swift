//
//  LineSegment.swift
//  ARKitNavigationDemo
//
//  Created by Leonid Borodaev on 17/11/2017.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation

struct LineSegment {
    var start: CLLocation
    var end: CLLocation
    
    init(lat1: Double, long1: Double, alt1: Double, lat2:Double, long2:Double, alt2:Double) {
        start = CLLocation(latitude: lat1, longitude: lng1)
        start.altitude = alt1
        end = CLLocation(latitude: lat2, longitude: lng2)
        start.altitude = alt2
    }
}
