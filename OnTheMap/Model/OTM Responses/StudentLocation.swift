//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 11/18/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    //let objectId: String
    //let uniqueKey: String //check
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    //let createdAt: String
    //let updatedAt: String
    //let ACL:
        
}

struct Results: Codable {
    let results: [StudentLocation]
}
