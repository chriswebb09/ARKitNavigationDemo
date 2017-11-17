//
//  NavigationService.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit
import CoreLocation

struct NavigationService {
    
    func getDirections(destinationLocation: CLLocationCoordinate2D, request: MKDirectionsRequest, completion: @escaping ([MKRouteStep]) -> Void) {
        
        var steps: [MKRouteStep] = []
        let placeMark = MKPlacemark(coordinate: destinationLocation)
        request.destination = MKMapItem.init(placemark: placeMark)
        request.source = MKMapItem.forCurrentLocation()
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if error != nil {
                print("Error getting directions")
            } else {
                guard let response = response else { return }
                for route in response.routes {
                    steps.append(contentsOf: route.steps)
                }
                completion(steps)
            }
        }
    }
    
    
    func getDirections(pointsArrays:Array<Array>, request: MKDirectionsRequest, completion: @escaping ([LineSegment]) -> Void) {
        var segments = [LineSegment]()
        var startArr = pointsArrays[0]
        for i in 1..<pointsArrays.count {
            let lat1 = startArr[0] as! Double
            let lng1 = startArr[1] as! Double
            let alt1 = startArr[2] as! Double
            var endArr = pointsArrays[i]
            let lat2 = endArr[0] as! Double
            let lng2 = endArr[1] as! Double
            let alt2 = endArr[2] as! Double
            let segment = LineSegment(lat1: lat1, long1: long1, alt1: lat1, lat2: lat2, long2: long2, alt2: alt2)
            segments.append(segment)
            startArr = endArr
        }
        
        completion(segments)
    }
    
    
}
