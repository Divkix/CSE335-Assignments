//
//  AddTripView.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI
import MapKit

struct AddTripView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var location = ""
    @State private var detailedLocation = ""
    @StateObject private var searchCompleterVM = SearchCompleterViewModel()  // Use the search completer
    @State private var showSearchResults = false  // Boolean to control showing search results
    @State private var showAlert = false  // State for showing an alert for invalid date

    var onSave: (Trip) -> Void

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location")) {
                    TextField("Enter trip location", text: $location)

                    // Search bar for detailed location with autocomplete
                    TextField("Enter detailed address", text: $searchCompleterVM.queryFragment, onEditingChanged: { editing in
                        showSearchResults = editing && !searchCompleterVM.queryFragment.isEmpty
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 5)
                    .onChange(of: searchCompleterVM.queryFragment) { newValue in
                        if !newValue.isEmpty {
                            detailedLocation = newValue
                            showSearchResults = true
                        } else {
                            showSearchResults = false
                        }
                    }

                    // Display the search results below the TextField using ScrollView and VStack
                    if showSearchResults && !searchCompleterVM.searchResults.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(searchCompleterVM.searchResults, id: \.self) { result in
                                    Button(action: {
                                        selectSearchResult(result)
                                    }) {
                                        VStack(alignment: .leading) {
                                            Text(result.title)
                                                .font(.body)
                                            Text(result.subtitle)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.vertical, 5)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: 150)  // Restrict list height to prevent layout issues
                    }
                }

                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add New Trip")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if endDate >= startDate {
                            if !location.isEmpty {
                                let newTrip = Trip(startDate: startDate, endDate: endDate, location: location, detailedLocation: detailedLocation)
                                onSave(newTrip)
                                presentationMode.wrappedValue.dismiss()  // Dismiss view after saving
                            }
                        } else {
                            // Show alert if the end date is before the start date
                            showAlert = true
                        }
                    }
                    .disabled(location.isEmpty)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Date Selection"),
                    message: Text("End date cannot be before the start date. Please select valid dates."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // Helper method to handle selection of a search result
    private func selectSearchResult(_ result: MKLocalSearchCompletion) {
        detailedLocation = "\(result.title), \(result.subtitle)"
        searchCompleterVM.queryFragment = detailedLocation  // Set query fragment to keep consistency
        showSearchResults = false  // Dismiss search results after selection
    }
}
