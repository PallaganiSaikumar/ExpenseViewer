#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const EVExpensesRemoteErrorDomain;

typedef NS_ERROR_ENUM(EVExpensesRemoteErrorDomain, EVExpensesRemoteErrorCode) {
    EVExpensesRemoteErrorInvalidPayload = 1,
    EVExpensesRemoteErrorInvalidExpense
};

NS_ASSUME_NONNULL_END
