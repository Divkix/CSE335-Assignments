//
//  PlaceOfInterest.swift
//  Lab6CityGuide
//
//  Created by Divanshu Chauhan on 10/27/24.
//


import Foundation
import MapKit

class PlaceOfInterest: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}