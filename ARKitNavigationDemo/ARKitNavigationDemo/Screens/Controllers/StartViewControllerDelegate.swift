//
//  StartViewControllerDelegate.swift
//  ARKitNavigationDemo
//
//  Created by Christopher Webb-Orenstein on 9/25/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit

protocol StartViewControllerDelegate: class {
    func startNavigation(tapped: Bool)
    func startNavigation(with route: [POIAnnotation], for destination: CLLocation, and legs: [[CLLocationCoordinate2D]], and step: [MKRouteStep])
}
