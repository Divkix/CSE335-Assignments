//
//  CityViewModel.swift
//  MyTravelJournalLab7
//
//  Created by Divanshu Chauhan on 11/4/24.
//


import SwiftUI
import SwiftData

class CityViewModel: ObservableObject {
    @Environment(\.modelContext) private var modelContext
    @Published var cities: [City] = []
    
    init() {
        fetchCities()  //  fetch cities when initializing
    }
    
    // function for fetchCities
    func fetchCities() {
        let fetchDescriptor = FetchDescriptor<City>()
        do {
            cities = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch cities: \(error)")
        }
    }
    
    // function to add city
    func addCity(name: String, cityDescription: String, imageData: Data?) {
        let newCity = City(name: name, cityDescription: cityDescription, imageData: imageData)
        modelContext.insert(newCity)
        fetchCities()
    }
    
    // function to delete cities
    func deleteCities(at offsets: IndexSet) {
        for index in offsets {
            let city = cities[index]
            modelContext.delete(city)
        }
        fetchCities()
    }
}
