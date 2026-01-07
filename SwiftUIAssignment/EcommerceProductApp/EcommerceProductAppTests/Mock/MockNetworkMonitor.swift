import XCTest
import SwiftData
@testable import EcommerceProductApp

class MockNetworkMonitor: NetworkMonitorProtocol {
    var isConnected = true
}
