import Foundation
import SwiftData

@Model
final class ProductEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var price: Double
    var descriptionText: String
    var image: String
    var category: String
    
    var rate: Double
    var count: Int
    
    @Attribute(.externalStorage) var cacheImageData: Data?
    
    init(from dto: ProductDTO) {
        self.id = dto.id
        self.title = dto.title
        self.price = dto.price
        self.descriptionText = dto.description
        self.image = dto.image
        self.category = dto.category
        self.rate = dto.rating.rate
        self.count = dto.rating.count
    }
    
    func update(_ dto: ProductDTO) {
        self.id = dto.id
        self.title = dto.title
        self.price = dto.price
        self.descriptionText = dto.description
        self.image = dto.image
        self.category = dto.category
        self.rate = dto.rating.rate
        self.count = dto.rating.count
    }
}

@MainActor
extension ProductEntity {
    
    func storeImageLocally(data: Data) {
        self.cacheImageData = data
    }
    
    func loadAndSaveImage() {
        guard self.cacheImageData == nil, let url = URL(string: self.image) else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                self.storeImageLocally(data: data)
            } catch {
                print("Failed to cache: \(error)")
            }
        }
    }
}
