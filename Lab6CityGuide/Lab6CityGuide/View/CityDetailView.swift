//
//  CityDetailView.swift
//  Lab6CityGuide
//
//  Created by Divanshu Chauhan on 10/27/24.
//

import SwiftUI
import MapKit

struct CityDetailView: View {
    @ObservedObject var viewModel: CityDetailViewModel
    @State private var searchQuery = ""

    init(city: City) {
        self.viewModel = CityDetailViewModel(city: city)
    }

    var body: some View {
        VStack {
            // Display the city name as the title
            Text(viewModel.city.name)
                .font(.largeTitle)
                .padding(.top)

            // Map view showing the city's location
            MapView(coordinate: viewModel.city.coordinate, annotations: viewModel.placesOfInterest)
                .frame(height: 300)

            // Display longitude and latitude
            VStack(alignment: .leading, spacing: 8) {
                Text("Longitude: \(viewModel.city.coordinate?.longitude ?? 0.0)")
                Text("Latitude: \(viewModel.city.coordinate?.latitude ?? 0.0)")
            }
            .padding()

            // Search bar for searching places
            HStack {
                TextField("Search Places", text: $searchQuery, onCommit: {
                    viewModel.searchPlaces(query: searchQuery)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

                Button(action: {
                    viewModel.searchPlaces(query: searchQuery)
                }) {
                    Image(systemName: "magnifyingglass")
                }
                .padding(.trailing)
            }

            // List of search results
            if !viewModel.placesOfInterest.isEmpty {
                List(viewModel.placesOfInterest, id: \.self) { item in
                    VStack(alignment: .leading) {
                        Text(item.name ?? "Unknown")
                            .font(.headline)
                        if let address = item.placemark.title {
                            Text(address)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        if let distance = distanceFromCity(to: item) {
                            Text(String(format: "Distance: %.2f km", distance / 1000))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            } else {
                Spacer()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }

    func distanceFromCity(to item: MKMapItem) -> Double? {
        guard let cityCoordinate = viewModel.city.coordinate else {
            return nil
        }
        let cityLocation = CLLocation(latitude: cityCoordinate.latitude, longitude: cityCoordinate.longitude)
        let itemLocation = item.placemark.location
        return itemLocation?.distance(from: cityLocation)
    }
}
