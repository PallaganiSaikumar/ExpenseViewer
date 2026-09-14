import Foundation

/// Keeps feature-specific routing out of both the app configuration and generic network code.
enum ExpenseEndpoint {
    private static let pathComponents = ["b", "AMKA"]

    static func url<Configuration: NetworkConfiguration>(
        configuration: Configuration
    ) -> URL {
        pathComponents.reduce(configuration.baseURL) { partialURL, component in
            partialURL.appendingPathComponent(component)
        }
    }
}
