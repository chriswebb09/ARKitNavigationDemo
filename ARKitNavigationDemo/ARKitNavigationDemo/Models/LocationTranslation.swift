//
//  LocationTranslation.swift
//  ARKitNavigationDemo
//
//  Created by Christopher Webb-Orenstein on 9/26/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

struct LocationTranslation {
    var latitudeTranslation: Double
    var longitudeTranslation: Double
    var altitudeTranslation: Double
    init(latitudeTranslation: Double, longitudeTranslation: Double, altitudeTranslation: Double) {
        self.latitudeTranslation = latitudeTranslation
        self.longitudeTranslation = longitudeTranslation
        self.altitudeTranslation = altitudeTranslation
    }
}
