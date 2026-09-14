#import <Foundation/Foundation.h>
#import <EVHTTPClient.h>
#import "EVExpenseDTO.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^EVExpensesCompletion)(
    NSArray<EVExpenseDTO *> * _Nullable expenses,
    NSError * _Nullable error
);

/// Expense-specific remote facade exposed to the Swift data layer.
@protocol EVExpensesServicing <NSObject>

/// Fetches and transforms remote JSON into Objective-C expense DTOs.
- (id<EVHTTPTask>)fetchExpensesWithCompletion:(EVExpensesCompletion)completion
    NS_SWIFT_NAME(fetchExpenses(completion:));

@end

NS_ASSUME_NONNULL_END
