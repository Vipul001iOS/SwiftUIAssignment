
import SwiftUI
import SwiftData

struct ProductListView: View {
    @StateObject var viewModel: ProductListViewModel
    @State private var layoutMode: ProductListLayoutMode = .list
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
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
                    productContent
                }
            }
            .navigationTitle("Product List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Picker("Layout", selection: $layoutMode) {
                        Image(systemName: "list.bullet")
                            .tag(ProductListLayoutMode.list)
                        Image(systemName: "square.grid.2x2")
                            .tag(ProductListLayoutMode.grid)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 110)
                    .accessibilityIdentifier("layoutModePicker")
                }
            }
            .navigationDestination(for: Product.self) { product in
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
    
    @ViewBuilder
    private var productContent: some View {
        switch layoutMode {
        case .list:
            List(viewModel.products, id: \.id) { product in
                NavigationLink(value: product) {
                    ProductListCell(product: product)
                }
                .accessibilityIdentifier("productListItem_\(product.id)")
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
                .navigationLinkIndicatorVisibility(.hidden)
            }
            .listStyle(.insetGrouped)
            .accessibilityIdentifier("productList")
            .scrollContentBackground(.hidden)
        case .grid:
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 16) {
                    ForEach(viewModel.products) { product in
                        NavigationLink(value: product) {
                            ProductGridCell(product: product)
                        }
                        .accessibilityIdentifier("productGridItem_\(product.id)")
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .accessibilityIdentifier("productGrid")
        }
    }
}

private enum ProductListLayoutMode {
    case list
    case grid
}

private struct ProductGridCell: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            productImage
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(product.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .frame(height: 38, alignment: .topLeading)

            Text("₹ \(String(format: "%.2f", product.price))")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
                .shadow(color: Color.black.opacity(0.18), radius: 4, x: 0, y: 2)
        )
    }

    @ViewBuilder
    private var productImage: some View {
        if let imgData = product.cacheImageData, let img = UIImage(data: imgData) {
            Image(uiImage: img)
                .resizable()
        } else {
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                case .failure(_), .empty:
                    Image(systemName: "photo")
                        .resizable()
                        .padding(36)
                        .foregroundColor(.secondary)
                @unknown default:
                    ProgressView()
                }
            }
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
