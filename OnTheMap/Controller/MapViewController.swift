//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 11/21/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        OTMClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
        // The map. See the setup in the Storyboard file. Note particularly that the view controller
        // is set up as the map view's delegate.
        @IBOutlet weak var mapView: MKMapView!
        
    override func viewWillAppear(_ animated: Bool) {
        /*_ = OTMClient.getStudentLocations { (students, error) in
            DataModel.students = students
            //print(DataModel.students)
        }*/
        getStudentPins()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    func getStudentPins() {
    //OTMClient.getStudentLocations()
        
        // The "locations" array is an array of dictionary objects that are similar to the JSON
        // data that you can download from parse.
        
        //let locations = hardCodedLocationData()
        //DispatchQueue.main.async {
                _ = OTMClient.getStudentLocations { (students, error) in
                DataModel.students = students
            //}
            //print(DataModel.students)
            print(DataModel.students.count)
        }
        
        let newLocations = DataModel.students
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for location in newLocations {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = location.mediaURL
            
           
            annotations.append(annotation)
        }
       
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
    }
        // MARK: - MKMapViewDelegate

        // Here we create a view with a "right callout accessory view". You might choose to look into other
        // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
        // method in TableViewDataSource.
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }

        
        // This delegate method is implemented to respond to taps. It opens the system browser
        // to the URL specified in the annotationViews subtitle property.
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                let app = UIApplication.shared
                if let toOpen = view.annotation?.subtitle! {
                    app.open(URL(string: toOpen)!)
                }
            }
        }
    //    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //
    //        if control == annotationView.rightCalloutAccessoryView {
    //            let app = UIApplication.sharedApplication()
    //            app.openURL(NSURL(string: annotationView.annotation.subtitle))
    //        }
    //    }
    
    /*func hardCodedLocationData() -> [[String : Any]] {
         return  [
             [
                 "createdAt" : "2015-02-24T22:27:14.456Z",
                 "firstName" : "Jessica",
                 "lastName" : "Uelmen",
                 "latitude" : 28.1461248,
                 "longitude" : -82.75676799999999,
                 "mapString" : "Tarpon Springs, FL",
                 "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
                 "objectId" : "kj18GEaWD8",
                 "uniqueKey" : 872458750,
                 "updatedAt" : "2015-03-09T22:07:09.593Z"
             ], [
                 "createdAt" : "2015-02-24T22:35:30.639Z",
                 "firstName" : "Gabrielle",
                 "lastName" : "Miller-Messner",
                 "latitude" : 35.1740471,
                 "longitude" : -79.3922539,
                 "mapString" : "Southern Pines, NC",
                 "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
                 "objectId" : "8ZEuHF5uX8",
                 "uniqueKey" : 2256298598,
                 "updatedAt" : "2015-03-11T03:23:49.582Z"
             ], [
                 "createdAt" : "2015-02-24T22:30:54.442Z",
                 "firstName" : "Jason",
                 "lastName" : "Schatz",
                 "latitude" : 37.7617,
                 "longitude" : -122.4216,
                 "mapString" : "18th and Valencia, San Francisco, CA",
                 "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
                 "objectId" : "hiz0vOTmrL",
                 "uniqueKey" : 2362758535,
                 "updatedAt" : "2015-03-10T17:20:31.828Z"
             ], [
                 "createdAt" : "2015-03-11T02:48:18.321Z",
                 "firstName" : "Jarrod",
                 "lastName" : "Parkes",
                 "latitude" : 34.73037,
                 "longitude" : -86.58611000000001,
                 "mapString" : "Huntsville, Alabama",
                 "mediaURL" : "https://linkedin.com/in/jarrodparkes",
                 "objectId" : "CDHfAy8sdp",
                 "uniqueKey" : 996618664,
                 "updatedAt" : "2015-03-13T03:37:58.389Z"
             ]
         ]
     }*/
}

/*
       for dictionary in locations {
           
           // Notice that the float values are being used to create CLLocationDegree values.
           // This is a version of the Double type.
           let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
           let long = CLLocationDegrees(dictionary["longitude"] as! Double)
           
           // The lat and long are used to create a CLLocationCoordinates2D instance.
           let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
           
           let first = dictionary["firstName"] as! String
           let last = dictionary["lastName"] as! String
           let mediaURL = dictionary["mediaURL"] as! String
           
           // Here we create the annotation and set its coordiate, title, and subtitle properties
           let annotation = MKPointAnnotation()
           annotation.coordinate = coordinate
           annotation.title = "\(first) \(last)"
           annotation.subtitle = mediaURL
           
           // Finally we place the annotation in an array of annotations.
           annotations.append(annotation)
       }*/
