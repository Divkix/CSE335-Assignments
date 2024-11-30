//
//  WeatherView.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI

struct WeatherView: View {
//    @State private var locations: [String] = [""]
//    @State private var recommendations: String = ""
//    private let chatGPTService = ChatGPTService()

    var body: some View {
        VStack {
//            ForEach(0..<locations.count, id: \.self) { index in
//                TextField("Enter location", text: $locations[index])
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//            }
//            Button("Add Another Location") {
//                locations.append("")
//            }
//            Button("Get Recommendations") {
//                let prompt = "Plan the best visiting order for these locations: \(locations)"
//                chatGPTService.getRecommendations(prompt: prompt) { response in
//                    recommendations = response
//                }
//            }
//            Text(recommendations)
//                .padding()
        }
        .padding()
    }
}

#Preview {
    WeatherView()
        .modelContainer(for: Item.self, inMemory: true)
}
