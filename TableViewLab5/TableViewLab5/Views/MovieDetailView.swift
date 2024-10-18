//
//  MovieDetailView.swift
//  TableViewLab5
//
//  Created by Divanshu Chauhan on 10/17/24.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Image(movie.imageName)
                .resizable()
                .frame(width: 150, height: 225)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(movie.name)
                .font(.largeTitle)
                .padding()
            Text(movie.genre)
                .font(.title2)
            Text(movie.description)
                .padding()

            Spacer()

            Button(action: {
                deleteMovie()
            }) {
                Text("Delete Movie")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Details")
    }

    private func deleteMovie() {
        if let index = viewModel.movies.firstIndex(where: { $0.id == movie.id }) {
            viewModel.movies.remove(at: index)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
