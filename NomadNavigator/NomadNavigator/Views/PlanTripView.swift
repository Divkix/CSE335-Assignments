//
//  PlanTrip.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI
import MapKit

struct PlanTripView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var source: MKMapItem?
    @State private var destination: MKMapItem?
    @State private var stops: [MKMapItem?] = []
    @State private var routes: [MKRoute] = []
    @State private var isCalculatingRoute = false

    var body: some View {
        VStack {
            // Input Fields
            VStack(spacing: 10) {
                // Source Field
                LocationSearchBar(
                    placeholder: "Source",
                    mapItem: $source,
                    defaultMapItem: locationManager.currentLocationMapItem,
                    showCurrentLocationOption: true
                )
                
                // Destination Field with '+' button
                HStack {
                    LocationSearchBar(
                        placeholder: "Destination",
                        mapItem: $destination
                    )
                    if stops.count < 3 {
                        Button(action: {
                            stops.append(nil)
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .padding(.leading, 5)
                        }
                    }
                }
                
                // Stops Fields
                ForEach(0..<stops.count, id: \.self) { index in
                    LocationSearchBar(
                        placeholder: "Stop \(index + 1)",
                        mapItem: Binding(
                            get: { stops[index] },
                            set: { stops[index] = $0 }
                        )
                    )
                }
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding([.top, .horizontal])

            // "Plan Route" Button
            Button(action: {
                calculateRoute()
            }) {
                Text("Plan Route")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((source != nil && destination != nil) ? Color.blue : Color.gray)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .disabled(source == nil || destination == nil)


            // Map View
            ZStack {
                MapView(routes: $routes)
                    .edgesIgnoringSafeArea(.all)
                if isCalculatingRoute {
                    ProgressView("Calculating Route...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                }
            }

            // Travel Time Card
            if !routes.isEmpty {
                let totalTravelTime = routes.reduce(0) { $0 + $1.expectedTravelTime }
                TravelTimeCard(totalTravelTime: totalTravelTime)
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            if source == nil {
                source = locationManager.currentLocationMapItem
            }
        }
    }

    private func calculateRoute() {
        guard let source = source, let destination = destination else {
            routes = []
            return
        }

        isCalculatingRoute = true

        // Create an array of all points: source, stops, destination
        var allPoints = [source]
        allPoints.append(contentsOf: stops.compactMap { $0 })
        allPoints.append(destination)

        // Prepare to collect routes
        routes = []
        let group = DispatchGroup()

        for i in 0..<(allPoints.count - 1) {
            let request = MKDirections.Request()
            request.source = allPoints[i]
            request.destination = allPoints[i + 1]
            request.transportType = .automobile

            let directions = MKDirections(request: request)
            group.enter()
            directions.calculate { response, error in
                if let route = response?.routes.first {
                    DispatchQueue.main.async {
                        routes.append(route)
                    }
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            isCalculatingRoute = false
            if routes.isEmpty {
                // Handle the error (e.g., show an alert)
            } else {
                // Routes are updated, and the UI will refresh automatically
            }
        }
    }
}


#Preview {
    PlanTripView()
        .modelContainer(for: Item.self, inMemory: true)
}
