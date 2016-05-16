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

    @IBAction func addMyCar(sender: AnyObject) {
        
        let location = CLLocationCoordinate2DMake(locationManager!.location!.coordinate.latitude, locationManager!.location!.coordinate.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Dude..Sweet..My Car!"
        annotation.subtitle = "Your car is here dude. Be sober dude!"
//        annotation.image = UIImage (named: "mapSmallIconRed")
    
        
        //mapView(mapView, viewForAnnotation: annotation)!.annotation = annotation
        
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



