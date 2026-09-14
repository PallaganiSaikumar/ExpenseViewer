import Network
import Foundation

enum ExpenseDataErrorMapper {
    static func map(_ error: Error) -> Error {
        let error = error as NSError
        if error.domain == EVExpensesRemoteErrorDomain {
            return ExpenseDataError.invalidData
        }
        return ExpenseDataError.remote(message: error.localizedDescription)
    }
}
