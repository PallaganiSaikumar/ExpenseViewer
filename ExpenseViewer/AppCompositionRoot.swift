import Expense

/// The only place where the app assembles concrete feature dependencies.
@MainActor
enum AppCompositionRoot {
    static let expenseAPI = ExpenseAPIClient(
        configuration: AppNetworkConfiguration()
    )
}
