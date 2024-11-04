//
//  MyTravelJournalLab7App.swift
//  MyTravelJournalLab7
//
//  Created by Divanshu Chauhan on 11/4/24.
//

import SwiftUI
import SwiftData

@main
struct MyTravelJournalLab7App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [City.self])
    }
}
