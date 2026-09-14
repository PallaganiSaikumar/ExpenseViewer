import SwiftUI

struct ExpenseEmptyView: View {
    let retry: () async -> Void

    var body: some View {
        ContentUnavailableView {
            Label("No Expenses", systemImage: "tray")
        } description: {
            Text("There are no expenses to display.")
        } actions: {
            Button("Refresh") {
                Task { await retry() }
            }
            .buttonStyle(.borderedProminent)
        }
        .accessibilityIdentifier("expenses.empty")
    }
}
