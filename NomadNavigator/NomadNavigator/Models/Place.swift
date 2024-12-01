//
//  Place.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//


import Foundation
import MapKit

struct Place: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

