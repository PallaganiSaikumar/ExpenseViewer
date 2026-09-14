import Expense
import Foundation
import Testing

@MainActor
@Test("Public API client constructs the expense list without exposing internal modules")
func clientConstructsExpenseList() {
    let client: some ExpenseAPI = ExpenseAPIClient(
        configuration: MockNetworkConfiguration()
    )

    _ = client.makeExpenseListView()
}

private final class MockNetworkConfiguration: NSObject, NetworkConfiguration {
    let baseURL = URL(string: "https://example.com/api")!
    let requestTimeout: TimeInterval = 1
}
