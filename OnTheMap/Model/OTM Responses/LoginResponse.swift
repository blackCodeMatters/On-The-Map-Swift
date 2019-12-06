//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 11/18/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}
    
struct Session: Codable {
    let id: String
    let expiration: String
}

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

