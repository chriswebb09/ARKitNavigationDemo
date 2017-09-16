//
//  StartControllerCoordinator.swift
//  ARKitNavigationDemo
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class StartControllerCoordinator: ControllerCoordinator {
    
    var window: UIWindow
    
    var rootController: RootController!
    
    weak var delegate: ControllerCoordinatorDelegate?
    
    private var navigationController: UINavigationController {
        return UINavigationController(rootViewController: rootController)
    }
    
    var type: ControllerType {
        didSet {
            if let storyboard = try? UIStoryboard(.Start) {
                if let viewController: StartViewController = try? storyboard.instantiateViewController() {
                    rootController = viewController
                    viewController.delegate = self
                }
            }
        }
    }
    
    init(window: UIWindow) {
        self.window = window
        type = .Start
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension StartControllerCoordinator: StartViewControllerDelegate {
    func startNavigation(tapped: Bool) {
        delegate?.transitionCoordinator(type: .app)
    }
}

