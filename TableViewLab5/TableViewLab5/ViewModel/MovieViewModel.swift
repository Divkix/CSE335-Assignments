//
//  MovieViewModel.swift
//  TableViewLab5
//
//  Created by Divanshu Chauhan on 10/17/24.
//

import Foundation

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie]

    init() {
        // Pre-load 5 movies during initialization
        self.movies = [
            Movie(name: "Inception", genre: "Sci-Fi", imageName: "inception", description: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO."),
            Movie(name: "The Dark Knight", genre: "Action", imageName: "dark_knight", description: "When a menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman, James Gordon and Harvey Dent must work together to put an end to the madness."),
            Movie(name: "The Notebook", genre: "Romance", imageName: "the_notebook", description: "Two young lovers are torn apart by war and class differences in the 1940s in this adaptation of Nicholas Sparks's bestselling novel."),
            Movie(name: "American Pie", genre: "Comedy", imageName: "american_pie", description: "Four teenage boys enter a pact to lose their virginity by prom night."),
            Movie(name: "The Curious Case of Benjamin Button", genre: "Fantasy",imageName: "benjamin_button", description: "Benjamin Button, born in 1918 with the physical state of an elderly man, ages in reverse. He experiences love and break-ups, ecstasy and sorrow, and timelessness by the time he dies in 2003 as a baby.")
        ]
        
        // Sort movies in alphabetical order by name
        self.movies.sort { $0.name < $1.name }
    }

    // Function to add a new movie
    func addMovie(name: String, genre: String, description: String) {
        let newMovie = Movie(name: name, genre: genre, imageName: "default_img", description: description)
        movies.append(newMovie)
        movies.sort { $0.name < $1.name }
    }

    // Function to delete a movie
    func deleteMovie(at offsets: IndexSet) {
        movies.remove(atOffsets: offsets)
    }
}

