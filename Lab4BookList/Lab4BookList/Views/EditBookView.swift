import SwiftUI

struct EditBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BookViewModel
    @State private var book: Book
    @State private var editedTitle: String
    @State private var editedAuthor: String
    @State private var editedGenre: String
    @State private var editedPrice: String

    init(viewModel: BookViewModel, book: Book) {
        self.viewModel = viewModel
        _book = State(initialValue: book)
        _editedTitle = State(initialValue: book.title)
        _editedAuthor = State(initialValue: book.author)
        _editedGenre = State(initialValue: book.genre)
        _editedPrice = State(initialValue: String(book.price))
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Edit Details")) {
                    TextField("Title", text: $editedTitle)
                        .autocapitalization(.words)
                    TextField("Author", text: $editedAuthor)
                        .autocapitalization(.words)
                    TextField("Genre", text: $editedGenre)
                        .autocapitalization(.words)
                    TextField("Price", text: $editedPrice)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Button(action: deleteBook) {
                        HStack {
                            Spacer()
                            Text("Delete Book")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Edit Book")

                        HStack {
                            Button("Previous") {
                                if let previousBook = viewModel.previousBook() {
                                    updateBookDetails(with: previousBook)
                                }
                            }
                            .disabled(viewModel.currentIndex == 0 || !canSave)

                            Spacer()

                            Button("Save") {
                                saveEdits()
                            }
                            .disabled(!canSave)

                            Spacer()

                            Button("Next") {
                                if let nextBook = viewModel.nextBook() {
                                    updateBookDetails(with: nextBook)
                                }
                            }
                            .disabled(viewModel.currentIndex == viewModel.books.count - 1 || !canSave)
                        }
                        .padding()
                    }
                }

    // Compute if Save Button should be enabled
    private var canSave: Bool {
        !editedTitle.isEmpty && !editedAuthor.isEmpty && !editedGenre.isEmpty && Double(editedPrice) != nil
    }

    // Save Edits and Dismiss
    private func saveEdits() {
        if let priceValue = Double(editedPrice) {
            viewModel.editBook(oldTitle: book.title, newTitle: editedTitle, author: editedAuthor, genre: editedGenre, price: priceValue)
            presentationMode.wrappedValue.dismiss()
        }
    }

    // Delete Book and Dismiss
    private func deleteBook() {
        viewModel.deleteBook(title: book.title)
        presentationMode.wrappedValue.dismiss()
    }

    // Update book details when navigating
    private func updateBookDetails(with newBook: Book) {
        book = newBook
        editedTitle = newBook.title
        editedAuthor = newBook.author
        editedGenre = newBook.genre
        editedPrice = String(newBook.price)
    }
}

// Preview
struct EditBookView_Previews: PreviewProvider {
    static var previews: some View {
        EditBookView(viewModel: BookViewModel(), book: Book(title: "Sample", author: "Author", genre: "Genre", price: 19.99))
    }
}
