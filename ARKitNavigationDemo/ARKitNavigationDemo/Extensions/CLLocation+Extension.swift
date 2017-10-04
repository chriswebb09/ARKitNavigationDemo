//
//  CLLocation+Extension.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import CoreLocation
import GLKit
import SceneKit

func -(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> CLLocationDistance {
    
    let leftLatRadian = left.latitude.toRadians()
    let leftLonRadian = left.longitude.toRadians()
    
    let rightLatRadian = right.latitude.toRadians()
    let rightLonRadian = right.longitude.toRadians()
    
    let a = pow(sin((rightLatRadian - leftLatRadian) / 2), 2)
        + pow(sin((rightLonRadian - leftLonRadian) / 2), 2) * cos(leftLatRadian) * cos(rightLatRadian)
    return 2 * atan2(sqrt(a), sqrt(1 - a))
}

extension CLLocation {
    
    func bearingToLocationRadian(_ destinationLocation: CLLocation) -> Double {
        
        let lat1 = self.coordinate.latitude.toRadians()
        let lon1 = self.coordinate.longitude.toRadians()
        
        let lat2 = destinationLocation.coordinate.latitude.toRadians()
        let lon2 = destinationLocation.coordinate.longitude.toRadians()
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x)
        return radiansBearing
    }
    
    public func translatedLocation(with latitudeTranslation: Double, longitudeTranslation: Double, altitudeTranslation: Double) -> CLLocation {
        let latitudeCoordinate = self.coordinate.coordinate(with: 0, and: latitudeTranslation)
        let longitudeCoordinate = self.coordinate.coordinate(with: 90, and: longitudeTranslation)
        let coordinate = CLLocationCoordinate2D(
            latitude: latitudeCoordinate.latitude,
            longitude: longitudeCoordinate.longitude)
        let altitude = self.altitude + altitudeTranslation
        return CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.verticalAccuracy, timestamp: self.timestamp)
    }
    
    func translation(toLocation location: CLLocation) -> LocationTranslation {
        let inbetweenLocation = CLLocation(latitude: self.coordinate.latitude, longitude: location.coordinate.longitude)
        let distanceLatitude = location.distance(from: inbetweenLocation)
        let latitudeTranslation: Double
        if location.coordinate.latitude > inbetweenLocation.coordinate.latitude {
            latitudeTranslation = distanceLatitude
        } else {
            latitudeTranslation = 0 - distanceLatitude
        }
        let distanceLongitude = self.distance(from: inbetweenLocation)
        let longitudeTranslation: Double
        if self.coordinate.longitude > inbetweenLocation.coordinate.longitude {
            longitudeTranslation = 0 - distanceLongitude
        } else {
            longitudeTranslation = distanceLongitude
        }
        let altitudeTranslation = location.altitude - self.altitude
        return LocationTranslation(
            latitudeTranslation: latitudeTranslation,
            longitudeTranslation: longitudeTranslation,
            altitudeTranslation: altitudeTranslation)
    }
    
    static func bestLocationEstimate(locations: [CLLocation]) -> CLLocation {
        let sortedLocationEstimates = locations.sorted(by: {
            if $0.horizontalAccuracy == $1.horizontalAccuracy {
                return $0.timestamp > $1.timestamp
            }
            return $0.horizontalAccuracy < $1.horizontalAccuracy
        })
        return sortedLocationEstimates.first!
    }
}
