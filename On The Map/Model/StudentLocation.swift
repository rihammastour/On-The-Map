//
//  StudentLocation.swift
//  On The Map
//
//  Created by Riham Mastour on 27/11/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import Foundation

struct AllLocations: Codable {
    let results: [StudentLocation]
}

// MARK: - StudentLocation
struct StudentLocation: Codable {
    var firstName, lastName: String?
    var longitude, latitude: Double?
    var mapString: String?
    var mediaURL: String?
    var uniqueKey, objectID, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, longitude, latitude, mapString, mediaURL, uniqueKey
        case objectID = "objectId"
        case createdAt, updatedAt
    }
}

// MARK: Student Location Parameters
enum StudentLocationParameters: String {
    case createdAt
    case firstName
    case lastName
    case latitude
    case longitude
    case mapString
    case mediaURL
    case objectID
    case uniqueKey
    case updatedAt
}

