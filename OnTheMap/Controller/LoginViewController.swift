//
//  ViewController.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 11/18/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: NSLayoutConstraint!
    
    //let urlBase = "https://onthemap-api.udacity.com/v1/session"
    
    //var students: [Results] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        //let username = emailTextField.text
        //let password = passwordTextField.text
        //OTMClient.createSessionId()
        
        OTMClient.login(username: emailTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:))
        
    }
    /*
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: OTMClient.Endpoints.session.url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let udacityDict = LoginRequest(username: username, password: password)
        
        let body = Udacity(udacity: udacityDict)
        print(body)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = (5..<data!.count)
          let newData = data?.subdata(in: range) /* subset response data! */
          //print(String(data: newData!, encoding: .utf8)!)
            DispatchQueue.main.async {
                self.getStudentLocations()
                self.handleLoginResponse(success: true, error: nil)
            }
        }
        task.resume()
        
    }*/
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        UIApplication.shared.open(OTMClient.Endpoints.signUp.url)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            print("successful login response")
            DispatchQueue.main.async {
                _ = OTMClient.getStudentLocations { (students, error) in
                DataModel.students = students
                print("pulling data during login")
                }
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
        } else {
            handleLoginFail(success: false, error: error)
            //showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleLoginFail(success: Bool, error: Error?) {
        if success {
            //success would login
        } else {
            let decoder = JSONDecoder()
            do {
            let data = OTMClient.Auth.dataResponse
            let responseObject = try decoder.decode(UdacityResponse.self, from: data! as! Data)
            print("response object is \(responseObject)")
                showLoginFailure(message: responseObject.error)
            } catch {
                //stuff
            }
        }
    }
    
    /*
    func handleSessionResponse(success: Bool, error: Error?) {
        //setLoggingIn(false)
        if success {
            //DispatchQueue.main.async {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            //}
        } else {
            showLoginFailure(message: "wrong username and/or password")
            //showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }*/
    
    /*func handleStudentGetRequest(success: Bool, error: Error?) {
        if success {
            print("handled the student get request")
        } else {
            print("something wrong with get request")
        }
    }*/
    
    func showLoginFailure(message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.show(alertVC, sender: nil)
        }
        //setLoggingIn(false)
    }

}

