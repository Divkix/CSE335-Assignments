//
//  ContentView.swift
//  LectureActivityOne
//
//  Created by Divanshu Chauhan on 8/31/24.
//

import SwiftUI

struct ContentView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var greetingMessage: String = ""

    var body: some View {
        ZStack {
            Image("your_background_image_name")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Text("First Name: ")
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Text("Last Name: ")
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    greetingMessage = "Welcome to the class my boi, \(firstName) \(lastName)"
                }) {
                    Text("Greeting")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                Text(greetingMessage)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
