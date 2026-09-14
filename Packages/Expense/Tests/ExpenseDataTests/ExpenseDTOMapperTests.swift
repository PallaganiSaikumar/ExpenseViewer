import Network
import Foundation
import Testing
@testable import Expense

@Test("Expense endpoint is owned by the feature and appended to the configured base URL")
func buildsExpenseEndpointFromNetworkConfiguration() {
    let configuration = DataTestNetworkConfiguration()

    let URL = ExpenseEndpoint.url(configuration: configuration)

    #expect(URL.absoluteString == "https://example.com/api/b/AMKA")
}

@Test("Objective-C DTO maps into the domain without leaking transport types")
func mapsExpenseDTO() {
    let date = Date(timeIntervalSince1970: 1_000)
    let DTO = EVExpenseDTO(
        identifier: "expense-1",
        title: "Taxi",
        amount: NSDecimalNumber(string: "24.50"),
        currencyCode: "GBP",
        date: date
    )

    let expense = ExpenseDTOMapper().map(DTO)

    #expect(expense.id == "expense-1")
    #expect(expense.title == "Taxi")
    #expect(expense.amount == Money(value: Decimal(string: "24.50")!, currencyCode: "GBP"))
    #expect(expense.occurredAt == date)
}

@Test("Repository maps a missing remote result to invalid data")
func repositoryRejectsMissingResult() async {
    let repository = RemoteExpenseRepository(
        service: ExpensesServiceStub(expenses: nil, error: nil)
    )

    await #expect(throws: ExpenseDataError.invalidData) {
        try await repository.expenses()
    }
}

private final class HTTPTaskStub: NSObject, EVHTTPTask {
    func cancel() {}
}

private final class ExpensesServiceStub: NSObject, EVExpensesServicing {
    let expenses: [EVExpenseDTO]?
    let error: Error?

    init(expenses: [EVExpenseDTO]?, error: Error?) {
        self.expenses = expenses
        self.error = error
    }

    func fetchExpenses(
        completion: @escaping EVExpensesCompletion
    ) -> any EVHTTPTask {
        completion(expenses, error)
        return HTTPTaskStub()
    }
}

private final class DataTestNetworkConfiguration: NSObject, NetworkConfiguration {
    let baseURL = URL(string: "https://example.com/api")!
    let requestTimeout: TimeInterval = 1
}
