//
//  AddCityView.swift
//  Lab6CityGuide
//
//  Created by Divanshu Chauhan on 10/27/24.
//

import SwiftUI

struct AddCityView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cityListVM: CityListViewModel

    @State private var name = ""
    @State private var description = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("City Details")) {
                    TextField("City Name", text: $name)
                        .textContentType(.addressCity)
                        .autocapitalization(.words)
                    TextField("Description", text: $description)
                        .textContentType(.none)
                        .autocapitalization(.sentences)
                }
            }
            .navigationBarTitle("Add City", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                cityListVM.addCity(name: name, description: description)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
