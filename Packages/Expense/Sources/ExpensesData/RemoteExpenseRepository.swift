import Network
import Foundation

/// Adapts the Objective-C callback API to the async domain repository contract.
///
/// Safety: the service is immutable after initialization and completion values are copied into
/// immutable Swift domain models before crossing the concurrency boundary.
final class RemoteExpenseRepository: ExpenseRepository, @unchecked Sendable {
    private let service: any EVExpensesServicing
    private let mapper: ExpenseDTOMapper

    init(
        service: any EVExpensesServicing,
        mapper: ExpenseDTOMapper = ExpenseDTOMapper()
    ) {
        self.service = service
        self.mapper = mapper
    }

    func expenses() async throws -> [Expense] {
        try await withCheckedThrowingContinuation { continuation in
            service.fetchExpenses { [mapper] DTOs, error in
                if let error {
                    continuation.resume(throwing: ExpenseDataErrorMapper.map(error))
                    return
                }

                guard let DTOs else {
                    continuation.resume(throwing: ExpenseDataError.invalidData)
                    return
                }

                continuation.resume(returning: DTOs.map(mapper.map))
            }
        }
    }
}
