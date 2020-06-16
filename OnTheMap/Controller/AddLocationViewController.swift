//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 12/3/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var webTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var finishStackView: UIStackView!
    @IBOutlet weak var alertTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables and Constants
    lazy var geocoder = CLGeocoder()
    var latitude: Double = 21.0
    var longitude: Double = -37.1
    var mediaURL: String = ""
    var activeTextField: UITextField?
    
    //MARK: - Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        locationTextField.delegate = self
        webTextField.delegate = self
        
        alertView(false, message: "")
        needsValidInput(true)
    }
    
    //MARK: - Methods
    func needsValidInput(_ needsValidInput: Bool) {
        locationTextField.isHidden = !needsValidInput
        webTextField.isHidden = !needsValidInput
        findLocationButton.isHidden = !needsValidInput
        mapView.isHidden = needsValidInput
        finishStackView.isHidden = needsValidInput
    }
    
    func alertView(_ alertToShow: Bool, message: String) {
        alertTextView.isHidden = !alertToShow
        activityIndicator.isHidden = !alertToShow
        if alertToShow {
            activityIndicator.startAnimating()
            alertTextView.text = message
        } else {
            activityIndicator.stopAnimating()
            alertTextView.text = message
        }
    }
    
    func showPin() {
        var annotations = [MKPointAnnotation]()
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        annotation.coordinate = coordinate
        annotation.title = self.webTextField.text
        annotations.append(annotation)
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
            self.mapView.centerCoordinate = coordinate
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    func validateUrl() {
        if webTextField.text != "" {
            self.mediaURL = webTextField.text!
            alertView(false, message: "")
            needsValidInput(false)
            showPin()
        } else {
            alertView(true, message: "        Please enter a URL")
        }
    }

    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Based on Forward Geocoding tutorial on cocoacasts.com by Bart Jacobs
        alertView(true, message: "        Checking Location")
        if error != nil {
            alertView(false, message: "")

        } else {
            var location: CLLocation?

            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if let location = location {
                let coordinate = location.coordinate
                self.latitude = coordinate.latitude
                self.longitude = coordinate.longitude
                validateUrl()
            } else {
                alertView(true, message: "        No Matching Location Found")
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .orange
                pinView!.rightCalloutAccessoryView = UIButton(type: .roundedRect)
            }
            else {
                pinView!.annotation = annotation
            }
            return pinView
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        alertView(false, message: "")
        self.activeTextField = textField
        self.webTextField.text = "http://"
    }
    
    //MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        guard let address = locationTextField.text else { return }
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        self.view.endEditing(true)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        alertView(true, message: "        Uploading Data")
        OTMClient.postStudentLocation(mediaURL: mediaURL, latitude: latitude, longitude: longitude) { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    let errorMsg = error
                    self.alertView(true, message: "        \(errorMsg)")
                }
            } else {
                DispatchQueue.main.async {
                    self.alertView(false, message: "")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}


