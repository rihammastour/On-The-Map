//
//  LoginRequest.swift
//  On The Map
//
//  Created by Riham Mastour on 27/11/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import Foundation

// MARK: - Login request
struct LoginRequest: Codable {
    let udacity: Udacity
}

// MARK: - Udacity
struct Udacity: Codable {
    let username, password: String
}
