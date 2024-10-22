//
//  HomeView.swift
//  DailyActivityMonitorHomework1
//
//  Created by Divanshu Chauhan on 10/21/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        VStack {
            NavigationLink(destination: DataEntryView(viewModel: viewModel)) {
                Text("Data Entry View")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            NavigationLink(destination: ActivitySummaryView(viewModel: viewModel)) {
                Text("View My Activity")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            NavigationLink(destination: HealthStatusView(viewModel: viewModel)) {
                Text("How am I Doing?")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Daily Activity Monitoring System")
        .padding()
    }
}
