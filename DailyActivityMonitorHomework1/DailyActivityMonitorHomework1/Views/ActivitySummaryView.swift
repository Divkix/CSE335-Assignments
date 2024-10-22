//
//  ActivitySummaryView.swift
//  DailyActivityMonitorHomework1
//
//  Created by Divanshu Chauhan on 10/21/24.
//

import SwiftUI

struct ActivitySummaryView: View {
    @ObservedObject var viewModel: ActivityViewModel

    var body: some View {
        ZStack {
            Color.white.opacity(0.95)
                .ignoresSafeArea()

            List {
                ForEach(viewModel.activities) { activity in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Date: \(activity.formattedDate)")
                            .font(.headline)
                        Text("Walking: \(activity.walkingMinutes) minutes")
                            .font(.subheadline)
                        Text("Running: \(activity.runningMinutes) minutes")
                            .font(.subheadline)
                        Text("Sleeping: \(activity.sleepingHours) hours")
                            .font(.subheadline)
                        Text("Food Intake: \(activity.foodCalories) calories")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .listRowBackground(Color.clear) // Remove default row background
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Activity Summary")
        }
    }
}
