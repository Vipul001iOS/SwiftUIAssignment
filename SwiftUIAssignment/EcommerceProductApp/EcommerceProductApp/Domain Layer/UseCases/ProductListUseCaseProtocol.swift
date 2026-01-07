protocol ProductListUseCaseProtocol {
    func getProductList() async throws -> [ProductEntity]
}
