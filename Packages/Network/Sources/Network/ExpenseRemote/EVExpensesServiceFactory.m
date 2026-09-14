#import "EVExpensesServiceFactory.h"
#import <EVURLSessionHTTPClient.h>
#import "EVExpenseParser.h"
#import "EVRemoteExpensesService.h"

@implementation EVExpensesServiceFactory

+ (id<EVExpensesServicing>)makeDefaultServiceWithEndpointURL:(NSURL *)endpointURL
                                       networkConfiguration:(id<EVNetworkConfiguration>)networkConfiguration {
    return [self makeServiceWithEndpointURL:endpointURL
                                 HTTPClient:[[EVURLSessionHTTPClient alloc]
                                                initWithNetworkConfiguration:networkConfiguration]];
}

+ (id<EVExpensesServicing>)makeServiceWithEndpointURL:(NSURL *)endpointURL
                                           HTTPClient:(id<EVHTTPClient>)HTTPClient {
    return [[EVRemoteExpensesService alloc] initWithEndpointURL:endpointURL
                                                    HTTPClient:HTTPClient
                                                        parser:[[EVExpenseParser alloc] init]];
}

@end
