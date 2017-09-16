//
//  MessagePresenting.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 9/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol MessagePresenting {
    func presentMessage(title: String, message: String)
}

extension MessagePresenting where Self: UIViewController {
    func presentMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
