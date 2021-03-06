//
//  ViewController.swift
//  FindMyCar
//
//  Created by Nick Perkins on 5/13/16.
//  Copyright © 2016 Nick Perkins. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapViewButton: UIBarButtonItem!

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var currentLocation : CLLocation!
    var previousLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Find My Car"
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        
        // present an alert indicating location authorization required
        // and offer to take the user to Settings for the app
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 1)!
        
    }
    
    // When the navigation car button is hit a annotation is placed on the map.
    @IBAction func addMyCar(sender: AnyObject) {
        
        let location = CLLocationCoordinate2DMake(locationManager!.location!.coordinate.latitude, locationManager!.location!.coordinate.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Dude..Sweet..My Car!"
        annotation.subtitle = "Your car is here dude!"
    
        mapView.addAnnotation(annotation)

    }

    // CCLocationManager Delegate. Inside a call is made to have a polyline drawn.
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        
        let oldCoordinates = oldLocation.coordinate
        let newCoordinates = newLocation.coordinate
        
        // This is done to keep it from writing a line from 0,0 which is 389.65 miles off the coast of Ghana in Africa.
        if oldCoordinates.latitude != 0 {
        
            if let oldLocationNew = oldLocation as CLLocation?{
                var area = [oldCoordinates, newCoordinates]
                let polyline = MKPolyline(coordinates: &area, count: area.count)
                mapView.addOverlay(polyline)
//                arrivedAtCar(newLocation)
            }
        }
    
    }
    // this function draws the polyline on the map.
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.blueColor()
            pr.lineWidth = 5
            return pr
        }
        return MKPolylineRenderer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Change Map view between Map and Satellite
    @IBAction func changeMapView(sender: AnyObject) {
        
        if mapViewButton.title == "View: Satellite" {
            mapView.mapType = MKMapType(rawValue: 0)!
            mapViewButton.title = "View: Map"
        }else if(mapViewButton.title == "View: Map"){
            mapView.mapType = MKMapType(rawValue: 4)!
            mapViewButton.title = "View: Satellite"
        }
    }
    
    
    // MARK: - MapView Delegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("Car")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Car")
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        annotationView!.image = UIImage(named: "mapIconSmallRed")
        
        return annotationView
    }
}

// Want to add feature that will notify user when they are near their car.
//func arrivedAtCar(sender: AnyObject) {
//    
//    var current : CLLocation!
//    var carAnnotation : CLLocation!
//    
//    if current .distanceFromLocation(carAnnotation) > 1000 {
//        current = CLLocation (latitude: current.coordinate.latitude, longitude: current.coordinate.longitude)
//        carAnnotation = CLLocation (latitude: carAnnotation.coordinate.latitude, longitude: carAnnotation.coordinate.longitude)
//    }else{
//        let alertController = UIAlertController(title: "Dude Your Car!", message: "You found your car, well done", preferredStyle: .Alert)
//        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
//            
//        })
//        alertController.addAction(OKAction)
//    }
//    
//}


