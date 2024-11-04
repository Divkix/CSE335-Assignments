//
//  AddCityView.swift
//  MyTravelJournalLab7
//
//  Created by Divanshu Chauhan on 11/4/24.
//


import SwiftUI
import SwiftData

// view to add city
struct AddCityView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var name: String = ""
    @State private var cityDescription: String = ""
    @State private var imageData: Data? = nil
    @State private var showImagePicker = false
    
    var body: some View {
        Form {
            Section(header: Text("City Details")) {
                TextField("City Name", text: $name)
                TextField("Description", text: $cityDescription)
            }
            
            Section(header: Text("City Image")) {
                Button(action: {
                    showImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Select Image")
                    }
                }
                if let imageData = imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } else {
                    Text("No Image Selected")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationBarTitle("Add New City", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save") {
            saveCity()
        })
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(imageData: $imageData)
        }
    }
    
    private func saveCity() {
        guard !name.isEmpty else { return }
        let newCity = City(name: name, cityDescription: cityDescription, imageData: imageData)
        modelContext.insert(newCity)
        dismiss()
    }
}
