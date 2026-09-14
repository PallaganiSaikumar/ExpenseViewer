#import <Foundation/Foundation.h>
#import "EVHTTPClient.h"
#import "EVNetworkConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/// URLSession-backed HTTP client that normalizes transport and HTTP failures into `EVNetworkError`.
@interface EVURLSessionHTTPClient : NSObject <EVHTTPClient>

/// Creates a client with the package's default timeout.
- (instancetype)init;

/// Creates a client using app-provided environment settings.
- (instancetype)initWithNetworkConfiguration:(id<EVNetworkConfiguration>)networkConfiguration;

/// Creates a client with an injected session, primarily for deterministic tests.
- (instancetype)initWithSession:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
