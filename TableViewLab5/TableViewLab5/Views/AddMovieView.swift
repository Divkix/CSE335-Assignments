import SwiftUI

struct AddMovieView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var genre = ""
    @State private var description = ""

    // Computed property to check if all fields are filled
    private var isFormValid: Bool {
        !name.isEmpty && !genre.isEmpty && !description.isEmpty
    }

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
                    .disabled(!isFormValid) // Disable the button if the form is not valid
                }
            }
        }
    }
}
