//
//  ContentView.swift
//  myWeightLab2
//
//  Name:         Divanshu Chauhan
//  Date:         09/18/2024
//  Description:  An app using NavigationStack to change to different view and pass on the weight
//                variable to next view, by entering the weight in Kg in the text field, the app
//                shows the weight on moon and jupiter.
//


import SwiftUI

struct ContentView: View {
    // Variables to store the earthWeight and the navigation path.
    @State private var earthWeight: Double = 0.0
    @State private var path = NavigationPath()  // Manages navigation stack for the app.
    @State private var comingFrom: String? = nil  // Tracks where the user is coming from (Moon or Jupiter).

    var body: some View {
        // Main vertical stack for the Earth view layout.
        NavigationStack(path: $path) {
            VStack {
                Text("Earth View")
                    .font(.largeTitle)
                    .padding(.bottom)

                // TextField to take the user’s weight on Earth.
                TextField("Enter your weight on Earth", value: $earthWeight, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Display message if coming from the Moon or Jupiter.
                if let comingFrom = comingFrom {
                    Text("Coming from the \(comingFrom)")  // Show where the user is coming from.
                        .foregroundColor(.gray)  // Gray color for the message.
                        .padding(.bottom)
                }

                // Button that navigates to the MoonView when tapped.
                Button("Go to Moon") {
                    path.append("MoonView")  // Add MoonView to the navigation path.
                    comingFrom = nil // Clear message when going to the Moon.
                }
                .padding()

                // Button that navigates to the JupiterView when tapped.
                Button("Go to Jupiter") {
                    path.append("JupiterView")  // Add JupiterView to the navigation path.
                    comingFrom = nil // Clear message when going to Jupiter.
                }
                .padding()
            }
            .navigationTitle("Earth")  // Title for Earth view.
            // Define what happens when navigating to different views.
            .navigationDestination(for: String.self) { view in
                switch view {
                case "MoonView":  // Navigate to MoonView and pass the earthWeight.
                    MoonView(earthWeight: earthWeight, path: $path, comingFromEarth: true, onBackToEarth: { comingFrom = "Moon" })
                case "JupiterView": // Navigate to JupiterView and pass both earthWeight and moonWeight.
                    JupiterView(earthWeight: earthWeight, moonWeight: earthWeight / 6, path: $path, onBackToMoon: { comingFrom = "Jupiter" }, onBackToEarth: { comingFrom = "Jupiter" })
                default:
                    EmptyView()
                }
            }
        }
    }
}

// MoonView - Represents the Moon view.
// This view shows the user’s weight on Earth and Moon, and provides navigation to Jupiter or back to Earth.
struct MoonView: View {
    let earthWeight: Double  // The user's weight on earth coming from EarthView.
    @Binding var path: NavigationPath  // Binding to the shared navigation path.
    var comingFromEarth: Bool // Used to track whether the user is coming directly from Earth.
    let onBackToEarth: () -> Void  // Closure to set the message when returning to Earth.

    var body: some View {
        let moonWeight = earthWeight / 6  // Calculate the weight on the Moon, 1/6 of earth's weight.

        VStack {
            Text("Moon View")  // Title of the current view.
                .font(.largeTitle)
                .padding(.bottom)

            // Display earth and moon weights.
            Text("Earth Weight: \(earthWeight, specifier: "%.2f") kg")
            Text("Moon Weight: \(moonWeight, specifier: "%.2f") kg")
            Text("I feel much lighter!")
                .padding(.bottom)

            // If user is not coming from Earth, then they are coming from Jupiter.
            if !comingFromEarth {
                Text("Coming from Jupiter")
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }

            // Button to navigate to Jupiter.
            Button("Go to Jupiter") {
                path.append("JupiterView")
            }
            .padding()

            // Button to navigate back to Earth (removes the last view in the stack).
            Button("Back to Earth") {
                onBackToEarth()  // Set the message as "Coming from the Moon" when navigating back to Earth.
                path.removeLast()
            }
            .padding()
        }
        // Title for Moon
        .navigationTitle("Moon")
    }
}

// JupiterView - Represents the Jupiter view.
// This view shows the user’s weight on Earth, Moon, and Jupiter, and provides navigation back to Moon or Earth.
struct JupiterView: View {
    let earthWeight: Double
    let moonWeight: Double
    @Binding var path: NavigationPath
    let onBackToMoon: () -> Void  // Closure to set the message when returning to the Moon.
    let onBackToEarth: () -> Void  // Closure to set the message when returning to Earth.

    var body: some View {
        let jupiterWeight = earthWeight * 2.4

        VStack {
            Text("Jupiter View")
                .font(.largeTitle)
                .padding(.bottom)

            Text("Earth Weight: \(earthWeight, specifier: "%.2f") kg")  // The weight on Earth in 0.00 format.
            Text("Moon Weight: \(moonWeight, specifier: "%.2f") kg")  // The weight on Moon in 0.00 format, 1/6 of earth weight.
            Text("Jupiter Weight: \(jupiterWeight, specifier: "%.2f") kg")  // The weight on Jupiter in 0.00 format, 2.4 times of earth weight.
            Text("I feel heavier!")  // Display message about feeling heavier.
                .padding(.bottom)

            // Button to go back to Moon.
            Button("Back to Moon") {
                onBackToMoon()  // Set the message as "Coming from Jupiter" when navigating back to Moon.
                path.removeLast()  // Back to Moon, remove the last view from stack.
            }
            .padding()

            // Button to go back to Earth.
            Button("Back to Earth") {
                onBackToEarth()  // Set the message as "Coming from Jupiter" when navigating back to Earth.
                path.removeLast(2)  // Back to Earth, remove the last 2 views from stack.
            }
            .padding()
        }
        // Title for Jupiter
        .navigationTitle("Jupiter")
    }
}

// Preview for SwiftUI canvas to show the starting view (EarthView).
#Preview {
    ContentView()
}
