//
//  KnowAroundView.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI
import MapKit

struct KnowAroundView: View {
    @StateObject private var viewModel: KnowAroundViewModel
    @State private var selectedPlace: PlaceOfInterest?
    
    // Adjust the initializer to make 'place' optional
    init(place: Place? = nil) {
        _viewModel = StateObject(wrappedValue: KnowAroundViewModel(coordinate: place?.coordinate))
    }
    
    
    var body: some View {
        VStack {
            // Category Buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.allCategories) { category in
                        Button(action: {
                            viewModel.selectedCategory = category
                            viewModel.fetchNearbyPlaces(category: category.category)
                        }) {
                            Text(category.displayName)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(viewModel.selectedCategory?.id == category.id ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(viewModel.selectedCategory?.id == category.id ? .white : .primary)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Map View
            Map(coordinateRegion: $viewModel.userRegion, annotationItems: viewModel.places) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                        Text(place.name)
                            .font(.caption)
                            .fixedSize()
                    }
                    .onTapGesture {
                        selectedPlace = place
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.4)
            .onAppear {
                viewModel.requestLocationAccess()
                if viewModel.selectedCategory == nil {
                    viewModel.selectedCategory = viewModel.allCategories.first // 'All Categories'
                    viewModel.fetchNearbyPlaces(category: nil)
                }
            }
            
            // List of Places
            List(viewModel.places) { place in
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.headline)
                    Text(place.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    if let categoryName = place.categoryName {
                        Text("Category: \(categoryName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        viewModel.userRegion.center = place.coordinate
                    }
                }
            }
        }
        .navigationTitle("Know Around")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    KnowAroundView(place: Place(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))
}
