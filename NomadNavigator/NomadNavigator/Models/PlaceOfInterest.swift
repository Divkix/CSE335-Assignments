//
//  PlaceOfInterest.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//


import Foundation
import MapKit

struct PlaceOfInterest: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let coordinate: CLLocationCoordinate2D
    let category: MKPointOfInterestCategory?
    let phoneNumber: String?
    let url: URL?

    var categoryName: String? {
        guard let category = category else { return nil }
        switch category {
        case .amusementPark:
            return "Amusement Park"
        case .aquarium:
            return "Aquarium"
        case .beach:
            return "Beach"
        case .brewery:
            return "Brewery"
        case .campground:
            return "Campground"
        case .museum:
            return "Museum"
        case .nationalPark:
            return "National Park"
        case .park:
            return "Park"
        case .restaurant:
            return "Restaurant"
        case .stadium:
            return "Stadium"
        case .theater:
            return "Theater"
        case .winery:
            return "Winery"
        case .zoo:
            return "Zoo"
        default:
            return category.rawValue.replacingOccurrences(of: "MKPOICategory", with: "")
        }
    }

    init(mapItem: MKMapItem) {
        self.name = mapItem.name ?? "Unknown"
        self.subtitle = mapItem.placemark.title ?? ""
        self.coordinate = mapItem.placemark.coordinate
        self.category = mapItem.pointOfInterestCategory
        self.phoneNumber = mapItem.phoneNumber
        self.url = mapItem.url
    }
}
