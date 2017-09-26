//
//  Double+Extension.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

extension Double {
    
    func metersToLatitude() -> Double {
        return self / (6373000.0)
    }
    
    func metersToLongitude() -> Double {
        return self / (5602900.0)
    }
    
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
    
    func toDegrees() -> Double {
        return self * 180.0 / .pi
    }
}
