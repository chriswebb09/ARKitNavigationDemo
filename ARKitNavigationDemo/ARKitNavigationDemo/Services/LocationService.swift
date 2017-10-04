//
//  LocationService.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationService: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    var currentLocation: CLLocation?
    var initial: Bool = true
    var userHeading: CLLocationDirection!
    var locations: [CLLocation] = []
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        
        
        requestAuthorization(locationManager: locationManager)
        
//        switch(CLLocationManager.authorizationStatus()) {
//        case .authorizedAlways, .authorizedWhenInUse:
//            startUpdatingLocation(locationManager: locationManager)
//            lastLocation = locationManager.location
//        case .notDetermined, .restricted, .denied:
//            stopUpdatingLocation(locationManager: locationManager)
//            locationManager.requestWhenInUseAuthorization()
//        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
    }
    
    func requestAuthorization(locationManager: CLLocationManager) {
        locationManager.requestWhenInUseAuthorization()
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation(locationManager: locationManager)
        case .denied, .notDetermined, .restricted:
            stopUpdatingLocation(locationManager: locationManager)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy < 0 { return }
        
        let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        userHeading = heading
        NotificationCenter.default.post(name: Notification.Name(rawValue:"myNotificationName"), object: self, userInfo: nil)
    }
    
    func startUpdatingLocation(locationManager: CLLocationManager) {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func stopUpdatingLocation(locationManager: CLLocationManager) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            delegate?.trackingLocation(for: location)
        }
        currentLocation = manager.location
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
