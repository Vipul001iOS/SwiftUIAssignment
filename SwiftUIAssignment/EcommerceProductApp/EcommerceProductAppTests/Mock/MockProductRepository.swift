import XCTest
import SwiftData
@testable import EcommerceProductApp

@MainActor
class MockProductRepository: ProductListRepositoryProtocol {
    var result: Result<[ProductEntity], Error> = .success([])
    
    func getProductsList() async throws -> [ProductEntity] {
        switch result {
        case .success(let entities): return entities
        case .failure(let error): throw error
        }
    }
}
