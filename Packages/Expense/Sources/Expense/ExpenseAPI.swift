import Network
import SwiftUI

/// Configuration required by the underlying Objective-C network stack.
/// The concrete environment configuration is intentionally supplied by the app.
public typealias NetworkConfiguration = EVNetworkConfiguration

/// Injectable HTTP transport used to isolate the feature from real network requests in tests.
public typealias NetworkClient = EVHTTPClient

/// Public entry point exposed by the Expense package.
/// Consumers receive a complete feature view without depending on its internal layers.
public protocol ExpenseAPI: Sendable {
    associatedtype ExpenseListContent: View

    /// Builds the expense list on the main actor because it creates SwiftUI presentation state.
    @MainActor
    @ViewBuilder
    func makeExpenseListView() -> ExpenseListContent
}
