//
//  City.swift
//  Lab6CityGuide
//
//  Created by Divanshu Chauhan on 10/27/24.
//


import Foundation
import CoreLocation
import UIKit

struct City: Identifiable {
    let id = UUID()
    let name: String
    let image: UIImage?
    let description: String
    var coordinate: CLLocationCoordinate2D?
}
