import SwiftUI

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var currentIndex: Int = 0

    // Add a new book
    func addBook(title: String, author: String, genre: String, price: Double) {
        let newBook = Book(title: title, author: author, genre: genre, price: price)
        books.append(newBook)
        currentIndex = books.count - 1
    }

    // Delete a book by title
    func deleteBook(title: String) {
        if let index = books.firstIndex(where: { $0.title.lowercased() == title.lowercased() }) {
            books.remove(at: index)
            if currentIndex >= books.count {
                currentIndex = books.count - 1
            }
        }
    }

    // Search a book by title or genre
    func searchBook(query: String) -> Book? {
        return books.first {
            $0.title.lowercased() == query.lowercased() ||
            $0.genre.lowercased() == query.lowercased()
        }
    }

    // Edit book details
    func editBook(oldTitle: String, newTitle: String, author: String, genre: String, price: Double) {
        if let index = books.firstIndex(where: { $0.title.lowercased() == oldTitle.lowercased() }) {
            books[index] = Book(title: newTitle, author: author, genre: genre, price: price)
        }
    }

    // Navigate to next book
    func nextBook() -> Book? {
        guard !books.isEmpty else { return nil }
        if currentIndex < books.count - 1 {
            currentIndex += 1
            return books[currentIndex]
        }
        return nil
    }

    // Navigate to previous book
    func previousBook() -> Book? {
        guard !books.isEmpty else { return nil }
        if currentIndex > 0 {
            currentIndex -= 1
            return books[currentIndex]
        }
        return nil
    }
}
