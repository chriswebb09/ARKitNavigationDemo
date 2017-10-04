//
//  AppCoordinator.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol AppCoordinator: Coordinator {
    weak var delegate: ControllerCoordinatorDelegate? { get set }
    var childCoordinators: [ControllerCoordinator] { get set }
}
