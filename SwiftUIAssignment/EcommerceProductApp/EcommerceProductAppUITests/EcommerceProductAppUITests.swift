import XCTest

final class EcommerceProductAppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testProductListAppear() {
        let navigationTitle = app.staticTexts["Product"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 5), "The product screen title appear")
        let productList = app.collectionViews["productList"]
        let firstCell = app.staticTexts.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "Product list should show at least one item")
    }
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
