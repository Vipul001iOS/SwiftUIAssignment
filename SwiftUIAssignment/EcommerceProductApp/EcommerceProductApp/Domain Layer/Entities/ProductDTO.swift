import Foundation

struct ProductDTO: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}
struct Rating: Codable {
    let rate: Double
    let count: Int
}

extension ProductDTO {
    static func mock() -> ProductDTO {
        return ProductDTO(id: 1, title: "test", price: 99.99, description: "test description", category: "Cloths", image: "test.png", rating: Rating(rate: 4.5, count: 10))
    }
}
