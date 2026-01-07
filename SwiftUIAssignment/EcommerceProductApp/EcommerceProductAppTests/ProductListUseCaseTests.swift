import XCTest
@testable import EcommerceProductApp

@MainActor
final class ProductListUseCaseTests: XCTestCase {
    var sut: ProductListUseCase!
    var mockRepository: MockProductRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockProductRepository()
        sut = ProductListUseCase(productRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_WhenRepositoryReturnsData_Success() async throws {
        let mockEntity = ProductEntity(from: .mock())
        mockRepository.result = .success([mockEntity])
        let products = try await sut.getProductList()
        XCTAssertEqual(products.count, 1)
        XCTAssertEqual(products.first?.title, "test")
    }

    func testExecute_WhenRepositoryFails_ThrowsError() async {
        mockRepository.result = .failure(ApiError.noData)
        do {
            _ = try await sut.getProductList()
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertEqual(error as? ApiError, .noData)
        }
    }
}
