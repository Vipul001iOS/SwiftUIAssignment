protocol ProductListUseCaseProtocol {
    func getProductList() async throws -> [Product]
}
