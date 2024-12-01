//
//  WeatherResponse.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//


import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
}

struct CurrentWeather: Codable {
    let temp_c: Double
    let condition: Condition
    let wind_kph: Double
    let humidity: Int
    let uv: Double
    let is_day: Int
    let feelslike_c: Double
}

struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}
