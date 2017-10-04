//
//  POIAnnotation.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/28/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import MapKit

final class POIAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?

    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, name: String) {
        self.coordinate = coordinate
        self.title = name
        self.subtitle =  "(\(coordinate.latitude),\(coordinate.longitude))"
        super.init()
    }
}
