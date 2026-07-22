import XCTest
import SwiftData
@testable import EcommerceProductApp

class MockAPIService: APIServiceProtocol {
    var mockResult: Decodable?
    var errorToThrow: Error?

    func request<T: Decodable>(url: String) async throws -> T {
        if let errorToThrow {
            throw errorToThrow
        }

        if let result = mockResult as? T {
            return result
        }

        throw ApiError.noData
    }
}
