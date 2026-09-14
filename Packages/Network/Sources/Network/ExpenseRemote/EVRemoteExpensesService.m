#import "EVRemoteExpensesService.h"

@interface EVRemoteExpensesService ()
@property (nonatomic, copy) NSURL *endpointURL;
@property (nonatomic, strong) id<EVHTTPClient> HTTPClient;
@property (nonatomic, strong) EVExpenseParser *parser;
@end

@implementation EVRemoteExpensesService

- (instancetype)initWithEndpointURL:(NSURL *)endpointURL
                          HTTPClient:(id<EVHTTPClient>)HTTPClient
                              parser:(EVExpenseParser *)parser {
    self = [super init];
    if (self) {
        _endpointURL = [endpointURL copy];
        _HTTPClient = HTTPClient;
        _parser = parser;
    }
    return self;
}

- (id<EVHTTPTask>)fetchExpensesWithCompletion:(EVExpensesCompletion)completion {
    EVHTTPRequest *request = [EVHTTPRequest GETRequestWithURL:self.endpointURL
                                                     headers:@{ @"Accept": @"application/json" }];
    return [self.HTTPClient executeRequest:request completion:^(NSData *data,
                                                                NSHTTPURLResponse *response,
                                                                NSError *error) {
        if (error != nil) {
            completion(nil, error);
            return;
        }

        NSError *parsingError = nil;
        NSArray<EVExpenseDTO *> *expenses = [self.parser parseData:data error:&parsingError];
        completion(expenses, parsingError);
    }];
}

@end
