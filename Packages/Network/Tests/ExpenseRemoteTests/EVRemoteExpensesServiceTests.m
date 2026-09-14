#import <XCTest/XCTest.h>
#import <EVExpensesServiceFactory.h>
#import <EVNetworkError.h>

@interface EVHTTPTaskStub : NSObject <EVHTTPTask>
@end

@implementation EVHTTPTaskStub
- (void)cancel {}
@end

@interface EVHTTPClientStub : NSObject <EVHTTPClient>
@property (nonatomic, copy, nullable) NSData *data;
@property (nonatomic, strong, nullable) NSError *error;
@property (nonatomic, strong, nullable) EVHTTPRequest *capturedRequest;
@end

@implementation EVHTTPClientStub

- (id<EVHTTPTask>)executeRequest:(EVHTTPRequest *)request completion:(EVHTTPClientCompletion)completion {
    self.capturedRequest = request;
    completion(self.data, nil, self.error);
    return [[EVHTTPTaskStub alloc] init];
}

@end

@interface EVRemoteExpensesServiceTests : XCTestCase
@end

@implementation EVRemoteExpensesServiceTests

- (void)testServiceBuildsGETRequestAndTransformsResponse {
    EVHTTPClientStub *client = [[EVHTTPClientStub alloc] init];
    client.data = [@"[{\"title\":\"Hotel\",\"amount\":125,\"date\":\"2026-09-10\"}]"
        dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *endpointURL = [NSURL URLWithString:@"https://example.com/expenses"];
    id<EVExpensesServicing> service = [EVExpensesServiceFactory makeServiceWithEndpointURL:endpointURL
                                                                                HTTPClient:client];
    __block NSArray<EVExpenseDTO *> *receivedExpenses = nil;
    __block NSError *receivedError = nil;

    [service fetchExpensesWithCompletion:^(NSArray<EVExpenseDTO *> *expenses, NSError *error) {
        receivedExpenses = expenses;
        receivedError = error;
    }];

    XCTAssertNil(receivedError);
    XCTAssertEqual(receivedExpenses.count, 1);
    XCTAssertEqualObjects(receivedExpenses.firstObject.title, @"Hotel");
    XCTAssertEqual(client.capturedRequest.method, EVHTTPMethodGET);
    XCTAssertEqualObjects(client.capturedRequest.URL, endpointURL);
}

- (void)testServiceForwardsNetworkErrorWithoutParsing {
    EVHTTPClientStub *client = [[EVHTTPClientStub alloc] init];
    client.error = EVMakeNetworkError(EVNetworkErrorHTTPStatus, @"Not found.", nil);
    id<EVExpensesServicing> service = [EVExpensesServiceFactory
        makeServiceWithEndpointURL:[NSURL URLWithString:@"https://example.com/expenses"]
                        HTTPClient:client];
    __block NSArray<EVExpenseDTO *> *receivedExpenses = nil;
    __block NSError *receivedError = nil;

    [service fetchExpensesWithCompletion:^(NSArray<EVExpenseDTO *> *expenses, NSError *error) {
        receivedExpenses = expenses;
        receivedError = error;
    }];

    XCTAssertNil(receivedExpenses);
    XCTAssertEqualObjects(receivedError, client.error);
}

@end
