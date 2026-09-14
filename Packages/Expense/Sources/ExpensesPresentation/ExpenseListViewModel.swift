import Combine
import Foundation

@MainActor
final class ExpenseListViewModel: ObservableObject {
    @Published private(set) var state: ExpenseListState = .idle

    private let getExpenses: any GetExpensesUseCase
    private var hasLoaded = false

    init(getExpenses: any GetExpensesUseCase) {
        self.getExpenses = getExpenses
    }

    /// Prevents SwiftUI lifecycle updates from starting duplicate initial requests.
    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        await load()
    }

    func load() async {
        state = .loading

        do {
            let expenses = try await getExpenses.execute()
            state = expenses.isEmpty ? .empty : .loaded(expenses)
        } catch is CancellationError {
            hasLoaded = false
            state = .idle
        } catch {
            state = .failed(message: error.localizedDescription)
        }
    }
}
