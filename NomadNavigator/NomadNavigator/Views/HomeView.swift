//
//  HomeView.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var overlayText = "Where to wander next?"
    @State private var showOverlayText = true

    private let phrases = [
        "Where to wander next?",
        "Ready for a new adventure?",
        "Discover new horizons!",
        "Plan your next journey!"
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                    .ignoresSafeArea()
                    .accentColor(.blue)
                    .onAppear {
                        locationManager.requestPermission()
                    }

                VStack {
                    if showOverlayText {
                        Text(overlayText)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(radius: 10)
                            .padding(.top, 50)
                    }

                    Spacer()

                    VStack(spacing: 15) {
                        NavigationButton(destination: PlanTripView(), label: "Plan Trip", systemImage: "airplane.departure")
                        NavigationButton(destination: WeatherView(), label: "View Weather", systemImage: "cloud.sun")
                        NavigationButton(destination: MapWorldView(), label: "Access Map", systemImage: "map")
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }

    private func cycleOverlayText() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 1)) {
                showOverlayText = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                overlayText = phrases.randomElement() ?? overlayText
                withAnimation(.easeInOut(duration: 1)) {
                    showOverlayText = true
                }
                cycleOverlayText()
            }
        }
    }
}

struct NavigationButton<Destination: View>: View {
    let destination: Destination
    let label: String
    let systemImage: String

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundColor(.blue)
                Text(label)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.85))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}

