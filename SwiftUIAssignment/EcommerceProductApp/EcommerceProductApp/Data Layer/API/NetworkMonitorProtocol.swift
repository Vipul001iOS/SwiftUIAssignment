@MainActor
protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
    func currentConnectionStatus() async -> Bool
}

extension NetworkMonitorProtocol {
    func currentConnectionStatus() async -> Bool {
        isConnected
    }
}
