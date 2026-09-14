import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(expense.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(expense.occurredAt, format: .dateTime.day().month(.abbreviated).year())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Text(
                expense.amount.value,
                format: .currency(code: expense.amount.currencyCode)
            )
            .font(.headline.monospacedDigit())
            .foregroundStyle(.primary)
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
    }
}
