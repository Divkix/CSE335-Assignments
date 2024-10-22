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
        VStack {
            List(viewModel.activities) { activity in
                VStack(alignment: .leading) {
                    Text("Date: \(activity.date, formatter: viewModel.dateFormatter)")
                    Text("Walking: \(activity.walkingMinutes) minutes")
                    Text("Running: \(activity.runningMinutes) minutes")
                    Text("Sleeping: \(activity.sleepingHours) hours")
                    Text("Food Intake: \(activity.foodCalories) calories")
                }
            }
        }
        .navigationTitle("Activity Summary")
    }
}
