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

    @StateObject private var locationManager = LocationManager()
    @StateObject private var searchCompleterVM = SearchCompleterViewModel()
    @State private var overlayText = "Where to wander next?"
    @State private var showOverlayText = true
    @State private var selectedPlace: Place?
    @State private var isEditing = false
    @State private var region = MKCoordinateRegion()

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
                            if let location = location, region.center.latitude == 0 && region.center.longitude == 0 {
                                DispatchQueue.main.async {
                                    region = MKCoordinateRegion(
                                        center: location,
                                        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                                    )
                                }
                            }
                        }


                VStack {
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
                            .animation(.default)
                        }
                    }

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
                    }

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

                    VStack(spacing: 15) {
                        NavigationButton(destination: KnowAroundView(), label: "Know Around", systemImage: "airplane.departure")
                        NavigationButton(destination: WeatherView(place: selectedPlace ?? Place(coordinate: region.center)), label: "View Weather", systemImage: "cloud.sun")
                        NavigationButton(destination: MapWorldView(), label: "Event Map", systemImage: "map")
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }

    private func selectSearchResult(_ result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            DispatchQueue.main.async {
                if let response = response {
                    // Set the region to the bounding region from the search response
                    region = response.boundingRegion
                    if let coordinate = response.mapItems.first?.placemark.coordinate {
                        selectedPlace = Place(coordinate: coordinate)
                        saveSelectedLocation(coordinate: coordinate)
                    }
                    searchCompleterVM.queryFragment = result.title
                    isEditing = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                } else if let error = error {
                    print("Error during search: \(error.localizedDescription)")
                }
            }
        }
    }


    private func saveSelectedLocation(coordinate: CLLocationCoordinate2D) {
        // Remove existing selected location
        if let existingLocation = selectedLocations.first {
            modelContext.delete(existingLocation)
        }
        // Save new selected location
        let newLocation = SelectedLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        modelContext.insert(newLocation)
    }

    private func loadSavedLocation() {
        if let savedLocation = selectedLocations.first {
            let coordinate = CLLocationCoordinate2D(latitude: savedLocation.latitude, longitude: savedLocation.longitude)
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
            selectedPlace = Place(coordinate: coordinate)
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


// Placeholders
struct MapWorldView: View { var body: some View { Text("Plan Trip View") } }

#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}

