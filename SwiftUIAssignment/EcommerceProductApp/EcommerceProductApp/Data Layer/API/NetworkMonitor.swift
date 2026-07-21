import Foundation
import Network

@MainActor
final class NetworkMonitor: NetworkMonitorProtocol {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    private let monitor = NWPathMonitor()
    private var hasReceivedStatus = false
    private var statusContinuations: [CheckedContinuation<Bool, Never>] = []

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

        return await withCheckedContinuation { continuation in
            statusContinuations.append(continuation)
        }
    }

    private func updateConnectionStatus(_ status: Bool) {
        hasReceivedStatus = true

        if isConnected != status {
            isConnected = status
            print("Network status changed: \(status)")
        }

        statusContinuations.forEach { $0.resume(returning: status) }
        statusContinuations.removeAll()
    }

    deinit {
        monitor.cancel()
    }
}
