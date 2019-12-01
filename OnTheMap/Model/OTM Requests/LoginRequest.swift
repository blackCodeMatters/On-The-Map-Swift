//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 11/18/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct Udacity: Codable {
    let udacity: LoginRequest
}
