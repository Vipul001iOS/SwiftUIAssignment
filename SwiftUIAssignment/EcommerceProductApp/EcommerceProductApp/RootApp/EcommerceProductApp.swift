import SwiftUI
import SwiftData

@main
struct EcommerceProductApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ProductEntity.self,
        ])
        let isUITesting = ProcessInfo.processInfo.arguments.contains("--ui-testing")
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isUITesting)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        if ProcessInfo.processInfo.arguments.contains("--ui-testing") {
            seedUITestProducts()
        }
    }

    var body: some Scene {
        WindowGroup {
            ProductListView(modelContext: sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
    }

    private func seedUITestProducts() {
        let context = sharedModelContainer.mainContext
        let products = [
            ProductDTO(
                id: 1,
                title: "Test Backpack",
                price: 49.99,
                description: "Durable backpack for UI tests",
                category: "Bags",
                image: "test.png",
                rating: Rating(rate: 4.5, count: 12)
            ),
            ProductDTO(
                id: 2,
                title: "Test Jacket",
                price: 89.99,
                description: "Warm jacket for UI tests",
                category: "Clothing",
                image: "test.png",
                rating: Rating(rate: 4.2, count: 8)
            )
        ]

        products.forEach { context.insert(ProductEntity(from: $0)) }
        try? context.save()
    }
}
