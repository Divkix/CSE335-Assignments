//
//  HomeView.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI
import MapKit
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var selectedLocations: [SelectedLocation]
    
    @ObservedObject private var locationManager = LocationManager()
    @StateObject private var searchCompleterVM = SearchCompleterViewModel()
    @State private var overlayText = "Where to wander next?"
    @State private var showOverlayText = true
    @State private var selectedPlace: Place?
    @State private var isEditing = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
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
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .ignoresSafeArea()
                    .accentColor(.blue)
                    .onAppear {
                        locationManager.requestPermission()
                        loadSavedLocation()
                    }
                    .onReceive(locationManager.$userLocation) { location in
                        if let location = location, !location.latitude.isNaN, !location.longitude.isNaN {
                            DispatchQueue.main.async {
                                if region.center.latitude == 0 && region.center.longitude == 0 {
                                    region = MKCoordinateRegion(
                                        center: location,
                                        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                                    )
                                }
                                selectedPlace = Place(coordinate: location)
                            }
                        }
                    }
                
                VStack {
                    // Search Bar
                    HStack {
                        TextField("Search for a place", text: $searchCompleterVM.queryFragment, onEditingChanged: { editing in
                            isEditing = editing
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
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
                                    colors: [.white, .red],
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
                        NavigationButton(destination: MapWorldView(), label: "Event Map", systemImage: "map")
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getCurrentLocation() {
        if let location = locationManager.userLocation {
            DispatchQueue.main.async {
                region = MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                selectedPlace = Place(coordinate: location)
                saveSelectedLocation(coordinate: location)
            }
        } else {
            print("User location not available")
        }
    }
    
    private func selectSearchResult(_ result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let response = response {
                DispatchQueue.main.async {
                    region = response.boundingRegion
                    if let coordinate = response.mapItems.first?.placemark.coordinate,
                       !coordinate.latitude.isNaN, !coordinate.longitude.isNaN {
                        selectedPlace = Place(coordinate: coordinate)
                        saveSelectedLocation(coordinate: coordinate)
                    }
                    searchCompleterVM.queryFragment = result.title
                    isEditing = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            } else if let error = error {
                print("Error during search: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveSelectedLocation(coordinate: CLLocationCoordinate2D) {
        // Remove all existing selected locations
        for location in selectedLocations {
            modelContext.delete(location)
        }
        // Save new selected location
        let newLocation = SelectedLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        modelContext.insert(newLocation)
        
        // Persist the changes
        do {
            try modelContext.save()
            print("Selected location saved successfully.")
        } catch {
            print("Failed to save selected location: \(error.localizedDescription)")
        }
    }
    
    private func loadSavedLocation() {
        if let savedLocation = selectedLocations.first {
            let coordinate = CLLocationCoordinate2D(latitude: savedLocation.latitude, longitude: savedLocation.longitude)
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
            selectedPlace = Place(coordinate: coordinate)
            print("Loaded saved location: \(coordinate.latitude), \(coordinate.longitude)")
        } else {
            // Optionally, set a default region if no saved location exists
            let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
            region = MKCoordinateRegion(
                center: defaultCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
            selectedPlace = Place(coordinate: defaultCoordinate)
            print("No saved location found. Set to default location.")
        }
    }
    
    // MARK: - NavigationButton View
    
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
    
    struct MapWorldView: View { var body: some View { Text("Plan Trip View") } }
}


// MARK: - Preview

#Preview {
    HomeView()
        .modelContainer(for: SelectedLocation.self, inMemory: true)
}
