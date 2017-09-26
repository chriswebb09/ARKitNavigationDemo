//
//  ControllerCoordinator.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import MapKit

enum  ControllerType {
    case nav, start, none
}

protocol Controller: class {
    var type: ControllerType { get }
}

protocol ControllerCoordinatorDelegate: CoordinatorDelegate {
    func transitionCoordinator(type: CoordinatorType)
    func setLocationData(for route: [POIAnnotation], with destination: CLLocation, and legs: [[CLLocationCoordinate2D]], and steps: [MKRouteStep])
}

typealias RootController = UIViewController & Controller

protocol ControllerCoordinator: Coordinator {
    var window: UIWindow { get set }
    var rootController: RootController! { get }
    weak var delegate: ControllerCoordinatorDelegate? { get set }
}
