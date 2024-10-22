//
//  HealthStatusView.swift
//  DailyActivityMonitorHomework1
//
//  Created by Divanshu Chauhan on 10/21/24.
//

import SwiftUI

struct HealthStatusView: View {
    @StateObject var viewModel = ActivityViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.healthStatus)
                .font(.title)
                .padding()
        }
        .navigationTitle("Health Status")
    }
}

