//
//  UdacityResponse.swift
//  OnTheMap
//
//  Created by Dustin Mahone on 11/20/19.
//  Copyright © 2019 Dustin. All rights reserved.
//

import Foundation

struct UdacityResponse: Codable {
    let status: Int
    let error: String
}

//setup later
extension UdacityResponse: LocalizedError {
var errorDescription: String? {
    return error
    }
}

//{"status":403,"error":"Account not found or invalid credentials."}
//{"account":{"registered":true,"key":"2759754099"},"session":{"id":"4165686433Saa99b59c8438677d147727966c872f62","expiration":"2019-11-22T01:56:49.122498Z"}}
