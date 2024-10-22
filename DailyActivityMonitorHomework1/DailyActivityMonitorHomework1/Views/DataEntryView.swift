//
//  DataEntryView.swift
//  DailyActivityMonitorHomework1
//
//  Created by Divanshu Chauhan on 10/21/24.
//

import SwiftUI

struct DataEntryView: View {
    @ObservedObject var viewModel: ActivityViewModel
    @State private var walkingMinutes = ""
    @State private var runningMinutes = ""
    @State private var sleepingHours = ""
    @State private var foodCalories = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Enter Your Daily Activity")) {
                TextField("Walking (in minutes)", text: $walkingMinutes)
                    .keyboardType(.numberPad)
                TextField("Running (in minutes)", text: $runningMinutes)
                    .keyboardType(.numberPad)
                TextField("Sleeping (in hours)", text: $sleepingHours)
                    .keyboardType(.numberPad)
                TextField("Food Intake (in calories)", text: $foodCalories)
                    .keyboardType(.numberPad)
            }
            Button(action: {
                viewModel.insertActivity(walking: Int(walkingMinutes) ?? 0,
                                        running: Int(runningMinutes) ?? 0,
                                        sleeping: Int(sleepingHours) ?? 0,
                                        food: Int(foodCalories) ?? 0)
                walkingMinutes = ""
                runningMinutes = ""
                sleepingHours = ""
                foodCalories = ""
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Insert Data")
                    .foregroundColor(.green)
            }
            Button(action: {
                viewModel.clearData()
                walkingMinutes = ""
                runningMinutes = ""
                sleepingHours = ""
                foodCalories = ""
            }) {
                Text("Clear Data")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Daily Activity Monitoring System")
    }
}
