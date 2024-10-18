//
//  ContentView.swift
//  TableViewLab5
//
//  Created by Divanshu Chauhan on 10/17/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var showAddMovieView = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel)) {
                        HStack {
                            Image(movie.imageName)
                                .resizable()
                                .frame(width: 50, height: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            VStack(alignment: .leading) {
                                Text(movie.name)
                                    .font(.headline)
                                Text(movie.genre)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteMovie)
            }
            .navigationTitle("Movies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddMovieView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddMovieView) {
                AddMovieView(viewModel: viewModel, isPresented: $showAddMovieView)
            }
        }
    }
}

