import XCTest
import SwiftData
@testable import EcommerceProductApp

@MainActor
final class ProductRepositoryTests: XCTestCase {
    var repot: ProductRepository!
    var container: ModelContainer!
    var context: ModelContext!
    var mockAPIService: MockAPIService!
    var mockNetwork: MockNetworkMonitor!

    override func setUp() {
        super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: ProductEntity.self, configurations: config)
        context = container.mainContext
        mockAPIService = MockAPIService()
        mockNetwork = MockNetworkMonitor()
        
        repot = ProductRepository(
            modelContext: context,
            apiService: mockAPIService,
            networkMonitor: mockNetwork
        )
    }

    // MARK: - Test Offline State
    func testGetProducts_LocalData() async throws {
        let localItem = ProductEntity(from: .mock())
        context.insert(localItem)
        try context.save()
        mockNetwork.isConnected = false
        let result = try await repot.getProductsList()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "test")
    }

    // MARK: - Test Online Sync
    func testGetProducts_APIAndSaves() async throws {
        mockNetwork.isConnected = true
        let mockDTO = ProductDTO.mock()
        mockAPIService.mockResult = [mockDTO]

        let result = try await repot.getProductsList()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, mockDTO.id)
        
        let fetchDescriptor = FetchDescriptor<ProductEntity>()
        let savedItems = try context.fetch(fetchDescriptor)
        XCTAssertEqual(savedItems.count, 1)
    }
}

