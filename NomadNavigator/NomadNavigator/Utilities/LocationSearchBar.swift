//
//  LocationSearchBar.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI
import MapKit

struct LocationSearchBar: View {
    let placeholder: String
    @Binding var mapItem: MKMapItem?
    var defaultMapItem: MKMapItem?
    var showCurrentLocationOption: Bool = false

    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching = false

    var body: some View {
        VStack(spacing: 0) {
            TextField(placeholder, text: $searchText, onEditingChanged: { isEditing in
                if isEditing {
                    isSearching = true
                }
            }, onCommit: {
                search()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: searchText) { _ in
                search()
            }

            if isSearching {
                List {
                    if showCurrentLocationOption && searchText.isEmpty {
                        Button(action: {
                            selectCurrentLocation()
                        }) {
                            Text("Current Location")
                        }
                    }
                    ForEach(searchResults.prefix(3), id: \.self) { item in
                        Button(action: {
                            selectMapItem(item)
                        }) {
                            Text(item.name ?? "Unknown")
                        }
                    }
                }
                .frame(maxHeight: 150)
            }
        }
        .onAppear {
            if let mapItem = mapItem {
                searchText = mapItem.name ?? ""
            } else if let defaultMapItem = defaultMapItem {
                mapItem = defaultMapItem
                searchText = defaultMapItem.name ?? "Current Location"
            }
        }
    }

    private func search() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let items = response?.mapItems {
                searchResults = items
            } else {
                searchResults = []
            }
        }
    }

    private func selectMapItem(_ item: MKMapItem) {
        mapItem = item
        searchText = item.name ?? ""
        searchResults = []
        isSearching = false
    }

    private func selectCurrentLocation() {
        if let currentLocation = defaultMapItem {
            mapItem = currentLocation
            searchText = "Current Location"
            searchResults = []
            isSearching = false
        }
    }
}
