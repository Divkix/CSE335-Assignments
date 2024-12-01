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
    
    private var userLocation: CLLocationCoordinate2D?
    private let locationManager = CLLocationManager() // Added
    
    let allCategories: [POICategory] = [
        POICategory(category: nil, displayName: "All Categories"),
        POICategory(category: .amusementPark, displayName: "Amusement Park"),
        POICategory(category: .aquarium, displayName: "Aquarium"),
        POICategory(category: .beach, displayName: "Beach"),
        POICategory(category: .brewery, displayName: "Brewery"),
        POICategory(category: .campground, displayName: "Campground"),
        POICategory(category: .museum, displayName: "Museum"),
        POICategory(category: .hiking, displayName: "Hiking"),
        POICategory(category: .golf, displayName: "Golf Course"),
        POICategory(category: .bakery, displayName: "Bakery"),
        POICategory(category: .castle, displayName: "Castle"),
        POICategory(category: .fairground, displayName: "Fairground"),
        POICategory(category: .nationalPark, displayName: "National Park"),
        POICategory(category: .park, displayName: "Park"),
        POICategory(category: .restaurant, displayName: "Restaurant"),
        POICategory(category: .stadium, displayName: "Stadium"),
        POICategory(category: .theater, displayName: "Theater"),
        POICategory(category: .winery, displayName: "Winery"),
        POICategory(category: .zoo, displayName: "Zoo")
    ]
    
    init(coordinate: CLLocationCoordinate2D? = nil) {
        if let coordinate = coordinate {
            self.userLocation = coordinate
            self.userRegion = MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: 5000,
                longitudinalMeters: 5000
            )
        } else {
            // Initialize userRegion with a default coordinate
            self.userRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                latitudinalMeters: 5000,
                longitudinalMeters: 5000
            )
            // Initialize userLocation as nil explicitly (optional, since it's already nil by default)
            self.userLocation = nil
        }
        
        // Call super.init() before using self
        super.init()
        
        if coordinate == nil {
            // Now it's safe to use self
            locationManager.delegate = self
            requestLocationAccess()
        }
        
        if userLocation != nil {
            fetchNearbyPlaces(category: selectedCategory?.category)
        }
    }
    
    
    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchNearbyPlaces(category: MKPointOfInterestCategory? = nil) {
        guard let userLocation = userLocation,
              !userLocation.latitude.isNaN,
              !userLocation.longitude.isNaN else { return }
        
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 3218, longitudinalMeters: 3218)
        let request = MKLocalPointsOfInterestRequest(coordinateRegion: region)
        
        if let category = category {
            request.pointOfInterestFilter = MKPointOfInterestFilter(including: [category])
        } else {
            request.pointOfInterestFilter = nil // Include all categories
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
