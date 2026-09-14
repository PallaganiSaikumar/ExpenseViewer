#import <XCTest/XCTest.h>
#import <EVNetworkError.h>
#import <EVURLSessionHTTPClient.h>

typedef void (^EVURLProtocolHandler)(NSURLRequest *, id<NSURLProtocolClient>, NSURLProtocol *);

@interface EVURLProtocolStub : NSURLProtocol
@property (class, nonatomic, copy, nullable) EVURLProtocolHandler handler;
@end

static EVURLProtocolHandler _handler;

@implementation EVURLProtocolStub

+ (EVURLProtocolHandler)handler {
    return _handler;
}

+ (void)setHandler:(EVURLProtocolHandler)handler {
    _handler = [handler copy];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    EVURLProtocolStub.handler(self.request, self.client, self);
}

- (void)stopLoading {}

@end

@interface EVURLSessionHTTPClientTests : XCTestCase
@end

@implementation EVURLSessionHTTPClientTests

- (void)tearDown {
    EVURLProtocolStub.handler = nil;
    [super tearDown];
}

- (void)testSuccessfulResponseReturnsDataAndHTTPResponse {
    NSData *expectedData = [@"[]" dataUsingEncoding:NSUTF8StringEncoding];
    EVURLProtocolStub.handler = ^(NSURLRequest *request, id<NSURLProtocolClient> client, NSURLProtocol *protocol) {
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                                 statusCode:200
                                                                HTTPVersion:@"HTTP/1.1"
                                                               headerFields:@{ @"Content-Type": @"application/json" }];
        [client URLProtocol:protocol didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [client URLProtocol:protocol didLoadData:expectedData];
        [client URLProtocolDidFinishLoading:protocol];
    };
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request completes"];
    EVURLSessionHTTPClient *client = [self makeClient];
    EVHTTPRequest *request = [EVHTTPRequest GETRequestWithURL:[NSURL URLWithString:@"https://example.com/expenses"]
                                                      headers:@{}];

    [client executeRequest:request completion:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertEqualObjects(data, expectedData);
        XCTAssertEqual(response.statusCode, 200);
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testNonSuccessfulResponseProducesTypedError {
    EVURLProtocolStub.handler = ^(NSURLRequest *request, id<NSURLProtocolClient> client, NSURLProtocol *protocol) {
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                                 statusCode:404
                                                                HTTPVersion:@"HTTP/1.1"
                                                               headerFields:nil];
        [client URLProtocol:protocol didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [client URLProtocol:protocol didLoadData:[@"{\"status\":404}" dataUsingEncoding:NSUTF8StringEncoding]];
        [client URLProtocolDidFinishLoading:protocol];
    };
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request completes"];
    EVURLSessionHTTPClient *client = [self makeClient];
    EVHTTPRequest *request = [EVHTTPRequest GETRequestWithURL:[NSURL URLWithString:@"https://example.com/missing"]
                                                      headers:@{}];

    [client executeRequest:request completion:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNil(data);
        XCTAssertEqual(response.statusCode, 404);
        XCTAssertEqualObjects(error.domain, EVNetworkErrorDomain);
        XCTAssertEqual(error.code, EVNetworkErrorHTTPStatus);
        XCTAssertEqualObjects(error.userInfo[EVNetworkErrorStatusCodeKey], @404);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testTransportFailurePreservesUnderlyingError {
    NSError *offlineError = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:NSURLErrorNotConnectedToInternet
                                             userInfo:nil];
    EVURLProtocolStub.handler = ^(NSURLRequest *request, id<NSURLProtocolClient> client, NSURLProtocol *protocol) {
        [client URLProtocol:protocol didFailWithError:offlineError];
    };
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request completes"];
    EVURLSessionHTTPClient *client = [self makeClient];
    EVHTTPRequest *request = [EVHTTPRequest GETRequestWithURL:[NSURL URLWithString:@"https://example.com/expenses"]
                                                      headers:@{}];

    [client executeRequest:request completion:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNil(data);
        XCTAssertNil(response);
        XCTAssertEqualObjects(error.domain, EVNetworkErrorDomain);
        XCTAssertEqual(error.code, EVNetworkErrorTransport);
        NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
        XCTAssertEqualObjects(underlyingError.domain, NSURLErrorDomain);
        XCTAssertEqual(underlyingError.code, NSURLErrorNotConnectedToInternet);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:1];
}

- (EVURLSessionHTTPClient *)makeClient {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.protocolClasses = @[EVURLProtocolStub.class];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    return [[EVURLSessionHTTPClient alloc] initWithSession:session];
}

@end
