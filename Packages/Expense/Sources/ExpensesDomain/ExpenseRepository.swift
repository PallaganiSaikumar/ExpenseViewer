protocol ExpenseRepository: Sendable {
    func expenses() async throws -> [Expense]
}
