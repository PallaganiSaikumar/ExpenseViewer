#import <Foundation/Foundation.h>
#import <EVHTTPClient.h>
#import "EVExpenseParser.h"
#import "EVExpensesServicing.h"

NS_ASSUME_NONNULL_BEGIN

@interface EVRemoteExpensesService : NSObject <EVExpensesServicing>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithEndpointURL:(NSURL *)endpointURL
                          HTTPClient:(id<EVHTTPClient>)HTTPClient
                              parser:(EVExpenseParser *)parser NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
