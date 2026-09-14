import Network
import Foundation

/// Centralizes construction of the Objective-C service and its Swift repository adapter.
enum RemoteExpenseRepositoryFactory {
    /// Production composition using Network's URLSession-backed client.
    static func makeDefault<Configuration: NetworkConfiguration>(
        endpointURL: URL,
        networkConfiguration: Configuration
    ) -> RemoteExpenseRepository {
        let service = EVExpensesServiceFactory.makeDefault(
            endpointURL: endpointURL,
            networkConfiguration: networkConfiguration
        )
        return RemoteExpenseRepository(service: service)
    }

    /// Injectable composition used by tests or alternate HTTP transports.
    static func make<Client: NetworkClient>(
        endpointURL: URL,
        networkClient: Client
    ) -> RemoteExpenseRepository {
        let service = EVExpensesServiceFactory.make(
            endpointURL: endpointURL,
            httpClient: networkClient
        )
        return RemoteExpenseRepository(service: service)
    }
}
