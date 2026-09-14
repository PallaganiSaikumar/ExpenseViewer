#import <Foundation/Foundation.h>
#import "EVHTTPRequest.h"

NS_ASSUME_NONNULL_BEGIN

/// Cancellation abstraction returned by every HTTP request.
@protocol EVHTTPTask <NSObject>
- (void)cancel;
@end

typedef void (^EVHTTPClientCompletion)(
    NSData * _Nullable data,
    NSHTTPURLResponse * _Nullable response,
    NSError * _Nullable error
);

/// Transport boundary implemented by the default URLSession client and test doubles.
@protocol EVHTTPClient <NSObject>

/// Executes a request and returns a handle that can cancel the in-flight operation.
- (id<EVHTTPTask>)executeRequest:(EVHTTPRequest *)request
                      completion:(EVHTTPClientCompletion)completion;

@end

NS_ASSUME_NONNULL_END
