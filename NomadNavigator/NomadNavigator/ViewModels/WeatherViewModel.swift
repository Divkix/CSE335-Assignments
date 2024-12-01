//
//  WeatherViewModel.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//


import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    private var cancellable: AnyCancellable?
    private let apiKey = "5b3e5560e5fe4f59ab7195311243011"
    
    func fetchWeather(for location: String) {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(location)"
        
        guard let url = URL(string: urlString) else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    // Request completed successfully
                    break
                case .failure(let error):
                    print("Error fetching weather data: \(error.localizedDescription)")
                    self?.weather = nil
                }
            }, receiveValue: { [weak self] weatherResponse in
                self?.weather = weatherResponse
            })
    }
}
