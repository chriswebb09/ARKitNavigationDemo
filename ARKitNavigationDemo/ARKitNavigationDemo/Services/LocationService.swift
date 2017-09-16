//
//  LocationService.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func trackingLocation(for currentLocation: CLLocation)
    func trackingLocationDidFail(with error: Error)
    func locationManagerDidUpdateLocation(_ locationManager: LocationService, location: CLLocation)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
}

class LocationService: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    var currentLocation: CLLocation?
    var initial: Bool = true
    var locations: [CLLocation] = []
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            lastLocation = locationManager.location
        case .notDetermined, .restricted, .denied:
             startUpdatingLocation()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            if initial == true {
                self.locations = locations
            }
            self.delegate?.locationManagerDidUpdateLocation(self, location: location)
        }
        currentLocation = manager.location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //delegate?.locationManagerDidUpdateHeading(self, heading: newHeading.trueHeading, accuracy: newHeading.headingAccuracy)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error as NSError)
    }
    
    func updateLocation(currentLocation: CLLocation) {
        guard let delegate = delegate else { return }
        delegate.trackingLocation(for: currentLocation)
    }
    
    func updateLocationDidFailWithError(error: Error) {
        guard let delegate = delegate else { return }
        delegate.trackingLocationDidFail(with: error)
    }
}
