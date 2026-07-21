import Foundation
import SwiftData

@MainActor
class ProductRepository: ProductListRepositoryProtocol {
    private let modelContext: ModelContext
    private let apiService: APIServiceProtocol
    private let networkMonitor: NetworkMonitorProtocol
    
    init(modelContext: ModelContext,
         apiService: APIServiceProtocol = APIManager()) {
        self.modelContext = modelContext
        self.apiService = apiService
        self.networkMonitor = NetworkMonitor.shared
    }

    init(modelContext: ModelContext,
         apiService: APIServiceProtocol,
         networkMonitor: NetworkMonitorProtocol) {
        self.modelContext = modelContext
        self.apiService = apiService
        self.networkMonitor = networkMonitor
    }
    
    func getProductsList() async throws -> [ProductEntity] {
        let descriptor = FetchDescriptor<ProductEntity>(sortBy: [SortDescriptor(\.id)])
        let localData = try modelContext.fetch(descriptor)
        
        let isConnected = await networkMonitor.currentConnectionStatus()
        if !isConnected {
            if localData.isEmpty { throw ApiError.networkError }
            return localData
        }
        do {
            let apiData: [ProductDTO] = try await apiService.request(url: API.productsURL)
            for product in apiData {
                if let existingEntity = localData.first(where: { $0.id == product.id }) {
                    existingEntity.update(product)
                    
                } else {
                    let newEntity = ProductEntity(from: product)
                    modelContext.insert(newEntity)
                }
            }
            
            try modelContext.save()
            return try modelContext.fetch(descriptor)
            
        } catch {
            if !localData.isEmpty { return localData }
            throw ApiError.noData
        }
    }
}
