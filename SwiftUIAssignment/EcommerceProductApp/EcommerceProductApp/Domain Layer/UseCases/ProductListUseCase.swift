import Foundation

@MainActor
class ProductListUseCase: ProductListUseCaseProtocol {
    private let productRepository: ProductListRepositoryProtocol
    
    init(productRepository: ProductListRepositoryProtocol) {
        self.productRepository = productRepository
    }
    
    func getProductList() async throws -> [ProductEntity] {
        return try await productRepository.getProductsList()
    }
}
