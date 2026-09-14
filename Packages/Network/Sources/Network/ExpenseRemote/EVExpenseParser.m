#import "EVExpenseParser.h"
#import "EVExpensesRemoteError.h"

@implementation EVExpenseParser

- (NSArray<EVExpenseDTO *> *)parseData:(NSData *)data error:(NSError **)error {
    id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (JSON == nil) {
        return nil;
    }

    NSArray *expenseObjects = [self expenseArrayFromJSON:JSON];
    if (expenseObjects == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:EVExpensesRemoteErrorDomain
                                         code:EVExpensesRemoteErrorInvalidPayload
                                     userInfo:@{ NSLocalizedDescriptionKey:
                                                     @"Expected an expense array or an object containing an expenses array." }];
        }
        return nil;
    }

    NSMutableArray<EVExpenseDTO *> *expenses = [NSMutableArray arrayWithCapacity:expenseObjects.count];
    for (NSUInteger index = 0; index < expenseObjects.count; index++) {
        id value = expenseObjects[index];
        if (![value isKindOfClass:NSDictionary.class]) {
            return [self failAtIndex:index reason:@"Expected an object." error:error];
        }

        NSDictionary *object = (NSDictionary *)value;
        NSString *title = [self stringInObject:object keys:@[@"title", @"name", @"description", @"merchant"]];
        NSDecimalNumber *amount = [self decimalInObject:object keys:@[@"amount", @"value", @"price"]];
        NSDate *date = [self dateInObject:object keys:@[@"date", @"expenseDate", @"createdAt", @"created_at"]];

        if (title.length == 0 || amount == nil || date == nil) {
            return [self failAtIndex:index
                              reason:@"Each expense requires a title, a valid amount, and a valid date."
                               error:error];
        }

        NSString *identifier = [self stringInObject:object
                                                keys:@[@"id", @"expenseId", @"expense_id"]];
        if (identifier.length == 0) {
            identifier = [NSString stringWithFormat:@"expense-%lu", (unsigned long)index];
        }

        NSString *currencyCode = [self stringInObject:object
                                                  keys:@[@"currency", @"currencyCode", @"currency_code"]];
        if (currencyCode.length == 0) {
            currencyCode = @"USD";
        }

        EVExpenseDTO *expense = [[EVExpenseDTO alloc] initWithIdentifier:identifier
                                                                   title:title
                                                                  amount:amount
                                                            currencyCode:currencyCode.uppercaseString
                                                                    date:date];
        [expenses addObject:expense];
    }
    return [expenses copy];
}

- (NSArray *)expenseArrayFromJSON:(id)JSON {
    if ([JSON isKindOfClass:NSArray.class]) {
        return JSON;
    }
    if (![JSON isKindOfClass:NSDictionary.class]) {
        return nil;
    }

    NSDictionary *object = (NSDictionary *)JSON;
    id expenses = object[@"expenses"] ?: object[@"data"];
    return [expenses isKindOfClass:NSArray.class] ? expenses : nil;
}

- (NSString *)stringInObject:(NSDictionary *)object keys:(NSArray<NSString *> *)keys {
    for (NSString *key in keys) {
        id value = object[key];
        if ([value isKindOfClass:NSString.class]) {
            return [(NSString *)value stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        }
        if ([value isKindOfClass:NSNumber.class]) {
            return [(NSNumber *)value stringValue];
        }
    }
    return nil;
}

- (NSDecimalNumber *)decimalInObject:(NSDictionary *)object keys:(NSArray<NSString *> *)keys {
    for (NSString *key in keys) {
        id value = object[key];
        NSDecimalNumber *number = nil;
        if ([value isKindOfClass:NSNumber.class]) {
            number = [NSDecimalNumber decimalNumberWithDecimal:[(NSNumber *)value decimalValue]];
        } else if ([value isKindOfClass:NSString.class]) {
            NSString *normalized = [(NSString *)value stringByReplacingOccurrencesOfString:@"," withString:@""];
            number = [NSDecimalNumber decimalNumberWithString:normalized
                                                       locale:@{ NSLocaleDecimalSeparator: @"." }];
        }
        if (number != nil && ![number isEqualToNumber:NSDecimalNumber.notANumber]) {
            return number;
        }
    }
    return nil;
}

- (NSDate *)dateInObject:(NSDictionary *)object keys:(NSArray<NSString *> *)keys {
    NSString *value = [self stringInObject:object keys:keys];
    if (value.length == 0) {
        return nil;
    }

    NSISO8601DateFormatter *ISOFormatter = [[NSISO8601DateFormatter alloc] init];
    ISOFormatter.formatOptions = NSISO8601DateFormatWithInternetDateTime | NSISO8601DateFormatWithFractionalSeconds;
    NSDate *date = [ISOFormatter dateFromString:value];
    if (date != nil) {
        return date;
    }

    ISOFormatter.formatOptions = NSISO8601DateFormatWithInternetDateTime;
    date = [ISOFormatter dateFromString:value];
    if (date != nil) {
        return date;
    }

    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    dayFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dayFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    dayFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    dayFormatter.dateFormat = @"yyyy-MM-dd";
    return [dayFormatter dateFromString:value];
}

- (NSArray<EVExpenseDTO *> *)failAtIndex:(NSUInteger)index
                                  reason:(NSString *)reason
                                   error:(NSError **)error {
    if (error != NULL) {
        *error = [NSError errorWithDomain:EVExpensesRemoteErrorDomain
                                     code:EVExpensesRemoteErrorInvalidExpense
                                 userInfo:@{ NSLocalizedDescriptionKey:
                                                 [NSString stringWithFormat:@"Invalid expense at index %lu. %@",
                                                                             (unsigned long)index,
                                                                             reason] }];
    }
    return nil;
}

@end
