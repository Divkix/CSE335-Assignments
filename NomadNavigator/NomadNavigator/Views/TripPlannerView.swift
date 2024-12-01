//
//  TripPlanner.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI
import MapKit

struct TripPlannerView: View {
    @State private var trips: [Trip] = []
    @State private var isAddingTrip = false
    @State private var selectedTrip: Trip? = nil
    @State private var sortOption: SortOption = .startDate  // Sort option state
    
    let tripsKey = "savedTrips"
    let sortOptionKey = "sortOption"

    enum SortOption: Int, Codable {
        case startDate, endDate, location
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(trips) { trip in
                    VStack(alignment: .leading) {
                        Text(trip.location)
                            .font(.headline)
                            .foregroundColor(colorForTrip(trip))
                        Text("Location: "+trip.detailedLocation)
                            .font(.subheadline)
                            .foregroundColor(colorForTrip(trip))
                        Text("From: \(formattedDate(trip.startDate)) To: \(formattedDate(trip.endDate))")
                            .font(.subheadline)
                            .foregroundColor(colorForTrip(trip))
                    }
                    .padding(5)
                    .background(colorForTrip(trip).opacity(0.1))
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedTrip = trip
                    }
                }
                .onDelete(perform: deleteTrip)
            }
            .navigationTitle("Trip Planner")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(action: {
                            sortOption = .startDate
                            saveSortOption()
                            sortTrips()
                        }) {
                            Label("Start Date", systemImage: "calendar")
                        }
                        
                        Button(action: {
                            sortOption = .endDate
                            saveSortOption()
                            sortTrips()
                        }) {
                            Label("End Date", systemImage: "calendar.badge.clock")
                        }
                        
                        Button(action: {
                            sortOption = .location
                            saveSortOption()
                            sortTrips()
                        }) {
                            Label("Location", systemImage: "map")
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingTrip = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingTrip) {
                AddTripView { newTrip in
                    trips.append(newTrip)
                    saveTrips()
                    sortTrips()  // Sort trips after adding a new trip
                    isAddingTrip = false
                }
            }
            .sheet(item: $selectedTrip) { trip in
                TripMapView(trip: trip)
            }
        }
        .onAppear(perform: {
            loadTrips()
            loadSortOption()  // Load the saved sort option
            sortTrips()  // Sort trips when loading the saved trips
        })
    }
    
    // Function to delete a trip
    func deleteTrip(at offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
        saveTrips()
    }
    
    // Function to format dates
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Function to determine the color for a trip based on its status (past, current, or future)
    func colorForTrip(_ trip: Trip) -> Color {
        let currentDate = Date()
        
        if trip.endDate < currentDate {
            // Past Trip
            return .red
        } else if trip.startDate <= currentDate && trip.endDate >= currentDate {
            // Current Trip
            return .green
        } else {
            // Future Trip
            return .blue
        }
    }
    
    // Function to sort trips based on the selected sort option
    func sortTrips() {
        switch sortOption {
        case .startDate:
            trips.sort { $0.startDate < $1.startDate }
        case .endDate:
            trips.sort { $0.endDate < $1.endDate }
        case .location:
            trips.sort { $0.location.lowercased() < $1.location.lowercased() }
        }
    }
    
    // MARK: - Persistence Functions
    
    // Save trips to UserDefaults
    func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: tripsKey)
        }
    }
    
    // Load trips from UserDefaults
    func loadTrips() {
        if let savedTrips = UserDefaults.standard.data(forKey: tripsKey),
           let decodedTrips = try? JSONDecoder().decode([Trip].self, from: savedTrips) {
            trips = decodedTrips
        }
    }
    
    // Save sort option to UserDefaults
    func saveSortOption() {
        UserDefaults.standard.set(sortOption.rawValue, forKey: sortOptionKey)
    }
    
    // Load sort option from UserDefaults
    func loadSortOption() {
        if let savedValue = UserDefaults.standard.value(forKey: sortOptionKey) as? Int,
           let loadedOption = SortOption(rawValue: savedValue) {
            sortOption = loadedOption
        }
    }
}
