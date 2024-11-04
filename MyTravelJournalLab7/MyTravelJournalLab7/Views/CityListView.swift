//
//  CityListView.swift
//  MyTravelJournalLab7
//
//  Created by Divanshu Chauhan on 11/4/24.
//


import SwiftUI
import SwiftData

// view for city list
struct CityListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \City.name, order: .forward) private var cities: [City] // Updated line
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cities) { city in
                    NavigationLink(destination: CityDetailView(city: city)) {
                        HStack {
                            if let imageData = city.imageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            Text(city.name)
                                .font(.headline)
                        }
                    }
                }
                .onDelete(perform: deleteCities)
            }
            .navigationTitle("My Travel Journal")
            .navigationBarItems(
                leading: EditButton(),
                trailing: NavigationLink(destination: AddCityView()) {
                    Image(systemName: "plus")
                }
            )
        }
    }
    
    private func deleteCities(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let city = cities[index]
                modelContext.delete(city)
            }
        }
    }
}
