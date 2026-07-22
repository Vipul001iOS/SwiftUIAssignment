import XCTest
import SwiftData
@testable import EcommerceProductApp

@MainActor
class MockProductRepository: ProductListRepositoryProtocol {
    var result: Result<[Product], Error> = .success([])
    
    func getProductsList() async throws -> [Product] {
        switch result {
        case .success(let entities): return entities
        case .failure(let error): throw error
        }
    }
}
