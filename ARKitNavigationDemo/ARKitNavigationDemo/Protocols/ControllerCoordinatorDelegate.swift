//
//  ControllerCoordinatorDelegate.swift
//  ARKitNavigationDemo
//
//  Created by Christopher Webb-Orenstein on 9/26/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit

protocol ControllerCoordinatorDelegate: CoordinatorDelegate {
    func transitionCoordinator(type: CoordinatorType)
    func setLocationData(for route: [POIAnnotation], with destination: CLLocation, and legs: [[CLLocationCoordinate2D]], and steps: [MKRouteStep])
}
