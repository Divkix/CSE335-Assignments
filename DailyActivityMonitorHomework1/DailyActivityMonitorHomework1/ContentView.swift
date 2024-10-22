//
//  ContentView.swift
//  DailyActivityMonitorHomework1
//
//  Created by Divanshu Chauhan on 10/21/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ActivityViewModel()
    
    var body: some View {
        NavigationView {
            HomeView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
