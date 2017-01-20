//
//  ViewController.swift
//  MapApplication
//
//  Created by Vishwajeet Dagar on 1/17/17.
//  Copyright © 2017 Vishwajeet. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
//MARK: Outlets
    
    var locate:String=""
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    var mapViewModel = MapViewModel()
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
//MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
//MARK: Map Functions
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
            case 0:
                mapView.mapType = .standard
            case 1:
                mapView.mapType = .satellite
            default:
                mapView.mapType = .hybrid
        }
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = mapViewModel.getAnnot(annotation:annotation) {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        locate = mapViewModel.giveLocation(annotation: view.annotation!)
        performSegue(withIdentifier: "showrestaurantdetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showrestaurantdetails"{
            let destVC=segue.destination as! DetailViewController
            destVC.locate=locate
        }
        else{
            print("Error while using segue")
        }
    }
    
    
    
//MARK: Location Functions and Setting annotations
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print(locValue.latitude)
        if (manager.location != nil){
            mapViewModel.getRestaurants(currentLocation: locValue,completionClosure: {(restarauntlocation: [LocationData]?)->() in
                if restarauntlocation != nil{
                self.mapView.addAnnotations(restarauntlocation!)
                }
                else{
                    let alertController = UIAlertController(title: "Network Error!", message:
                        "Could not connect to the internet", preferredStyle: UIAlertControllerStyle.alert)
                    weak var weakSelf = self
                    alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default,handler: {(action: UIAlertAction!) in weakSelf?.locationManager.startUpdatingLocation()}))
                    self.present(alertController, animated: true, completion: nil)

                }
            })
        centerMapOnLocation(location: manager.location!)
        locationManager.stopUpdatingLocation()
        }
        else{
            print("Could not obtain location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
}

