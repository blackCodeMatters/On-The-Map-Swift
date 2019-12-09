//
//  ViewController.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 11/18/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables and Constants
    var activeTextField: UITextField?
    
    //MARK: - Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLoggingIn(false)
        emailTextField.text = ""
        passwordTextField.text = ""
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: - Methods
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                _ = OTMClient.getStudentLocations { (students, error) in
                DataModel.students = students
                }
                self.setLoggingIn(false)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
            view.frame.origin.y = -100
    }
    
    @objc func keyboardWillHide(_ notifcation:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
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

