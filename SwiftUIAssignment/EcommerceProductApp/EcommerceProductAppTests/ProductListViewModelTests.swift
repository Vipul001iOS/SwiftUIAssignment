import XCTest
@testable import EcommerceProductApp

@MainActor
final class ProductListViewModelTests: XCTestCase {
    func testFetchProducts_WhenUseCaseReturnsProducts_UpdatesProductsAndClearsError() async {
        let useCase = MockProductListUseCase()
        let sut = ProductListViewModel(productUseCase: useCase)

        await sut.fetchProducts()

        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.networkError)
        XCTAssertEqual(sut.products.count, 1)
        XCTAssertEqual(sut.products.first?.title, "test")
    }

    func testFetchProducts_WhenUseCaseThrowsApiError_ClearsProductsAndSetsNetworkError() async {
        let useCase = MockProductListUseCase()
        useCase.errorToThrow = ApiError.networkError
        let sut = ProductListViewModel(productUseCase: useCase)

        await sut.fetchProducts()

        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.networkError, .networkError)
        XCTAssertTrue(sut.products.isEmpty)
    }

    func testFetchProducts_WhenUseCaseThrowsUnknownError_ClearsProductsAndSetsUnknownError() async {
        let useCase = MockProductListUseCase()
        useCase.errorToThrow = NSError(domain: "test", code: 1)
        let sut = ProductListViewModel(productUseCase: useCase)

        await sut.fetchProducts()

        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.networkError, .unKnownError)
        XCTAssertTrue(sut.products.isEmpty)
    }
}
