//
//  CityListView.swift
//  Lab6CityGuide
//
//  Created by Divanshu Chauhan on 10/27/24.
//

import SwiftUI

struct CityListView: View {
    @EnvironmentObject var cityListVM: CityListViewModel
    @State private var showingAddCity = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            List {
                ForEach(cityListVM.cities) { city in
                    NavigationLink(destination: CityDetailView(city: city)) {
                        CityRowView(city: city)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 4)
                    }
                    .listRowBackground(Color.clear)
                }
                .onDelete(perform: cityListVM.deleteCity)
            }
            .listStyle(PlainListStyle())
            .navigationBarItems(trailing: Button(action: {
                showingAddCity.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddCity) {
                AddCityView()
                    .environmentObject(cityListVM)
            }
        }
        .navigationTitle("Favorite Places")
    }
}
