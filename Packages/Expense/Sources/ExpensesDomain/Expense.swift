import Foundation

struct Expense: Identifiable, Equatable, Sendable {
    let id: String
    let title: String
    let amount: Money
    let occurredAt: Date

}
