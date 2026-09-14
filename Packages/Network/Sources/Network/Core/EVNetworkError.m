#import "EVNetworkError.h"

NSErrorDomain const EVNetworkErrorDomain = @"com.expenseviewer.network";
NSString *const EVNetworkErrorStatusCodeKey = @"EVNetworkErrorStatusCode";
NSString *const EVNetworkErrorResponseDataKey = @"EVNetworkErrorResponseData";

NSError *EVMakeNetworkError(
    EVNetworkErrorCode code,
    NSString *description,
    NSDictionary<NSString *, id> *additionalUserInfo
) {
    NSMutableDictionary<NSString *, id> *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = description;
    if (additionalUserInfo != nil) {
        [userInfo addEntriesFromDictionary:additionalUserInfo];
    }
    return [NSError errorWithDomain:EVNetworkErrorDomain code:code userInfo:userInfo];
}
