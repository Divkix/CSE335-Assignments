//
//  HealthStatusView.swift
//  DailyActivityMonitorHomework1
//
//  Created by Divanshu Chauhan on 10/21/24.
//

import SwiftUI

struct HealthStatusView: View {
    @ObservedObject var viewModel: ActivityViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.white, Color.blue.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                Text(viewModel.healthStatus)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)

                Spacer()
            }
            .navigationTitle("Health Status")
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
