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
    var previousLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
    }

    @IBAction func addMyCar(sender: AnyObject) {
        
        let location = CLLocationCoordinate2DMake(40.730872, -74.003066)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Dude..Sweet..My Car!"
        annotation.subtitle = "Your car is here dude. Don't drive while intoxicated dude."
        
        //mapView(mapView, viewForAnnotation: annotation)!.annotation = annotation
        mapView.addAnnotation(annotation)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        
        if let oldLocationNew = oldLocation as CLLocation?{
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            mapView.addOverlay(polyline)
        }
    
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.redColor()
            pr.lineWidth = 5
            return pr
        }
        return MKPolylineRenderer()
    }
    
    
    // MARK: - MapView Delegate
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationReuseId = "Place"
//        var mapView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseId)
//        if mapView == nil {
//            mapView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
//        } else {
//            mapView!.annotation = annotation
//        }
//        mapView!.image = UIImage(named: "mapIconSmallRed")
//        mapView!.backgroundColor = UIColor.clearColor()
//        mapView!.canShowCallout = true
//        return mapView
//    }
}

