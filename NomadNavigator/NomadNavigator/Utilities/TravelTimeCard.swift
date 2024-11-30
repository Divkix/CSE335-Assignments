//
//  TravelTimeCard.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//


import SwiftUI

struct TravelTimeCard: View {
    let totalTravelTime: TimeInterval

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Estimated Travel Time")
                        .font(.headline)
                    Text(formattedTravelTime)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            .padding()
        }
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding([.leading, .trailing])
    }

    private var formattedTravelTime: String {
        let hours = Int(totalTravelTime) / 3600
        let minutes = (Int(totalTravelTime) % 3600) / 60
        if hours > 0 {
            return "\(hours) hr \(minutes) min"
        } else {
            return "\(minutes) min"
        }
    }
}
