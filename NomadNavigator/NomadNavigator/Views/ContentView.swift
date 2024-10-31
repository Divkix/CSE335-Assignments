//
//  ContentView.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 10/30/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = LocationViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var body: some View {
        VStack {
            // Title
            Text("Nomad Navigator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()
            
            // Map View
            if let location = viewModel.location {
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))))
                    .frame(height: 300)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .shadow(radius: 10)
            } else {
                Text("Fetching Location...")
                    .foregroundColor(.gray)
                    .frame(height: 300)
                    .cornerRadius(15)
                    .padding(.horizontal)
            }
            
            // Buttons
            HStack(spacing: 20) {
                Button(action: {
                    // Action for "Plan my Trip"
                }) {
                    HStack {
                        Text("✈️")
                        // Text("Plan my Trip")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 5)
                }
                
                Button(action: {
                    // Action for "Weather"
                }) {
                    HStack {
                        Text("☁️")
                        // Text("Weather")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 5)
                }
                
                Button(action: {
                    // Action for "Map View"
                }) {
                    HStack {
                        Text("🗺️")
                        // Text("Map View")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 5)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .onAppear {
            if let location = viewModel.location {
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
