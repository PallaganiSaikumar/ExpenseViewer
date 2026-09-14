import SwiftUI

struct ExpenseErrorView: View {
    let message: String
    let retry: () async -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Unable to Load Expenses", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again") {
                Task { await retry() }
            }
            .buttonStyle(.borderedProminent)
        }
        .accessibilityIdentifier("expenses.error")
    }
}
