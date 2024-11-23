//
//  HomeView.swift
//  DailyActivityMonitorHomework2
//
//  Created by Your Name on 10/21/24.
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
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

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

                Spacer()
            }
            .navigationTitle("Daily Activity Monitoring System")
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
