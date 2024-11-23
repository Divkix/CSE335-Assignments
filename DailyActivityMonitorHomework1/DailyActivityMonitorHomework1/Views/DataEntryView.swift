//
//  DataEntryView.swift
//  DailyActivityMonitorHomework2
//
//  Created by Your Name on 10/21/24.
//

import SwiftUI

struct DataEntryView: View {
    @ObservedObject var viewModel: ActivityViewModel
    @State private var selectedDate = Date()
    @State private var walkingMinutes = ""
    @State private var runningMinutes = ""
    @State private var sleepingHours = ""
    @State private var foodCalories = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                
                Text("Enter Your Daily Activity")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
                
                // Date Picker
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal)
                .labelsHidden()
                
                // Input Fields
                Group {
                    CustomNumericInputField(
                        iconName: "figure.walk",
                        placeholder: "Walking (in minutes)",
                        text: $walkingMinutes
                    )
                    CustomNumericInputField(
                        iconName: "figure.run",
                        placeholder: "Running (in minutes)",
                        text: $runningMinutes
                    )
                    CustomNumericInputField(
                        iconName: "bed.double.fill",
                        placeholder: "Sleeping (in hours)",
                        text: $sleepingHours
                    )
                    CustomNumericInputField(
                        iconName: "fork.knife",
                        placeholder: "Food Intake (in calories)",
                        text: $foodCalories
                    )
                }
                .padding(.horizontal)
                
                // Insert Data Button
                Button(action: {
                    if validateInputs() {
                        viewModel.insertActivity(
                            date: selectedDate,
                            walking: Int(walkingMinutes) ?? 0,
                            running: Int(runningMinutes) ?? 0,
                            sleeping: Int(sleepingHours) ?? 0,
                            food: Int(foodCalories) ?? 0
                        )
                        resetFields()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("Insert Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                // Clear Data Button
                Button(action: {
                    viewModel.clearData()
                    resetFields()
                }) {
                    Text("Clear Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
            }
            .navigationTitle("Daily Activity Monitoring System")
            .padding()
        }
    }
    
    // Validation Function
    func validateInputs() -> Bool {
        if walkingMinutes.isEmpty || runningMinutes.isEmpty || sleepingHours.isEmpty || foodCalories.isEmpty {
            alertMessage = "Please fill in all fields."
            return false
        }
        return true
    }
    
    // Reset Fields Function
    func resetFields() {
        walkingMinutes = ""
        runningMinutes = ""
        sleepingHours = ""
        foodCalories = ""
        selectedDate = Date()
    }
}

struct CustomNumericInputField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
            TextField(placeholder, text: $text)
                .keyboardType(.numberPad)
                .autocorrectionDisabled(true)
                .onChange(of: text) {
                    let filtered = text.filter { "0123456789".contains($0) }
                    if filtered != text {
                        text = filtered
                    }
                }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
