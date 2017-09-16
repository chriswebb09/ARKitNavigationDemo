//
//  ViewController.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MessagePresenting, Controller {
    
    var type: ControllerType = .Nav
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var sceneView: ARSCNView!
    
    var annotationColor = UIColor.blue
    
    var anchors: [ARAnchor] = []
    var nodes: [BaseNode] = []
    var steps: [MKRouteStep] = []
    
    var locationService: LocationService! = LocationService()
    var navigationService = NavigationService()
    var annons: [POIAnnotation] = []
    
    var startingLocation: CLLocation!
    var heading: CLLocationDirection!
    
    var destinationLocation: CLLocationCoordinate2D!
    
    var locations: [CLLocation] = []
    var currentLegs: [[CLLocationCoordinate2D]] = []
    var currentLeg: [CLLocationCoordinate2D] = []
    var updatedLocations: [CLLocation] = []
    let configuration = ARWorldTrackingConfiguration()
    
    var done: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
        
        destinationLocation = CLLocationCoordinate2D(latitude: 40.736248, longitude: -73.979397)
        
        run()
        locationService.startUpdatingLocation()
        mapView.delegate = self
        locationService = LocationService()
        
        locationService.delegate = self
        locationService.startUpdatingLocation()
        if destinationLocation != nil {
            navigationService.getDirections(destinationLocation: destinationLocation, request: MKDirectionsRequest()) { steps in
                for step in steps {
                    self.annons.append(POIAnnotation(point: PointOfInterest(name: "N " + String(describing: step.instructions), coordinate: step.getLocation().coordinate)))
                }
                self.steps.append(contentsOf: steps)
            }
        }
        
        if self.annons.count <= 0 {
            getLocationData()
        }
    }
    
    func setup() {
        locationService.delegate = self
        locationService.startUpdatingLocation()
    }
    
    func getLocationData() {
        setLegs()
        done = true
    }
    
    func setLeg(from previous: CLLocation, to next: CLLocation) -> [CLLocationCoordinate2D] {
        let intermediaries = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: previous, destinationLocation: next)
        return intermediaries
    }
    
    func setLegs() {
        for (index, step) in steps.enumerated() {
            setTripLegFromStep(step, and: index)
        }
        for leg in currentLegs {
            setIntermediary(intermediaries: leg)
        }
    }
    
    func setIntermediary(intermediaries: [CLLocationCoordinate2D]) {
        for intermediary in intermediaries {
            self.annons.append(POIAnnotation(point: PointOfInterest(name: String(describing: intermediary), coordinate: intermediary)))
            self.locations.append(CLLocation(latitude: intermediary.latitude, longitude: intermediary.longitude))
        }
    }
    
    func setTripLegFromStep(_ step: MKRouteStep, and index: Int) {
        if index > 0 {
            shortIndex(index: index, step: step)
        } else {
            let nextLocation = CLLocation(latitude: step.polyline.coordinate.latitude, longitude: step.polyline.coordinate.longitude)
            let intermediaries = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: self.startingLocation, destinationLocation: nextLocation)
            currentLegs.append(intermediaries)
        }
    }
    
    func shortIndex(index: Int, step: MKRouteStep) {
        guard index < 3 else { return }
        let previousIndex = index - 1
        let previous = steps[previousIndex]
        let previousLocation = CLLocation(latitude: previous.polyline.coordinate.latitude, longitude: previous.polyline.coordinate.longitude)
        let nextLocation = CLLocation(latitude: step.polyline.coordinate.latitude, longitude: step.polyline.coordinate.longitude)
        let intermediaries = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: previousLocation, destinationLocation: nextLocation)
        currentLegs.append(intermediaries)
        print(intermediaries)
    }
    
    func run() {
        configuration.worldAlignment = .gravityAndHeading
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startingLocation = CLLocation.bestLocationEstimate(locations: updatedLocations)
        getLocationData()
        if (startingLocation != nil && mapView.annotations.count == 0) && done == true {
            DispatchQueue.main.async {
                self.showPointsOfInterestInMap(currentLegs: self.currentLegs)
                self.centerMapInInitialCoordinates()
                self.addAnnotations()
                self.addAnchors(steps: self.steps)
            }
        }
    }
    
    func showPointsOfInterestInMap(currentLegs: [[CLLocationCoordinate2D]]) {
        mapView.removeAnnotations(mapView.annotations)
        for leg in currentLegs {
            for item in leg {
                let poi = POIAnnotation(point: PointOfInterest(name: "N " + String(describing: item), coordinate: item))
                mapView.addAnnotation(poi)
            }
        }
    }
    
    func addAnnotations() {
        annons.forEach { annotation in
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
    
    func updateNodePosition() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        startingLocation = CLLocation.bestLocationEstimate(locations: updatedLocations)
        for node in nodes {
            let baseNode = node
            let translation = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: startingLocation, location: baseNode.location)
            let position = positionFromTransform(translation)
            let distance = baseNode.location.distance(from: startingLocation)
            DispatchQueue.main.async {
                let scale = 100 / Float(distance)
                baseNode.scale = SCNVector3(x: scale, y: scale, z: scale)
                baseNode.anchor = ARAnchor(transform: translation)
                baseNode.position = position
            }
        }
        SCNTransaction.commit()
    }
    
    // For navigation route step add sphere node
    
    func addSphere(for step: MKRouteStep) {
        let stepLocation = step.getLocation()
        let locationTransform = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: startingLocation, location: stepLocation)
        let stepAnchor = ARAnchor(transform: locationTransform)
        let sphere = BaseNode(title: step.instructions, location: stepLocation)
        anchors.append(stepAnchor)
        sphere.addNode(with: 0.2, and: .green, and: step.instructions)
        sphere.location = stepLocation
        sphere.anchor = stepAnchor
        sceneView.session.add(anchor: stepAnchor)
        sceneView.scene.rootNode.addChildNode(sphere)
        nodes.append(sphere)
    }
    
    // For intermediary locations - CLLocation - add sphere
    
    func addSphere(for location: CLLocation) {
        let locationTransform = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: startingLocation, location: location)
        let stepAnchor = ARAnchor(transform: locationTransform)
        let sphere = BaseNode(title: "Title", location: location)
        sphere.addSphere(with: 0.11, and: .blue)
        anchors.append(stepAnchor)
        sphere.location = location
        sceneView.session.add(anchor: stepAnchor)
        sceneView.scene.rootNode.addChildNode(sphere)
        sphere.anchor = stepAnchor
        nodes.append(sphere)
    }
}

