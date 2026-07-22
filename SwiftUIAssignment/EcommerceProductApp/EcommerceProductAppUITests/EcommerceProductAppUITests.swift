import XCTest

final class EcommerceProductAppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["--ui-testing"]
        app.launch()
    }
    
    func testProductListAppear() {
        let navigationTitle = app.navigationBars["Product List"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 5), "The product screen title should appear")
        XCTAssertTrue(app.collectionViews["productList"].waitForExistence(timeout: 5), "Product list should appear")
        XCTAssertTrue(app.buttons["productListItem_1"].waitForExistence(timeout: 5), "First product row should appear")
    }

    func testCanSwitchBetweenListAndGridLayout() {
        let productList = app.collectionViews["productList"]
        XCTAssertTrue(productList.waitForExistence(timeout: 5), "Product list should appear first")

        let layoutPicker = app.segmentedControls["layoutModePicker"]
        XCTAssertTrue(layoutPicker.waitForExistence(timeout: 5), "Layout picker should appear in the header")

        layoutPicker.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.scrollViews["productGrid"].waitForExistence(timeout: 5), "Product grid should appear after selecting grid mode")
        XCTAssertTrue(app.buttons["productGridItem_1"].waitForExistence(timeout: 5), "First product should still be visible in grid mode")

        layoutPicker.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.collectionViews["productList"].waitForExistence(timeout: 5), "Product list should appear after selecting list mode")
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
