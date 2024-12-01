//
//  SelectedLocation.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//


import Foundation
import SwiftData
import CoreLocation

@Model
class SelectedLocation {
    @Attribute(.unique) var id: UUID
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.id = UUID()
        self.latitude = latitude
        self.longitude = longitude
    }
}
