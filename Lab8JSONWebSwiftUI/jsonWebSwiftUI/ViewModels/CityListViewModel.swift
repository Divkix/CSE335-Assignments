//
//  CityListViewModel.swift
//  jsonWebSwiftUI
//
//  Created by Divanshu Chauhan on 11/7/24.
//

import Foundation
import Combine

class CityListViewModel: ObservableObject {
    @Published var cities: [City] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchCities(north: Double, south: Double, east: Double, west: Double) {
        let username = "divkix" // Replace with your username
        let urlString = "http://api.geonames.org/citiesJSON?north=\(north)&south=\(south)&east=\(east)&west=\(west)&maxRows=10&username=\(username)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                print("Raw JSON:", String(data: data, encoding: .utf8) ?? "No data") // Debugging output
                return data
            }
            .decode(type: GeonamesResponse.self, decoder: JSONDecoder())
            .map { $0.geonames }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedCities in
                self?.cities = fetchedCities
                print("Cities fetched:", fetchedCities) // Should display the list of cities
            }
            .store(in: &cancellables)
    }
}
