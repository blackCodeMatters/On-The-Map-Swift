//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 11/18/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import Foundation

class OTMClient {
    
    struct Auth {
        static var dataResponse: Any?
        static var loginResponse: Any?
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case studentLocation
        case signUp
        
        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "/session"
            case .studentLocation:
                return Endpoints.base + "/StudentLocation"
            case .signUp:
                return "https://auth.udacity.com/sign-up?"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: OTMClient.Endpoints.session.url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let udacityDict = LoginRequest(username: username, password: password)
        
        let body = Udacity(udacity: udacityDict)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            print("login, error is not nil")
            completion(false, error)
          }
          let range = (5..<data!.count)
          let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)

        let decoder = JSONDecoder()
            do {
                //should add guard or if/let
                let responseObject = try decoder.decode(LoginResponse.self, from: newData!)
                print("response object is \(responseObject)")
                Auth.loginResponse = newData
                Auth.sessionId = responseObject.session.id
                print("successful login, session id is \(Auth.sessionId)")
                completion(true, nil)
            } catch {
                Auth.dataResponse = newData
                completion(false, error)
            }
        }
        task.resume()
    }
 
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = (5..<data!.count)
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
            //Auth.loginResponse = newData
            Auth.sessionId = ""
                print("logout call, sessionID is now \(Auth.sessionId)")
                completion()

        }
        task.resume()
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        //let request = Endpoints.studentLocation.url
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
              return
          }
            let decoder = JSONDecoder()
            let responseObject = try! decoder.decode(Results.self, from: data!)
            completion(responseObject.results, nil)
        }
        task.resume()
    }
    
}
