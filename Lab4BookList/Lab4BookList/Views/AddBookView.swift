import SwiftUI

struct AddBookView: View {
    @ObservedObject var viewModel: BookViewModel
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var price = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Book Details")) {
                    TextField("Title", text: $title)
                        .autocapitalization(.words)
                    TextField("Author", text: $author)
                        .autocapitalization(.words)
                    TextField("Genre", text: $genre)
                        .autocapitalization(.words)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Book")
            .toolbar {
                // Save Button
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveBook()
                    }
                    .disabled(!canSave)
                }
                
                // Cancel Button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    // Compute if Save Button should be enabled
    private var canSave: Bool {
        !title.isEmpty && !author.isEmpty && !genre.isEmpty && Double(price) != nil
    }

    // Save Book and Dismiss
    private func saveBook() {
        if let priceValue = Double(price) {
            viewModel.addBook(title: title, author: author, genre: genre, price: priceValue)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// Preview
struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView(viewModel: BookViewModel())
    }
}
