#import <XCTest/XCTest.h>
#import <EVExpenseParser.h>
#import <EVExpensesRemoteError.h>

@interface EVExpenseParserTests : XCTestCase
@end

@implementation EVExpenseParserTests

- (void)testParsesExpenseArrayAndSupportedValueTypes {
    NSData *data = [@"[{\"id\":42,\"name\":\"Train ticket\",\"amount\":\"18.75\",\"currency\":\"eur\",\"date\":\"2026-09-13T10:30:00Z\"}]"
        dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;

    NSArray<EVExpenseDTO *> *expenses = [[[EVExpenseParser alloc] init] parseData:data error:&error];

    XCTAssertNil(error);
    XCTAssertEqual(expenses.count, 1);
    XCTAssertEqualObjects(expenses.firstObject.identifier, @"42");
    XCTAssertEqualObjects(expenses.firstObject.title, @"Train ticket");
    XCTAssertEqualObjects(expenses.firstObject.amount, [NSDecimalNumber decimalNumberWithString:@"18.75"]);
    XCTAssertEqualObjects(expenses.firstObject.currencyCode, @"EUR");
    XCTAssertNotNil(expenses.firstObject.date);
}

- (void)testParsesWrappedExpenseArrayAndDayOnlyDate {
    NSData *data = [@"{\"expenses\":[{\"title\":\"Lunch\",\"amount\":12.5,\"date\":\"2026-09-12\"}]}"
        dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;

    NSArray<EVExpenseDTO *> *expenses = [[[EVExpenseParser alloc] init] parseData:data error:&error];

    XCTAssertNil(error);
    XCTAssertEqual(expenses.count, 1);
    XCTAssertEqualObjects(expenses.firstObject.identifier, @"expense-0");
    XCTAssertEqualObjects(expenses.firstObject.currencyCode, @"USD");
}

- (void)testRejectsMalformedExpense {
    NSData *data = [@"[{\"title\":\"Missing amount and date\"}]" dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;

    NSArray<EVExpenseDTO *> *expenses = [[[EVExpenseParser alloc] init] parseData:data error:&error];

    XCTAssertNil(expenses);
    XCTAssertEqualObjects(error.domain, EVExpensesRemoteErrorDomain);
    XCTAssertEqual(error.code, EVExpensesRemoteErrorInvalidExpense);
}

- (void)testRejectsUnexpectedRootObject {
    NSData *data = [@"{\"unexpected\":[]}" dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;

    NSArray<EVExpenseDTO *> *expenses = [[[EVExpenseParser alloc] init] parseData:data error:&error];

    XCTAssertNil(expenses);
    XCTAssertEqual(error.code, EVExpensesRemoteErrorInvalidPayload);
}

@end
