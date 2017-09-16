//
//  StartViewController.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol StartViewControllerDelegate: class {
    func startNavigation(tapped: Bool)
}

class StartViewController: UIViewController, Controller {
    
    weak var delegate: StartViewControllerDelegate?
    
    var locationService: LocationService!
    
    var type: ControllerType = .Nav
    
    @IBAction func goButtonTapped(_ sender: Any) {
        delegate?.startNavigation(tapped: true)
    }
}

