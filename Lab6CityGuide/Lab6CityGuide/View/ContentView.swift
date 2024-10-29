//
//  ContentView.swift
//  Lab6CityGuide
//
//  Created by Divanshu Chauhan on 10/27/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var cityListVM = CityListViewModel()

    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.systemTeal
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = .white
    }

    var body: some View {
        NavigationView {
            CityListView()
                .environmentObject(cityListVM)
                .navigationTitle("Favorite Places")
        }
    }
}

#Preview {
    ContentView()
}
