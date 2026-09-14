import Foundation
import Testing
@testable import Expense

@MainActor
@Test("Loading succeeds with expenses")
func loadingSuccess() async {
    let expense = Expense(
        id: "1",
        title: "Coffee",
        amount: Money(value: 4.50, currencyCode: "USD"),
        occurredAt: Date()
    )
    let viewModel = ExpenseListViewModel(
        getExpenses: UseCaseStub(result: .success([expense]))
    )

    await viewModel.load()

    #expect(viewModel.state == .loaded([expense]))
}

@MainActor
@Test("An empty response produces the empty state")
func loadingEmptyResponse() async {
    let viewModel = ExpenseListViewModel(
        getExpenses: UseCaseStub(result: .success([]))
    )

    await viewModel.load()

    #expect(viewModel.state == .empty)
}

@MainActor
@Test("An error produces a user-readable failure state")
func loadingFailure() async {
    let viewModel = ExpenseListViewModel(
        getExpenses: UseCaseStub(result: .failure(TestError()))
    )

    await viewModel.load()

    #expect(viewModel.state == .failed(message: "Something went wrong."))
}

private struct UseCaseStub: GetExpensesUseCase {
    let result: Result<[Expense], Error>

    func execute() async throws -> [Expense] {
        try result.get()
    }
}

private struct TestError: LocalizedError {
    var errorDescription: String? {
        "Something went wrong."
    }
}
