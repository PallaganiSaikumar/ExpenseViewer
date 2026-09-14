import Foundation

enum ExpenseDataError: LocalizedError, Equatable {
    case invalidData
    case remote(message: String)

    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "The expense data could not be read."
        case let .remote(message):
            return message
        }
    }
}
