//
//  TripMapView.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//


import SwiftUI
import MapKit

struct TripMapView: View {
    var trip: Trip
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // Environment variable to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text(trip.location)
                    .font(.largeTitle)
                    .padding()
                Text("From: \(formattedDate(trip.startDate)) To: \(formattedDate(trip.endDate))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                Map(coordinateRegion: $region, annotationItems: [trip]) { trip in
                    MapPin(coordinate: region.center, tint: .red)
                }
                .onAppear {
                    geocodeAddressString(trip.detailedLocation) { coordinate in
                        if let coordinate = coordinate {
                            region.center = coordinate
                        }
                    }
                }
            }
            .navigationTitle("Trip Location")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    // Geocoding function to get coordinates from address
    func geocodeAddressString(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate)
            } else {
                completion(nil)
            }
        }
    }
    
    // Date formatting function
        func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
}
