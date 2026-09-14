#import <Foundation/Foundation.h>
#import <EVHTTPClient.h>
#import <EVNetworkConfiguration.h>
#import "EVExpensesServicing.h"

NS_ASSUME_NONNULL_BEGIN

/// Constructs the expense remote facade without exposing its concrete collaborators.
@interface EVExpensesServiceFactory : NSObject

/// Production factory backed by the default URLSession HTTP client.
+ (id<EVExpensesServicing>)makeDefaultServiceWithEndpointURL:(NSURL *)endpointURL
                                       networkConfiguration:(id<EVNetworkConfiguration>)networkConfiguration
    NS_SWIFT_NAME(makeDefault(endpointURL:networkConfiguration:));

/// Injectable factory for tests and alternate HTTP client implementations.
+ (id<EVExpensesServicing>)makeServiceWithEndpointURL:(NSURL *)endpointURL
                                           HTTPClient:(id<EVHTTPClient>)HTTPClient
    NS_SWIFT_NAME(make(endpointURL:httpClient:));

@end

NS_ASSUME_NONNULL_END