extension ViewController: ARSCNViewDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        presentMessage(title: "Error", message: error.localizedDescription)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        presentMessage(title: "Error", message: "Session Interuption")
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            print("ready")
        case .notAvailable:
            print("wait")
        case .limited(let reason):
            print("limited tracking state: \(reason)")
        }
    }
}

extension ViewController: LocationServiceDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            if location.horizontalAccuracy <= 65 {
                updateLocations(currentLocation: location)
                DispatchQueue.main.async {
                    self.updateNodePosition()
                }
            }
        }
    }
    
    func locationManagerDidUpdateLocation(_ locationManager: LocationService, location: CLLocation) {
        if location.horizontalAccuracy <= 70.0 {
            updateLocations(currentLocation: location)
            DispatchQueue.main.async {
                self.updateNodePosition()
            }
        }
    }
    
    func trackingLocation(for currentLocation: CLLocation) {
        updateLocations(currentLocation: currentLocation)
    }
    
    func trackingLocationDidFail(with error: Error) {
        presentMessage(title: "Error", message: error.localizedDescription)
    }
    
    func updateLocations(currentLocation: CLLocation) {
        if currentLocation.horizontalAccuracy <= 70.0 {
            updatedLocations.append(currentLocation)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
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

extension ViewController:  Mapable {
    
    func removeAllAnnotations() {
        for anchor in anchors {
            sceneView.session.remove(anchor: anchor)
        }
        anchors.removeAll()
    }
    
    // Get a nodes in sceneView for a matrix transformation
    
    func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    func addAnchors(steps: [MKRouteStep]) {
        guard startingLocation != nil && steps.count > 0 else { return }
        for step in steps {
            addSphere(for: step)
        }
        for location in locations {
            addSphere(for: location)
        }
    }
}

