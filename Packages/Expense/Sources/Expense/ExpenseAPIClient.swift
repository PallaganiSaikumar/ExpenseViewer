import Foundation
import SwiftUI

/// Composes the Expense feature's data, domain, and presentation layers.
public struct ExpenseAPIClient: ExpenseAPI {
    private let getExpenses: DefaultGetExpensesUseCase

    /// Creates the production feature using the default URLSession-backed transport.
    ///
    /// - Parameter configuration: App-owned base URL and network timeout settings.
    public init<Configuration: NetworkConfiguration>(configuration: Configuration) {
        let repository = RemoteExpenseRepositoryFactory.makeDefault(
            endpointURL: ExpenseEndpoint.url(configuration: configuration),
            networkConfiguration: configuration
        )
        getExpenses = DefaultGetExpensesUseCase(repository: repository)
    }

    /// Creates the feature with an injected transport, allowing deterministic network tests.
    ///
    /// - Parameters:
    ///   - configuration: App-owned configuration used to construct the feature endpoint.
    ///   - networkClient: Transport implementation or test double used to execute requests.
    public init<Configuration: NetworkConfiguration, Client: NetworkClient>(
        configuration: Configuration,
        networkClient: Client
    ) {
        let repository = RemoteExpenseRepositoryFactory.make(
            endpointURL: ExpenseEndpoint.url(configuration: configuration),
            networkClient: networkClient
        )
        getExpenses = DefaultGetExpensesUseCase(repository: repository)
    }

    /// Returns the package-owned SwiftUI expense list.
    @MainActor
    public func makeExpenseListView() -> some View {
        ExpenseListView(
            viewModel: ExpenseListViewModel(getExpenses: getExpenses)
        )
    }
}
