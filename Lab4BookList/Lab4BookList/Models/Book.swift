import Foundation

struct Book: Identifiable {
    let id = UUID()
    var title: String
    var author: String
    var genre: String
    var price: Double
}
