//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 11/21/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import UIKit
import MapKit
import WebKit

class MapViewController: UIViewController, MKMapViewDelegate {

    //MARK: - Outlets
    @IBOutlet weak var alertTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        checkFetch(message: "        Fetching Data")
        getStudentPins()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFetch(message: "        Data download fail, try refresh")
    }
    
    //MARK: - Methods
    func checkFetch(message: String) {
        let students = DataModel.students
        if students.count == 0 {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
                self.alertTextView.isHidden = false
                self.alertTextView.text = message
            }
        } else {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = true
            self.alertTextView.isHidden = true
            self.alertTextView.text = message
        }
    }
    
    func getStudentPins() {

        _ = OTMClient.getStudentLocations { (students, error) in
            DataModel.students = students
        }
        
        let newLocations = DataModel.students
        
        var annotations = [MKPointAnnotation]()
        
        for location in newLocations {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = location.firstName
            let last = location.lastName
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = location.mediaURL
            
            annotations.append(annotation)
        }
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
            self.checkFetch(message: "        Data download fail, try refresh")
        }
        
    }
        
    //MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .orange
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
            if control == annotationView.rightCalloutAccessoryView {
                let app = UIApplication.shared
                guard let web = annotationView.annotation?.subtitle else { return }
                guard (web?.hasPrefix("https://"))! || (web?.hasPrefix("http://"))! else { return }
                guard let url = URL(string: ((annotationView.annotation?.subtitle)!)!) else { return }
                    app.open(url)
            }
        }
    
    //MARK: - Actions
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        OTMClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        getStudentPins()
    }

}

