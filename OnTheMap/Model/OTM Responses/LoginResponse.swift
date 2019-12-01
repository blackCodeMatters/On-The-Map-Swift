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
    
//{"account":{"registered":true,"key":"822695104573"},"session":{"id":"4313628214S3d63969adfd1eb46dca0e3a16c9fb6d1","expiration":"2019-11-22T02:46:35.706308Z"}}
