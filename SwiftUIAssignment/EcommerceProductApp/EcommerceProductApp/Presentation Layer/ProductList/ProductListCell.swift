
import SwiftUI
import Foundation

struct ProductListCell: View {
    let product: Product
    
    var body: some View {
        HStack {
            Group {
                if let imgData = product.cacheImageData, let img = UIImage(data: imgData) {
                    Image(uiImage: img)
                        .resizable()
                }else {
                    AsyncImage(url: URL(string: product.image)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                        case .failure(_):
                            Image(systemName: "photo")
                        case .empty:
                            Image(systemName: "photo")
                        @unknown default:
                            ProgressView()
                        }
                    }
                }
            }
            .scaledToFit()
            .frame(width: 80, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.headline)
                Text("₹ \(String(format: "%.2f", product.price))")
                    .font(.caption).bold()
                    .foregroundColor(.primary)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 3)
        )
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        
    }
}
