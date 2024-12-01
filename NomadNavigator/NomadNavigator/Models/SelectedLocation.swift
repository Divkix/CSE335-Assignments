//
//  SelectedLocation.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//


import SwiftData
import Foundation

@Model
final class SelectedLocation {
    var latitude: Double
    var longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

