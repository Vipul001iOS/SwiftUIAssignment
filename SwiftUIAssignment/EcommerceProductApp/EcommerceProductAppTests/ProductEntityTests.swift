import XCTest
@testable import EcommerceProductApp

@MainActor
final class ProductEntityTests: XCTestCase {
    func testInitFromDTO_MapsAllFields() {
        let dto = ProductDTO.mock()

        let entity = ProductEntity(from: dto)

        XCTAssertEqual(entity.id, dto.id)
        XCTAssertEqual(entity.title, dto.title)
        XCTAssertEqual(entity.price, dto.price)
        XCTAssertEqual(entity.descriptionText, dto.description)
        XCTAssertEqual(entity.image, dto.image)
        XCTAssertEqual(entity.category, dto.category)
        XCTAssertEqual(entity.rate, dto.rating.rate)
        XCTAssertEqual(entity.count, dto.rating.count)
    }

    func testUpdate_UpdatesAllFields() {
        let entity = ProductEntity(from: .mock())
        let dto = ProductDTO(
            id: 2,
            title: "Updated",
            price: 10.5,
            description: "Updated description",
            category: "Updated category",
            image: "updated.png",
            rating: Rating(rate: 3.5, count: 4)
        )

        entity.update(dto)

        XCTAssertEqual(entity.id, dto.id)
        XCTAssertEqual(entity.title, dto.title)
        XCTAssertEqual(entity.price, dto.price)
        XCTAssertEqual(entity.descriptionText, dto.description)
        XCTAssertEqual(entity.image, dto.image)
        XCTAssertEqual(entity.category, dto.category)
        XCTAssertEqual(entity.rate, dto.rating.rate)
        XCTAssertEqual(entity.count, dto.rating.count)
    }

    func testToProduct_MapsEntityToDomainModel() {
        let entity = ProductEntity(from: .mock())
        let imageData = Data("image".utf8)
        entity.storeImageLocally(data: imageData)

        let product = entity.toProduct()

        XCTAssertEqual(product.id, entity.id)
        XCTAssertEqual(product.title, entity.title)
        XCTAssertEqual(product.price, entity.price)
        XCTAssertEqual(product.descriptionText, entity.descriptionText)
        XCTAssertEqual(product.image, entity.image)
        XCTAssertEqual(product.category, entity.category)
        XCTAssertEqual(product.rate, entity.rate)
        XCTAssertEqual(product.count, entity.count)
        XCTAssertEqual(product.cacheImageData, imageData)
    }
}
