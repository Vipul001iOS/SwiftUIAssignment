import XCTest
import SwiftData
@testable import EcommerceProductApp

class MockProductListUseCase: ProductListUseCaseProtocol {
    var errorToThrow: Error?
    var products = [ProductEntity(from: .mock()).toProduct()]
    
    func getProductList() async throws -> [Product] {
        if let errorToThrow {
            throw errorToThrow
        }
        return products
    }
}

