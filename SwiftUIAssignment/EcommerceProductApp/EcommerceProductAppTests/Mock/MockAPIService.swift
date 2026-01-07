import XCTest
import SwiftData
@testable import EcommerceProductApp

class MockAPIService: APIServiceProtocol {
    var mockResult: Decodable?
    func request<T: Decodable>(url: String) async throws -> T {
        if let result = mockResult as? T { return result }
        throw ApiError.noData
    }
}
