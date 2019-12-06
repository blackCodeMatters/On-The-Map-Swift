//
//  ViewController.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 11/18/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLoggingIn(false)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    //MARK: - Methods
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                _ = OTMClient.getStudentLocations { (students, error) in
                DataModel.students = students
                }
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
                }
        } else {
            let decoder = JSONDecoder()
            do {
            let data = OTMClient.Auth.dataResponse
            let responseObject = try decoder.decode(UdacityResponse.self, from: data! as! Data)
                DispatchQueue.main.async {
                    self.showLoginFailure(message: responseObject.error)
                }
            } catch {
                DispatchQueue.main.async {
                    self.showLoginFailure(message: "unknown error, please retry")
                }
            }
        }
    }
    
    func showLoginFailure(message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.show(alertVC, sender: nil)
        }
        setLoggingIn(false)
    }

    func setLoggingIn(_ isLoggingIn: Bool) {
        activityIndicator.isHidden = !isLoggingIn
        if isLoggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    //MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        setLoggingIn(true)
        OTMClient.login(username: emailTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        UIApplication.shared.open(OTMClient.Endpoints.signUp.url)
    }
    
}

