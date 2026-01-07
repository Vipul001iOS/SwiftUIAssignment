
import SwiftUI
import SwiftData

struct ProductListView: View {
    @StateObject var viewModel: ProductListViewModel
    
    init(modelContext: ModelContext) {
        let repo = ProductRepository(modelContext: modelContext)
        let useCase = ProductListUseCase(productRepository: repo)
        _viewModel = StateObject(wrappedValue: ProductListViewModel(productUseCase: useCase))
    }
    var body: some View {
        NavigationStack() {
            ZStack {
                Color.white.ignoresSafeArea()
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.products.isEmpty && viewModel.networkError != nil {
                    Text(viewModel.networkError?.errorDescription ?? "")
                } else {
                    List(viewModel.products, id: \.id){ product in
                        NavigationLink(value: product) {
                            ProductListCell(product: product)
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .navigationLinkIndicatorVisibility(.hidden)
                    }
                    .listStyle(.insetGrouped)
                    .accessibilityIdentifier("productList")
                    .scrollContentBackground(.hidden)
                    
                }
            }
            .navigationTitle("Product List")
            .navigationDestination(for: ProductEntity.self) { product in
                ProductDetailView(productDetail: product)
            }
        }
        .task {
            await viewModel.fetchProducts()
        }
        .refreshable {
            await viewModel.fetchProducts()
        }
    }
}

#Preview {
    let schema = Schema([
        ProductEntity.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [modelConfiguration])
    return ProductListView(modelContext: container.mainContext)
        .modelContainer(container)
}
