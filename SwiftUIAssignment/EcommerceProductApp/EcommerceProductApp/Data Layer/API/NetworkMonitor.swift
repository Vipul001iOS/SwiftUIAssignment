import Foundation
import Network

final class NetworkMonitor: NetworkMonitorProtocol {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    private let monitor = NWPathMonitor()
    var isConnected: Bool = false
    
    init() {
            monitor.pathUpdateHandler = { [weak self] path in
                let status = path.status == .satisfied
                DispatchQueue.main.async {
                    if self?.isConnected != status {
                        self?.isConnected = status
                        print("Network status changed: \(status)")
                    }
                }
            }
            monitor.start(queue: queue)
        }
    
    deinit {
        monitor.cancel()
    }
}
