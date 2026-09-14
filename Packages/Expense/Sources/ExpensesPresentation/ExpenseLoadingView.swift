import SwiftUI

struct ExpenseLoadingView: View {
    var body: some View {
        ProgressView("Loading expenses…")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accessibilityIdentifier("expenses.loading")
    }
}
