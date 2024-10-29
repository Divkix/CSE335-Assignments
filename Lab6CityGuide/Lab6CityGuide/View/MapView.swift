//
//  MapView.swift
//  Lab6CityGuide
//
//  Created by Divanshu Chauhan on 10/27/24.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D?
    var annotations: [MKMapItem] = []

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        if let coordinate = coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: false)

            let cityAnnotation = MKPointAnnotation()
            cityAnnotation.coordinate = coordinate
            cityAnnotation.title = "City Location"
            mapView.addAnnotation(cityAnnotation)
        }

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)

        if let coordinate = coordinate {
            let cityAnnotation = MKPointAnnotation()
            cityAnnotation.coordinate = coordinate
            cityAnnotation.title = "City Location"
            uiView.addAnnotation(cityAnnotation)
        }

        for item in annotations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = item.placemark.coordinate
            annotation.title = item.name
            uiView.addAnnotation(annotation)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        // Implement MKMapViewDelegate methods if needed
    }
}
