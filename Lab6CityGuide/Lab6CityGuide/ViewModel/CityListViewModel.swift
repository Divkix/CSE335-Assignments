//
//  CityListViewModel.swift
//  Lab6CityGuide
//
//  Created by Divanshu Chauhan on 10/27/24.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

class CityListViewModel: ObservableObject {
    @Published var cities: [City] = []
    
    func addCity(name: String, description: String) {
        geocodeCity(name: name) { coordinate in
            guard let coordinate = coordinate else {
                DispatchQueue.main.async {
                }
                return
            }

            self.generateMapSnapshot(coordinate: coordinate) { image in
                let newCity = City(name: name, image: image, description: description, coordinate: coordinate)
                DispatchQueue.main.async {
                    self.cities.append(newCity)
                }
            }
        }
    }

    private func geocodeCity(name: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            completion(placemarks?.first?.location?.coordinate)
        }
    }

    private func generateMapSnapshot(coordinate: CLLocationCoordinate2D, completion: @escaping (UIImage?) -> Void) {
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        options.size = CGSize(width: 200, height: 200)
        options.scale = UIScreen.main.scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            let image = snapshot.image
            completion(image)
        }
    }

    func deleteCity(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
    }
}
