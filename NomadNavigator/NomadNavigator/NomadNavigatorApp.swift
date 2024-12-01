//
//  NomadNavigatorApp.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI
import SwiftData

@main
struct NomadNavigatorApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(for: SelectedLocation.self)
        }
    }
}

