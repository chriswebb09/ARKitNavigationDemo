//
//  LocationServiceDelegate.swift
//  ARKitNavigationDemo
//
//  Created by Christopher Webb-Orenstein on 9/26/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import CoreLocation

protocol LocationServiceDelegate: class {
    func trackingLocation(for currentLocation: CLLocation)
    func trackingLocationDidFail(with error: Error)
}
