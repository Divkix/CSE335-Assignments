//
//  MapView.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var routes: [MKRoute]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        if !routes.isEmpty {
            for route in routes {
                mapView.addOverlay(route.polyline)
            }
            // Adjust map region to fit all routes
            var rect = routes[0].polyline.boundingMapRect
            for route in routes.dropFirst() {
                rect = rect.union(route.polyline.boundingMapRect)
            }
            mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 50, bottom: 100, right: 50), animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

