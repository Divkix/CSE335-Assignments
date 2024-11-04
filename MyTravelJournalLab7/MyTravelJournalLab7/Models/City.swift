//
//  City.swift
//  MyTravelJournalLab7
//
//  Created by Divanshu Chauhan on 11/4/24.
//


import SwiftData
import CoreData

@Model
class City: Identifiable {
    var id: UUID = UUID()  // Unique identifier
    var name: String  // Name of City
    var cityDescription: String  // Description of City
    var imageData: Data?  // Image of city
    
    // initialize the city details
    init(name: String, cityDescription: String, imageData: Data? = nil) {
        self.name = name  // name of city
        self.cityDescription = cityDescription  // description of city
        self.imageData = imageData  // image for city
    }
}
