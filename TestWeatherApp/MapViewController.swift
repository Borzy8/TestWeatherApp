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
        let authStatus = CLLocationManager.authorizationStatus()
        print("*****")
        print(authStatus.rawValue)
        if authStatus == .notDetermined {
            print("************")
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        mapView.delegate = self;
        
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        gestureRecognizer.minimumPressDuration = 1.0;
        mapView.addGestureRecognizer(gestureRecognizer);
        
        startLocationManager()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addAnnotation(gestRecognizer: UIGestureRecognizer?, location: CLLocation?) {
        print("Annotation added")
        
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
            print(newCoordinate);
            
            let annotation = MKPointAnnotation();
            annotation.coordinate = newCoordinate;
            annotation.title = "Title"
            
            mapView.addAnnotation(annotation);
           
            self.oldAnnotation = annotation;
            
        }
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("DELEGATE")
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch newState {
        case .starting:
            view.dragState = .dragging;
            print(view.annotation?.coordinate)
        case .canceling,.ending:
            view.dragState = .none
            print(view.annotation?.coordinate)
        default:
            break
        }
    }
    
   
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            self.location = location
            print(location)
            addAnnotation(gestRecognizer: nil, location: location);
            stopLocationManager()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error);
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
}
