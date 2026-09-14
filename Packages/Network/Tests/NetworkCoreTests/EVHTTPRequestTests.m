#import <XCTest/XCTest.h>
#import <EVHTTPRequest.h>

@interface EVHTTPRequestTests : XCTestCase
@end

@implementation EVHTTPRequestTests

- (void)testGETRequestBuildsExpectedURLRequest {
    NSURL *URL = [NSURL URLWithString:@"https://example.com/expenses?page=1"];
    EVHTTPRequest *request = [EVHTTPRequest GETRequestWithURL:URL
                                                      headers:@{ @"Accept": @"application/json" }];

    NSURLRequest *URLRequest = [request URLRequest];

    XCTAssertEqualObjects(URLRequest.URL, URL);
    XCTAssertEqualObjects(URLRequest.HTTPMethod, @"GET");
    XCTAssertEqualObjects([URLRequest valueForHTTPHeaderField:@"Accept"], @"application/json");
    XCTAssertNil(URLRequest.HTTPBody);
}

- (void)testPOSTRequestEncodesJSONBodyAndContentType {
    NSError *error = nil;
    EVHTTPRequest *request = [EVHTTPRequest POSTRequestWithURL:[NSURL URLWithString:@"https://example.com/expenses"]
                                                        headers:@{}
                                                       JSONBody:@{ @"amount": @12.50 }
                                                          error:&error];

    XCTAssertNotNil(request);
    XCTAssertNil(error);
    XCTAssertEqualObjects(request.URLRequest.HTTPMethod, @"POST");
    XCTAssertEqualObjects([request.URLRequest valueForHTTPHeaderField:@"Content-Type"], @"application/json");

    NSDictionary *body = [NSJSONSerialization JSONObjectWithData:request.URLRequest.HTTPBody
                                                         options:0
                                                           error:&error];
    XCTAssertEqualObjects(body[@"amount"], @12.50);
    XCTAssertNil(error);
}

@end
