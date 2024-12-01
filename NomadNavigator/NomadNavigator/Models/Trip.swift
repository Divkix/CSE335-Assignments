//
//  Trip.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import Foundation

struct Trip: Identifiable, Codable {
    var id = UUID()
    var startDate: Date
    var endDate: Date
    var location: String
    var detailedLocation: String
}
