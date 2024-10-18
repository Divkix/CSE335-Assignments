//
//  AddMovieNew.swift
//  TableViewLab5
//
//  Created by Divanshu Chauhan on 10/17/24.
//

import SwiftUI

struct AddMovieView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var genre = ""
    @State private var description = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Movie Information")) {
                    TextField("Name", text: $name)
                    TextField("Genre", text: $genre)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Add Movie")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        viewModel.addMovie(name: name, genre: genre, description: description)
                        isPresented = false
                    }
                }
            }
        }
    }
}
