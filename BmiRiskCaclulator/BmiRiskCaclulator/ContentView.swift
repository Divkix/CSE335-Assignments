//
//  ContentView.swift
//  BmiRiskCaclulator
//
//  Name:        Divanshu Chauhan
//  Date:        10/11/2024
//  Description: An app to calculate the BMI of a person based on their
//               height (in inches), weight (in pounds), waist
//               circumference (in inches) and gender.
//

import SwiftUI

struct ContentView: View {
    // Define necessary variables
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var waist: String = ""
    @State private var riskDetermined: String = "Click Button to Calculate"
    @State private var gender: String = "Male"
    
    var body: some View {
        VStack {
            
            // App Intro
            Image(systemName: "person")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("BMI Risk Calculator")
            
            // Spacer for aesthetics
            Spacer()
                .frame(height: 50)
            
            // Height Input
            HStack {
                Text("Height (in inches): ")
                TextField(
                    "Enter Height here",
                    text: $height
                )
            }
            
            // Weight Input
            HStack {
                Text("Weight (in pounds): ")
                TextField(
                    "Enter Weight here",
                    text: $weight
                )
            }
            
            // Waist Circumference Input
            HStack {
                Text("Waist (in inches): ")
                TextField(
                    "Enter Waist here",
                    text: $waist
                )
            }
            
            // Gender Selection
            HStack {
                Text("Gender: ")
                // Use a Picker to select the gender
                Picker("Gender", selection: $gender) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                }
                .pickerStyle(SegmentedPickerStyle())
            }.padding()
            
            // Spacer for aesthetics
            Spacer()
                .frame(height: 40)
            
            // Button to perform calculation
            Button(action: {
                riskDetermined = determineRisk(weight: weight, height: height, waist: waist, gender: gender)
            }) {
                Text("Calculate Risk")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            // Spacer for aesthetics
            Spacer()
                .frame(height: 50)
            
            // Text for risk determination
            Text(riskDetermined)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(colorForRisk(risk: riskDetermined))
                .font(.system(size: 30))
        }
        .padding()
    }
    
    // Function used to determine the risk based on weight, height, waist circumfernce and gender
    // Returns a string with risk
    func determineRisk(weight: String, height: String, waist: String, gender: String) -> String {
        // Convert all strings to Float for calculation
        guard let weightFloat = Float(weight), let heightFloat = Float(height), let waist = Float(waist) else {
            return "Invalid input"
        }

        // Calculate BMI
        let bmi = (weightFloat / (heightFloat * heightFloat)) * 703

        // Return string based on bmi
        switch bmi {
        case ..<18.5:
            return "Low"
        case 18.5..<24.9:
            return "Normal"
        case 25..<29.9:
            // "Overweight"
            if (gender == "Male" && waist > 40) || (gender == "Female" && waist > 35) {
                // Edge case as defined in project spec
                return "High"
            }
            return "Increased"
        case 30..<34.9:
            // "Obesity Type I"
            if (gender == "Male" && waist > 40) || (gender == "Female" && waist > 35){
                // Edge case as defined in project spec
                return "Very High"
            }
            return "High"
        case 35..<39.9:
            // "Obesity Type II"
            return "Very High"
        case 40...:
            // "Obesity Type III"
            return "Extremely High"
        default:
            // Default if values are invalid
            return "Invalid BMI"
        }
    }
    
    // function to return color based on string match
    func colorForRisk(risk: String) -> Color {
        switch risk {
        case "Increased":
            return Color.yellow
        case "High":
            return Color.purple
        case "Very High":
            return Color.orange
        case "Extremely High":
            return Color.red
        default:
            return Color.black
        }
    }
}

#Preview {
    ContentView()
}
