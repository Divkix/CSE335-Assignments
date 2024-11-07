//
//  City.swift
//  jsonWebSwiftUI
//
//  Created by Divanshu Chauhan on 11/7/24.
//

import Foundation

struct City: Identifiable, Codable {
    var id = UUID() // Unique identifier for SwiftUI list compatibility
    let geonameId: Int
    let name: String
    let countrycode: String
    let population: Int
    let lat: Double
    let lng: Double
    
    // Coding keys to map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case geonameId
        case name
        case countrycode
        case population
        case lat
        case lng
    }
}
