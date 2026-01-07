
import Foundation

@MainActor
protocol ProductListRepositoryProtocol{
    func getProductsList() async throws -> [ProductEntity]
}
