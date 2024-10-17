import SwiftUI

struct BookListView: View {
    @StateObject private var viewModel = BookViewModel()
    @State private var showAddBook = false
    @State private var showSearchSheet = false
    @State private var searchQuery = ""
    @State private var selectedBook: Book?
    @State private var navigationMessage = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.books) { book in
                    NavigationLink(destination: EditBookView(viewModel: viewModel, book: book)) {
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.headline)
                            Text("Author: \(book.author)")
                            Text("Genre: \(book.genre)")
                            Text(String(format: "Price: $%.2f", book.price))
                        }
                        .padding(.vertical, 5)
                    }
                    .onTapGesture {
                        if let index = viewModel.books.firstIndex(where: { $0.id == book.id }) {
                            viewModel.currentIndex = index
                        }
                    }
                }
            }
            .navigationTitle("Book List")
            .toolbar {
                // Add Button
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { showAddBook.toggle() }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add Book")
                }
                
                // Search Button
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { showSearchSheet.toggle() }) {
                        Image(systemName: "magnifyingglass")
                    }
                    .accessibilityLabel("Search Book")
                }
            }
            .sheet(isPresented: $showAddBook) {
                AddBookView(viewModel: viewModel)
            }
            .sheet(isPresented: $showSearchSheet) {
                VStack {
                    Text("Search Book")
                        .font(.headline)
                        .padding()
                    
                    TextField("Enter title or genre", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack {
                        Button("Cancel") {
                            showSearchSheet = false
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button("Search") {
                            if let foundBook = viewModel.searchBook(query: searchQuery) {
                                selectedBook = foundBook
                            }
                            searchQuery = ""
                            showSearchSheet = false
                        }
                        .padding()
                    }
                    .padding()
                }
                .presentationDetents([.fraction(0.3)])
            }
            .sheet(item: $selectedBook) { book in
                EditBookView(viewModel: viewModel, book: book)
            }
            .overlay(
                Text(navigationMessage)
                    .padding()
                    .background(Color.gray.opacity(0.7))
                    .cornerRadius(10)
                    .opacity(navigationMessage.isEmpty ? 0 : 1),
                alignment: .bottom
            )
        }
        .onAppear {
            if !viewModel.books.isEmpty {
                selectedBook = viewModel.books[viewModel.currentIndex]
            }
        }
    }
}

// Preview
struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView()
    }
}
