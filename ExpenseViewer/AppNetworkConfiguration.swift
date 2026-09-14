import Expense
import Foundation

/// App-owned environment values. Feature-specific paths remain inside the owning package.
final class AppNetworkConfiguration: NSObject, NetworkConfiguration {
    nonisolated let baseURL = URL(string: "https://jsonkeeper.com")!
    nonisolated let requestTimeout: TimeInterval = 30
}
