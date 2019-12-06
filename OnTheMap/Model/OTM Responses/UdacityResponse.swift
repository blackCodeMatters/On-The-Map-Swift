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
