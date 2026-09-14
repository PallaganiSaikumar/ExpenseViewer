import Foundation
import Testing
@testable import Expense

@Test("Expenses are ordered newest first with a deterministic tie-breaker")
func ordersExpensesNewestFirst() async throws {
    let earlier = Date(timeIntervalSince1970: 100)
    let later = Date(timeIntervalSince1970: 200)
    let expenses = [
        makeExpense(id: "c", date: earlier),
        makeExpense(id: "b", date: later),
        makeExpense(id: "a", date: later)
    ]
    let useCase = DefaultGetExpensesUseCase(repository: RepositoryStub(result: .success(expenses)))

    let result = try await useCase.execute()

    #expect(result.map(\.id) == ["a", "b", "c"])
}

private struct RepositoryStub: ExpenseRepository {
    let result: Result<[Expense], Error>

    func expenses() async throws -> [Expense] {
        try result.get()
    }
}

private func makeExpense(id: String, date: Date) -> Expense {
    Expense(
        id: id,
        title: id,
        amount: Money(value: 1, currencyCode: "USD"),
        occurredAt: date
    )
}
