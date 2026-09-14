import SwiftUI

struct ExpenseListView: View {
    @StateObject private var viewModel: ExpenseListViewModel

    init(viewModel: @autoclosure @escaping () -> ExpenseListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Expenses")
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ExpenseLoadingView()
        case let .loaded(expenses):
            List(expenses) { expense in
                ExpenseRowView(expense: expense)
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.load()
            }
        case .empty:
            ExpenseEmptyView {
                await viewModel.load()
            }
        case let .failed(message):
            ExpenseErrorView(message: message) {
                await viewModel.load()
            }
        }
    }
}
