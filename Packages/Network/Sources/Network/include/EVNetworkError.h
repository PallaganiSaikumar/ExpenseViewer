#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const EVNetworkErrorDomain;
FOUNDATION_EXPORT NSString *const EVNetworkErrorStatusCodeKey;
FOUNDATION_EXPORT NSString *const EVNetworkErrorResponseDataKey;

typedef NS_ERROR_ENUM(EVNetworkErrorDomain, EVNetworkErrorCode) {
    EVNetworkErrorInvalidRequest = 1,
    EVNetworkErrorTransport,
    EVNetworkErrorInvalidResponse,
    EVNetworkErrorHTTPStatus,
    EVNetworkErrorEmptyData,
    EVNetworkErrorCancelled
};

FOUNDATION_EXPORT NSError *EVMakeNetworkError(
    EVNetworkErrorCode code,
    NSString *description,
    NSDictionary<NSString *, id> * _Nullable additionalUserInfo
);

NS_ASSUME_NONNULL_END
