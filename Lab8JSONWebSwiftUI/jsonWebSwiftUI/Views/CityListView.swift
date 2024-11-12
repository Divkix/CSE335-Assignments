//
//  CityListView.swift
//  jsonWebSwiftUI
//
//  Created by Divanshu Chauhan on 11/7/24.
//


import SwiftUI

struct CityListView: View {
    @StateObject private var viewModel = CityListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.cities) { city in
                NavigationLink(destination: CityDetailView(city: city)) {
                    VStack(alignment: .leading) {
                        Text(city.name)
                            .font(.headline)
                        Text("\(city.countrycode)\nPopulation: \(city.population)\nLatitude: \(city.lat)\nLongitude: \(city.lng)\nGeonameID: \(city.geonameId)")
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Cities")
            .onAppear {
                viewModel.fetchCities(north: 49.1, south: 48.5, east: 2.9, west: 2.2)
            }
        }
    }
}
