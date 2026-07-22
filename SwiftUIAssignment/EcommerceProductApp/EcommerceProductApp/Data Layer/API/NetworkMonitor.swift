import Foundation
import Network

@MainActor
final class NetworkMonitor: NetworkMonitorProtocol {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    private let monitor = NWPathMonitor()
    private let statusCheckDelayNanoseconds: UInt64 = 50_000_000
    private let maxInitialStatusChecks = 10
    private var hasReceivedStatus = false

    private(set) var isConnected: Bool = false

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let status = path.status == .satisfied

            Task { @MainActor in
                self?.updateConnectionStatus(status)
            }
        }

        monitor.start(queue: queue)
    }

    func currentConnectionStatus() async -> Bool {
        if hasReceivedStatus {
            return isConnected
        }

        for _ in 0..<maxInitialStatusChecks {
            if Task.isCancelled {
                return isConnected
            }

            try? await Task.sleep(nanoseconds: statusCheckDelayNanoseconds)

            if hasReceivedStatus {
                return isConnected
            }
        }

        let currentStatus = monitor.currentPath.status == .satisfied
        updateConnectionStatus(currentStatus)
        return isConnected
    }

    private func updateConnectionStatus(_ status: Bool) {
        hasReceivedStatus = true

        if isConnected != status {
            isConnected = status
            print("Network status changed: \(status)")
        }
    }

    deinit {
        monitor.cancel()
    }
}
