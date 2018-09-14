//
//  ViewController.swift
//  TestWeatherApp
//
//  Created by Borzy on 10.09.18.
//  Copyright © 2018 Borzy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation?
    
    var oldAnnotation: MKPointAnnotation?
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        checkAuthStatus()
        mapSetup()
    }
    
    func mapSetup () {
        mapView.delegate = self;
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        gestureRecognizer.minimumPressDuration = 1.0;
        mapView.addGestureRecognizer(gestureRecognizer);
        
        startLocationManager()
    }
    
    func checkAuthStatus() {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            mapSetup()
            return
        }
    }

    func addAnnotation(gestRecognizer: UIGestureRecognizer?, location: CLLocation?) {
        
        guard let gestRecognizer = gestRecognizer else {
            
            if let location = location {
                let annotation = MKPointAnnotation();
                annotation.coordinate = location.coordinate
                
                let region = MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8))
                
                mapView.addAnnotation(annotation)
                mapView.setRegion(region, animated: false);
                
                
                self.oldAnnotation = annotation;
            }
            return
        }
        
        if gestRecognizer.state == .began {
            let touchPoint = gestRecognizer.location(in: mapView);
            let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView);
            
            
            if let oldAnnotation = oldAnnotation {
                mapView.removeAnnotation(oldAnnotation)
            }
            
            self.location = CLLocation(latitude: newCoordinate.latitude, longitude
                : newCoordinate.longitude)
            
            let annotation = MKPointAnnotation();
            annotation.coordinate = newCoordinate;
            
            mapView.addAnnotation(annotation);
           
            self.oldAnnotation = annotation;
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowForecast" {
            let forecastController = segue.destination as! ForecastViewController
            forecastController.location = location;
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MapAnnotationView";
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier);
            pinView.annotation = annotation;
            pinView.isDraggable = true;
            pinView.canShowCallout = true;
            
            pinView.image = UIImage(named: "pin-logo");
            pinView.centerOffset = CGPoint(x: 0, y: -pinView.image!.size.height/2)
            
            annotationView = pinView
        } else {
           
        }
        
        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            self.location = location
            addAnnotation(gestRecognizer: nil, location: location);
            stopLocationManager()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopLocationManager()
        showLocationManagerError()
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self;
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopLocationManager() {
        locationManager.stopUpdatingLocation();
        locationManager.delegate = nil;
    }
    
    func showLocationManagerError() {
        let alert = UIAlertController(title: "Location error", message: "Can‘t get location, plaease, try again later.", preferredStyle: .alert);
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction);
        
        self.present(alert, animated: true, completion: nil)
    }
}
