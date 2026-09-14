protocol GetExpensesUseCase: Sendable {
    func execute() async throws -> [Expense]
}

/// Fetches expenses and applies the feature's deterministic newest-first ordering rule.
final class DefaultGetExpensesUseCase: GetExpensesUseCase, Sendable {
    private let repository: any ExpenseRepository

    init(repository: any ExpenseRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Expense] {
        try await repository.expenses().sorted {
            if $0.occurredAt == $1.occurredAt {
                return $0.id < $1.id
            }
            return $0.occurredAt > $1.occurredAt
        }
    }
}
