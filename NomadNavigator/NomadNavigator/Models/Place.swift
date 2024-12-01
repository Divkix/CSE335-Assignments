//
//  Place.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//


import Foundation
import CoreLocation

struct Place: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
