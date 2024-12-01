//
//  LocationManager.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import Foundation
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var region = MKCoordinateRegion()
    private let locationManager = CLLocationManager()
    private var lastKnownLocation: CLLocation?
    private let significantDistance: CLLocationDistance = 40233.6 // 25 miles in meters

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted.")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }

    private func incrementVisitCount(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            if let city = placemarks?.first?.locality {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .didVisitCity, object: nil, userInfo: ["cityName": city, "coordinate": location.coordinate])
                }
            }
        }
    }
}

extension Notification.Name {
    static let didVisitCity = Notification.Name("didVisitCity")
}
