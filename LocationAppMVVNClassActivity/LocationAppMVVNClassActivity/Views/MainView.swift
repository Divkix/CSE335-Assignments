//
//  MainView.swift
//  LocationAppMVVNClassActivity
//
//  Created by Divanshu Chauhan on 9/26/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = LocationViewModel()
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var msgInfo: String = ""
    @State private var navigateToDetail: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 15) {
                    TextField("Enter City", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)

                    TextField("Enter State", text: $state)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    viewModel.location = Location(city: city, state: state)
                    city = ""
                    state = ""
                    msgInfo = "Location added successfully!"
                }) {
                    Text("Add My Location")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(
                    destination: DetailView(viewModel: viewModel),
                    isActive: $navigateToDetail
                ) {
                    Button(action: {
                        navigateToDetail = true
                    }) {
                        Text("Go to Detail View")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                Spacer()
                Text(msgInfo)
            }
            .navigationTitle("Add New Location")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
