enum ExpenseListState: Equatable {
    case idle
    case loading
    case loaded([Expense])
    case empty
    case failed(message: String)
}
