import Network
import Foundation

struct ExpenseDTOMapper {
    func map(_ DTO: EVExpenseDTO) -> Expense {
        Expense(
            id: DTO.identifier,
            title: DTO.title,
            amount: Money(
                value: DTO.amount.decimalValue,
                currencyCode: DTO.currencyCode
            ),
            occurredAt: DTO.date
        )
    }
}
