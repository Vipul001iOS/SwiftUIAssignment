import Foundation

class ProductListUseCase: ProductListUseCaseProtocol {
    private let productRepository: ProductListRepositoryProtocol
    
    init(productRepository: ProductListRepositoryProtocol) {
        self.productRepository = productRepository
    }
    
    func getProductList() async throws -> [Product] {
        return try await productRepository.getProductsList()
    }
}
