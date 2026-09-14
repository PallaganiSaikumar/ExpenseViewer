#import <Foundation/Foundation.h>
#import "EVExpenseDTO.h"

NS_ASSUME_NONNULL_BEGIN

/// Validates and transforms the remote JSON payload into typed expense DTOs.
@interface EVExpenseParser : NSObject

/// Returns parsed expenses or a typed `EVExpensesRemoteError` for an invalid payload.
- (nullable NSArray<EVExpenseDTO *> *)parseData:(NSData *)data
                                          error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
