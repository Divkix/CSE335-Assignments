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

    @StateObject private var weatherVM = WeatherViewModel() // Use the WeatherViewModel to fetch weather data
    
    // Environment variable to dismiss the view
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                // Trip Location Header
                VStack {
                    Text(trip.location)
                        .font(.largeTitle)
                        .padding()

                    Text("From: \(formattedDate(trip.startDate)) To: \(formattedDate(trip.endDate))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                }

                // Map View
                Map(coordinateRegion: $region, annotationItems: [trip]) { trip in
                    MapPin(coordinate: region.center, tint: .red)
                }
                .frame(height: 300)
                .cornerRadius(10)
                .padding()

                // Weather Information
                if let weather = weatherVM.weather {
                    VStack {
                        Text("Current Weather in \(weather.location.name), \(weather.location.region)")
                            .font(.headline)
                            .padding(.bottom, 5)

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Temperature: \(weather.current.temp_c, specifier: "%.1f")°C")
                                Text("Feels Like: \(weather.current.feelslike_c, specifier: "%.1f")°C")
                                Text("Condition: \(weather.current.condition.text)")
                                Text("Wind Speed: \(weather.current.wind_kph, specifier: "%.1f") kph")
                                Text("Humidity: \(weather.current.humidity)%")
                                Text("UV Index: \(weather.current.uv, specifier: "%.1f")")
                            }
                            .font(.body)
                            .padding()

                            Spacer()

                            if let iconUrl = URL(string: "https:\(weather.current.condition.icon)") {
                                AsyncImage(url: iconUrl) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 75, height: 75)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                } else {
                    Text("Loading weather data...")
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
            }
            .navigationTitle("Trip Location")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                geocodeAddressString(trip.detailedLocation) { coordinate in
                    if let coordinate = coordinate {
                        region.center = coordinate
                        let locationString = "\(coordinate.latitude),\(coordinate.longitude)"
                        weatherVM.fetchWeather(for: locationString)
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
