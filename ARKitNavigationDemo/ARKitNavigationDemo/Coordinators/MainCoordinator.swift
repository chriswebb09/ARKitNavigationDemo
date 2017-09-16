//
//  MainCoordinator.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

import MapKit

class MainCoordinator: AppCoordinator {
    
    weak var delegate: ControllerCoordinatorDelegate?

    var childCoordinators: [ControllerCoordinator] = []
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        transitionCoordinator(type: .start)
    }
    
    func addChildCoordinator(_ childCoordinator: ControllerCoordinator) {
        childCoordinator.delegate = self
        childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}

extension MainCoordinator: ControllerCoordinatorDelegate {
    
    // Switch between application flows
    
    func transitionCoordinator(type: CoordinatorType) {
        
        // Remove previous application flow
        
        childCoordinators.removeAll()
        
        switch type {
        case .app:
            let navCoordinator = NavigationControllerCoordinator(window: window)
            addChildCoordinator(navCoordinator)
            navCoordinator.type = .Nav
            navCoordinator.start()
        case .start:
            let startCoordinator = StartControllerCoordinator(window: window)
            addChildCoordinator(startCoordinator)
            startCoordinator.type = .Start
            startCoordinator.start()
        }
    }
}

