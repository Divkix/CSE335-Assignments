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
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.white, Color.blue.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea() // Extend gradient to full screen

            VStack(spacing: 20) {
                Spacer() // Push content to center vertically

                NavigationLink(destination: DataEntryView(viewModel: viewModel)) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                        Text("Enter Data")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }

                NavigationLink(destination: ActivitySummaryView(viewModel: viewModel)) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .font(.title)
                            .foregroundColor(.white)
                        Text("View My Activity")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }

                NavigationLink(destination: HealthStatusView(viewModel: viewModel)) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundColor(.white)
                        Text("How am I Doing?")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.pink, .red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }

                Spacer() // Push content to center vertically
            }
            .navigationTitle("Daily Activity Monitoring System")
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure VStack fills the space
        }
    }
}
