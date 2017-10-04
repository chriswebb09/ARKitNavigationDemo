//
//  StartViewController.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StartViewController: UIViewController, Controller {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var annotationColor = UIColor.blue
    
    internal var annotations: [POIAnnotation] = []
    
    private var currentTripLegs: [[CLLocationCoordinate2D]] = []
    
    weak var delegate: StartViewControllerDelegate?
    
    var locationService: LocationService = LocationService()
    
    var navigationService: NavigationService = NavigationService()
    
    var type: ControllerType = .nav
    
    private var locations: [CLLocation] = []
    
    var startingLocation: CLLocation!
    
    var press: UILongPressGestureRecognizer!
    
    var destinationLocation: CLLocationCoordinate2D! {
        didSet {
            self.setupNavigation()
        }
    }
    
    private var steps: [MKRouteStep] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.delegate = self
        locationService.startUpdatingLocation()
        press = UILongPressGestureRecognizer(target: self, action: #selector(handleMapTap(gesture:)))
        press.minimumPressDuration = 0.35
        mapView.addGestureRecognizer(press)
        mapView.delegate = self
    }
    
    // Sets destination location to point on map
    
    @objc func handleMapTap(gesture: UIGestureRecognizer) {
        if gesture.state != UIGestureRecognizerState.began {
            return
        }
        // Get tap point
        let touchPoint = gesture.location(in: mapView)
        
        // Convert tap point to coordinate
        let coord: CLLocationCoordinate2D = self.mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        destinationLocation = coord
    }
    
    // Gets directions from from MapKit directions API, when finished calculates intermediary locations
    
    private func setupNavigation() {
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .default).async {
            
            if self.destinationLocation != nil {
                self.navigationService.getDirections(destinationLocation: self.destinationLocation, request: MKDirectionsRequest()) { steps in
                    for step in steps {
                        self.annotations.append(POIAnnotation(coordinate: step.getLocation().coordinate, name: "N " + step.instructions))
                    }
                    self.steps.append(contentsOf: steps)
                    group.leave()
                }
            }
            
            // Have to wait until it is finished to move to next step
            group.wait()
            
            self.getLocationData()
        }
    }
    
    private func getLocationData() {
        
        for (index, step) in steps.enumerated() {
            setTripLegFromStep(step, and: index)
        }
        
        for leg in currentTripLegs {
            update(intermediary: leg)
        }
        
        centerMapInInitialCoordinates()
        showPointsOfInterestInMap(currentTripLegs: currentTripLegs)
        addMapAnnotations()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alertController = UIAlertController(title: "Navigate to your destination?", message: "You've selected destination.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "No thanks.", style: .cancel, handler: nil)
            
            let okayAction = UIAlertAction(title: "Go!", style: .default, handler: { action in
                let destination = CLLocation(latitude: self.destinationLocation.latitude, longitude: self.destinationLocation.longitude)
                self.delegate?.startNavigation(with: self.annotations, for: destination, and: self.currentTripLegs, and: self.steps)
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    // Gets coordinates between two locations at set intervals
    
    private func setLeg(from previous: CLLocation, to next: CLLocation) -> [CLLocationCoordinate2D] {
        return CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: previous, destinationLocation: next)
    }
    
    // Add POI dots to map
    
    private func showPointsOfInterestInMap(currentTripLegs: [[CLLocationCoordinate2D]]) {
        mapView.removeAnnotations(mapView.annotations)
        for tripLeg in currentTripLegs {
            for coodinate in tripLeg {
                let poi = POIAnnotation(coordinate: coodinate, name: String(describing: coodinate))
                mapView.addAnnotation(poi)
            }
        }
    }
    
    // Adds calculated distances to annotations and locations arrays
    
    private func update(intermediary locations: [CLLocationCoordinate2D]) {
        for intermediaryLocation in locations {
            annotations.append(POIAnnotation(coordinate: intermediaryLocation, name: String(describing:intermediaryLocation)))
            self.locations.append(CLLocation(latitude: intermediaryLocation.latitude, longitude: intermediaryLocation.longitude))
        }
    }
    
    // Determines whether leg is first leg or not and routes logic accordingly
    
    private func setTripLegFromStep(_ tripStep: MKRouteStep, and index: Int) {
        if index > 0 {
            getTripLeg(for: index, and: tripStep)
        } else {
            getInitialLeg(for: tripStep)
        }
    }
    
    // Calculates intermediary coordinates for route step that is not first
    
    private func getTripLeg(for index: Int, and tripStep: MKRouteStep) {
        let previousIndex = index - 1
        let previousStep = steps[previousIndex]
        let previousLocation = CLLocation(latitude: previousStep.polyline.coordinate.latitude, longitude: previousStep.polyline.coordinate.longitude)
        let nextLocation = CLLocation(latitude: tripStep.polyline.coordinate.latitude, longitude: tripStep.polyline.coordinate.longitude)
        let intermediarySteps = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: previousLocation, destinationLocation: nextLocation)
        currentTripLegs.append(intermediarySteps)
    }
    
    // Calculates intermediary coordinates for first route step
    
    private func getInitialLeg(for tripStep: MKRouteStep) {
        let nextLocation = CLLocation(latitude: tripStep.polyline.coordinate.latitude, longitude: tripStep.polyline.coordinate.longitude)
        let intermediaries = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: startingLocation, destinationLocation: nextLocation)
        currentTripLegs.append(intermediaries)
    }
    
    // Prefix N is just a way to grab step annotations, could definitely get refactored
    
    private func addMapAnnotations() {
        annotations.forEach { annotation in
            
            // Step annotations are green, intermediary are blue
            
            DispatchQueue.main.async {
                if let title = annotation.title, title.hasPrefix("N") {
                    self.annotationColor = .green
                } else {
                    self.annotationColor = .blue
                }
                self.mapView?.addAnnotation(annotation)
                self.mapView.add(MKCircle(center: annotation.coordinate, radius: 0.2))
            }
        }
    }
}

extension StartViewController: LocationServiceDelegate, MessagePresenting, Mapable {
    
    // Once location is tracking - zoom in and center map
    
    func trackingLocation(for currentLocation: CLLocation) {
        startingLocation = currentLocation
        centerMapInInitialCoordinates()
    }
    
    // Don't fail silently
    
    func trackingLocationDidFail(with error: Error) {
        presentMessage(title: "Error", message: error.localizedDescription)
    }
}

extension StartViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.1)
            renderer.strokeColor = annotationColor
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let alertController = UIAlertController(title: "Welcome to \(String(describing: title))", message: "You've selected \(String(describing: title))", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
