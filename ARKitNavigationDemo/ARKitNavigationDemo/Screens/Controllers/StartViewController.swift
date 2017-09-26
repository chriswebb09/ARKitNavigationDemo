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
    private var currentLegs: [[CLLocationCoordinate2D]] = []
    
    weak var delegate: StartViewControllerDelegate?
    
    var locationService: LocationService = LocationService()
    var navigationService: NavigationService = NavigationService()
    
    var type: ControllerType = .nav
    
    private var locations: [CLLocation] = []
    var startingLocation: CLLocation!
    
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
        let press = UILongPressGestureRecognizer(target: self, action: #selector(handleMapTap(gesture:)))
        press.minimumPressDuration = 0.5
        self.mapView.addGestureRecognizer(press)
        self.mapView.delegate = self
    }
    
    @objc func handleMapTap(gesture: UIGestureRecognizer) {
        print("tap")
        if gesture.state != UIGestureRecognizerState.began {
            return
        }
        
        let touchPoint = gesture.location(in: mapView)
        let coord: CLLocationCoordinate2D = self.mapView.convert(touchPoint, toCoordinateFrom: mapView)
        destinationLocation = coord
    }
    
    private func setupNavigation() {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .default).async {
            
            if self.destinationLocation != nil {
                self.navigationService.getDirections(destinationLocation: self.destinationLocation, request: MKDirectionsRequest()) { steps in
                    for step in steps {
                        self.annotations.append(POIAnnotation(point: PointOfInterest(name: "N " + String(describing: step.instructions), coordinate: step.getLocation().coordinate)))
                    }
                    self.steps.append(contentsOf: steps)
                    group.leave()
                }
            }
            group.wait()
            self.getLocationData()
        }
    }
    
    private func getLocationData() {
        for (index, step) in steps.enumerated() {
            setTripLegFromStep(step, and: index)
        }
        for leg in currentLegs {
            update(intermediary: leg)
        }
        self.centerMapInInitialCoordinates()
        self.showPointsOfInterestInMap(currentLegs: self.currentLegs)
        self.addAnnotations()
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Navigate to your destination?", message: "You've selected \(String(describing: self.title))", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let okayAction = UIAlertAction(title: "Go!", style: .default, handler: { action in
                let destination = CLLocation(latitude: self.destinationLocation.latitude, longitude: self.destinationLocation.longitude)
                self.delegate?.startNavigation(with: self.annotations, for: destination, and: self.currentLegs, and: self.steps)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
      
    }
    
    private func setLeg(from previous: CLLocation, to next: CLLocation) -> [CLLocationCoordinate2D] {
        return CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: previous, destinationLocation: next)
    }
    
    private func showPointsOfInterestInMap(currentLegs: [[CLLocationCoordinate2D]]) {
        mapView.removeAnnotations(mapView.annotations)
        for leg in currentLegs {
            for item in leg {
                let poi = POIAnnotation(point: PointOfInterest(name: String(describing: item), coordinate: item))
                mapView.addAnnotation(poi)
            }
        }
    }
    
    private func update(intermediary locations: [CLLocationCoordinate2D]) {
        for intermediary in locations {
            annotations.append(POIAnnotation(point: PointOfInterest(name: String(describing: intermediary), coordinate: intermediary)))
            self.locations.append(CLLocation(latitude: intermediary.latitude, longitude: intermediary.longitude))
        }
    }
    
    private func setTripLegFromStep(_ step: MKRouteStep, and index: Int) {
        if index > 0 {
            getTripLeg(for: index, and: step)
        } else {
            getInitialLeg(for: step)
        }
    }
    
    private func getTripLeg(for index: Int, and step: MKRouteStep) {
        let previousIndex = index - 1
        let previous = steps[previousIndex]
        let previousLocation = CLLocation(latitude: previous.polyline.coordinate.latitude, longitude: previous.polyline.coordinate.longitude)
        let nextLocation = CLLocation(latitude: step.polyline.coordinate.latitude, longitude: step.polyline.coordinate.longitude)
        let intermediaries = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: previousLocation, destinationLocation: nextLocation)
        currentLegs.append(intermediaries)
    }
    
    private func getInitialLeg(for step: MKRouteStep) {
        let nextLocation = CLLocation(latitude: step.polyline.coordinate.latitude, longitude: step.polyline.coordinate.longitude)
        let intermediaries = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: self.startingLocation, destinationLocation: nextLocation)
        currentLegs.append(intermediaries)
    }
    
    private func addAnnotations() {
        annotations.forEach { annotation in
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
    
    func trackingLocation(for currentLocation: CLLocation) {
        startingLocation = currentLocation
        centerMapInInitialCoordinates()
    }
    
    func trackingLocationDidFail(with error: Error) {
        presentMessage(title: "Error", message: error.localizedDescription)
    }
}

extension StartViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView.canShowCallout = true
            return annotationView
        }
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
