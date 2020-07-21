//
//  PostLocationRequest.swift
//  On The Map
//
//  Created by Riham Mastour on 28/11/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import Foundation

struct PostLocationRequest: Codable {
    let uniqueKey, firstName, lastName, mapString: String
    let mediaURL: String
    let latitude, longitude: Double
}
