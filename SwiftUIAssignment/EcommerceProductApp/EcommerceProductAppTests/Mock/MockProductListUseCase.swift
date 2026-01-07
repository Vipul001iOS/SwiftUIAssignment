import XCTest
import SwiftData
@testable import EcommerceProductApp

class MockProductListUseCase: ProductListUseCase {
    var shouldReturnError = false
    
    func execute() async throws -> [ProductEntity] {
        if shouldReturnError {
            throw NSError(domain: "test error", code: 0)
        }
        return [ProductEntity(from: .mock())]
    }
}

