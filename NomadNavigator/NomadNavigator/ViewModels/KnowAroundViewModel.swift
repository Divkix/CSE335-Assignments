//
//  KnowAroundViewModel.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//


import Foundation
import MapKit
import CoreLocation

struct POICategory: Identifiable {
    let id = UUID()
    let category: MKPointOfInterestCategory?
    let displayName: String
}

class KnowAroundViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var places: [PlaceOfInterest] = []
    @Published var userRegion: MKCoordinateRegion
    @Published var selectedCategory: POICategory?
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?

    let allCategories: [POICategory] = [
        POICategory(category: nil, displayName: "All Categories"),
        POICategory(category: .amusementPark, displayName: "Amusement Park"),
        POICategory(category: MKPointOfInterestCategory.aquarium, displayName: "Aquarium"),
        POICategory(category: MKPointOfInterestCategory.beach, displayName: "Beach"),
        POICategory(category: MKPointOfInterestCategory.brewery, displayName: "Brewery"),
        POICategory(category: MKPointOfInterestCategory.campground, displayName: "Campground"),
        POICategory(category: MKPointOfInterestCategory.museum, displayName: "Museum"),
        POICategory(category: MKPointOfInterestCategory.hiking, displayName: "Hiking"),
        POICategory(category: MKPointOfInterestCategory.golf, displayName: "Golf"),
        POICategory(category: MKPointOfInterestCategory.bakery, displayName: "Bakery"),
        POICategory(category: MKPointOfInterestCategory.castle, displayName: "Castle"),
        POICategory(category: MKPointOfInterestCategory.fairground, displayName: "Fairground"),
        POICategory(category: MKPointOfInterestCategory.nationalPark, displayName: "National Park"),
        POICategory(category: MKPointOfInterestCategory.park, displayName: "Park"),
        POICategory(category: MKPointOfInterestCategory.restaurant, displayName: "Restaurant"),
        POICategory(category: MKPointOfInterestCategory.stadium, displayName: "Stadium"),
        POICategory(category: MKPointOfInterestCategory.theater, displayName: "Theater"),
        POICategory(category: MKPointOfInterestCategory.winery, displayName: "Winery"),
        POICategory(category: MKPointOfInterestCategory.zoo, displayName: "Zoo")
    ]


    override init() {
        self.userRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        super.init()
        locationManager.delegate = self
    }

    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }

    func fetchNearbyPlaces(category: MKPointOfInterestCategory? = nil) {
        guard let userLocation = userLocation else { return }

        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 3218, longitudinalMeters: 3218)
        let request = MKLocalPointsOfInterestRequest(coordinateRegion: region)

        if let category = category {
            request.pointOfInterestFilter = MKPointOfInterestFilter(including: [category])
        } else {
            // Using the predefined list of categories instead of allCategories
            let allCategories: [MKPointOfInterestCategory] = [
                .amusementPark,
                .aquarium,
                .beach,
                .brewery,
                .campground,
                .museum,
                .nationalPark,
                .park,
                .restaurant,
                .stadium,
                .theater,
                .winery,
                .zoo
            ]

            request.pointOfInterestFilter = MKPointOfInterestFilter(including: allCategories)
        }

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let mapItems = response?.mapItems {
                    self.places = mapItems.map { PlaceOfInterest(mapItem: $0) }
                } else if let error = error {
                    print("Error searching for places: \(error.localizedDescription)")
                    self.places = []
                }
            }
        }
    }

    // CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted.")
            // Handle accordingly, e.g., show an alert to the user.
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if userLocation == nil {
            userLocation = location.coordinate
            DispatchQueue.main.async {
                self.userRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            }
            fetchNearbyPlaces(category: selectedCategory?.category)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}

