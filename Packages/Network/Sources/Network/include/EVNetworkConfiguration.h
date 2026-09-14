#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Environment-level values required to create the default network client.
/// Feature endpoint paths are deliberately not part of this configuration.
@protocol EVNetworkConfiguration <NSObject>

/// Base URL shared by API features, for example `https://api.example.com`.
@property (nonatomic, copy, readonly) NSURL *baseURL;

/// Maximum time, in seconds, allowed for an individual request.
@property (nonatomic, assign, readonly) NSTimeInterval requestTimeout;

@end

NS_ASSUME_NONNULL_END
