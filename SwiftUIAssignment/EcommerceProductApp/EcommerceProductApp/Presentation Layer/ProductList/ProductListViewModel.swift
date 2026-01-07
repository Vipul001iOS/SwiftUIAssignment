import Foundation

@MainActor
class ProductListViewModel: ObservableObject {
    
    @Published var products: [ProductEntity] = []
    @Published var isLoading: Bool = false
    @Published var networkError: ApiError? = nil
    private let productUseCase: ProductListUseCase
    
    init(productUseCase: ProductListUseCase) {
        self.productUseCase = productUseCase
    }
    
    func fetchProducts() async {
        self.networkError = nil
        self.isLoading = true
        defer { isLoading = false }
        do {
            products = try await productUseCase.getProductList()
            self.networkError = nil
        } catch let error as ApiError {
            self.networkError = error
            self.products = []
        } catch {
            self.networkError = .unKnownError
            self.products = []
        }
    }
}
