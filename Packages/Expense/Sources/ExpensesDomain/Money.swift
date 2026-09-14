import Foundation

struct Money: Equatable, Sendable {
    let value: Decimal
    let currencyCode: String

    init(value: Decimal, currencyCode: String) {
        self.value = value
        self.currencyCode = currencyCode.uppercased()
    }
}
