//
//  HomeView.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var searchCompleterVM = SearchCompleterViewModel()
    
    @State private var overlayText = "Where to wander next?"
    @State private var showOverlayText = true
    @State private var selectedPlace: Place?
    @State private var isEditing = false
    @State private var isLoading = true // Track if location is loading
    @State private var isSearchLocationSet = false // Track if a search result is being used

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3318, longitude: -122.0312), // Placeholder location
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    private let phrases = [
        "Where to wander next?",
        "Ready for a new adventure?",
        "Discover new horizons!",
        "Plan your next journey!"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    // Loading Screen
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Loading your location...")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.9))
                } else {
                    // Map View
                    Map(coordinateRegion: $region, showsUserLocation: true)
                        .ignoresSafeArea()
                        .accentColor(.blue)
                        .onAppear {
                            overlayText = phrases.randomElement() ?? overlayText
                        }
                        .onReceive(locationManager.$userLocation) { location in
                            if let location = location, !location.latitude.isNaN, !location.longitude.isNaN, !isSearchLocationSet {
                                updateRegion(with: location)
                            }
                        }
                    
                    VStack {
                        // Search Bar
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                                    .padding(.leading, 40)
                                TextField("Search for a city or place", text: $searchCompleterVM.queryFragment, onEditingChanged: { editing in
                                    isEditing = editing
                                })
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(12)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                            
                            if isEditing {
                                Button(action: {
                                    searchCompleterVM.queryFragment = ""
                                    isEditing = false
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }) {
                                    Text("Cancel")
                                }
                                .padding(.trailing, 10)
                                .transition(.move(edge: .trailing))
                                .animation(.default, value: isEditing)
                            }
                        }
                        
                        // Search Results
                        if !searchCompleterVM.searchResults.isEmpty && isEditing {
                            List(searchCompleterVM.searchResults, id: \.self) { result in
                                Button(action: {
                                    selectSearchResult(result)
                                }) {
                                    VStack(alignment: .leading) {
                                        Text(result.title)
                                        Text(result.subtitle)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .frame(maxHeight: 200)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        // Overlay Text
                        if showOverlayText {
                            Text(overlayText)
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.black, .red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(radius: 10)
                                .padding(.top, 10)
                        }
                        
                        Spacer()
                        
                        // Current Location Button
                        HStack {
                            Button(action: {
                                getCurrentLocation()
                            }) {
                                HStack {
                                    Image(systemName: "location.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    Text("Current Location")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                .padding()
                                .background(Color.white.opacity(0.85))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                            }
                            .padding(.leading)
                            
                            Spacer()
                        }
                        
                        // Navigation Buttons
                        VStack(spacing: 15) {
                            NavigationButton(destination: KnowAroundView(place: selectedPlace ?? Place(coordinate: region.center)), label: "Know Around", systemImage: "airplane.departure")
                            NavigationButton(destination: WeatherView(place: selectedPlace ?? Place(coordinate: region.center)), label: "View Weather", systemImage: "cloud.sun")
                            NavigationButton(destination: TripPlannerView(), label: "Plan a trip", systemImage: "map")
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .onAppear {
                loadCurrentLocation()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadCurrentLocation() {
        isLoading = true // Start loading
        
        locationManager.requestPermission()
        if let userLocation = locationManager.userLocation, !isSearchLocationSet {
            updateRegion(with: userLocation)
        } else {
            print("Waiting for user location...")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
        }
    }
    
    private func getCurrentLocation() {
        if let location = locationManager.userLocation {
            DispatchQueue.main.async {
                isSearchLocationSet = false // Reset to use current location
                updateRegion(with: location)
            }
        } else {
            print("User location is not available.")
        }
    }
    
    private func updateRegion(with location: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            selectedPlace = Place(coordinate: location)
        }
    }
    
    private func selectSearchResult(_ result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                region = response.boundingRegion
                if let coordinate = response.mapItems.first?.placemark.coordinate {
                    selectedPlace = Place(coordinate: coordinate)
                    isSearchLocationSet = true // Persist search location for the session
                    isEditing = false // Dismiss the search dropdown
                }
            }
        }
    }
    
    struct NavigationButton<Destination: View>: View {
        let destination: Destination
        let label: String
        let systemImage: String
        
        var body: some View {
            NavigationLink(destination: destination) {
                HStack {
                    Image(systemName: systemImage)
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text(label)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.85))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal)
        }
    }
}
