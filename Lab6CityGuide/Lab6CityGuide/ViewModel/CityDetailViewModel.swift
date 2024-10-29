//
//  CityDetailViewModel.swift
//  Lab6CityGuide
//
//  Created by Divanshu Chauhan on 10/27/24.
//


import Foundation
import MapKit

class CityDetailViewModel: ObservableObject {
    @Published var city: City
    @Published var placesOfInterest: [MKMapItem] = []

    init(city: City) {
        self.city = city
    }

    func searchPlaces(query: String) {
        guard let coordinate = city.coordinate else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let items = response?.mapItems {
                DispatchQueue.main.async {
                    self.placesOfInterest = items
                }
            }
        }
    }
}
