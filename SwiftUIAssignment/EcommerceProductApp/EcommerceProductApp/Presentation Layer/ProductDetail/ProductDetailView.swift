import SwiftUI

struct ProductDetailView: View {
    let productDetail: ProductEntity
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        if let imgData = productDetail.cacheImageData, let img = UIImage(data: imgData) {
                            Image(uiImage: img)
                                .resizable()
                        }else {
                            AsyncImage(url: URL(string: productDetail.image)) { result in
                                if let image = result.image {
                                    image.resizable()
                                        .onAppear {
                                            productDetail.loadAndSaveImage()
                                        }
                                } else {
                                    ProgressView()
                                }
                            }
                        }
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(productDetail.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        HStack (){
                            Text("₹ \(productDetail.price, specifier: "%.2f")")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            Spacer()
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("\(productDetail.rate, specifier: "%.1f")")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(productDetail.descriptionText)
                            .font(.body)
                            .lineSpacing(5)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProductDetailView(productDetail: ProductEntity(from: ProductDTO(id: 1, title: "Test", price: 100.00, description: "test description", category: "Cloths", image: "test.png", rating: Rating(rate: 4.5, count: 5))))
}
