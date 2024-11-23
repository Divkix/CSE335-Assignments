//
//  ActivitySummaryView.swift
//  DailyActivityMonitorHomework2
//
//  Created by Your Name on 10/21/24.
//

import SwiftUI

struct ActivitySummaryView: View {
    @ObservedObject var viewModel: ActivityViewModel
    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    @State private var endDate: Date = Date()

    var body: some View {
        ZStack {
            Color.white.opacity(0.95)
                .ignoresSafeArea()

            VStack {
                // Date Range Selection
                HStack {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .labelsHidden()
                    Text("to")
                    DatePicker("End Date", selection: $endDate, in: startDate...Date(), displayedComponents: .date)
                        .labelsHidden()
                }
                .padding()

                Button(action: {
                    viewModel.fetchActivities(from: startDate, to: endDate)
                }) {
                    Text("Show Activities")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

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
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Activity Summary")
        }
    }
}
