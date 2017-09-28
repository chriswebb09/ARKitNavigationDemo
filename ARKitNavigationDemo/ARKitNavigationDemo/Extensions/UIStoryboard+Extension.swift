//
//  UIStoryboard+Extension.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

// MARK: - Storyboard

extension UIStoryboard {
    
    // Enumeration of all storyboard names used in the app
    
    enum Storyboard: String {
        case start, navigation
        
        // The name of the storyboard's file, returned with capitalization applied
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) throws {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() throws -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            let error = StoryboardIdentifiableError.unrecognizedIdentifier
            print("\(error.localizedDescription): \(T.storyboardIdentifier)")
            throw error
        }
        return viewController
    }
}

// MARK: - Storyboard Identifiable Error

// MARK: - View Controller

extension UIViewController: StoryboardIdentifiable { }

