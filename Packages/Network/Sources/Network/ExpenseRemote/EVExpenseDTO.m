#import "EVExpenseDTO.h"

@implementation EVExpenseDTO

- (instancetype)initWithIdentifier:(NSString *)identifier
                              title:(NSString *)title
                             amount:(NSDecimalNumber *)amount
                       currencyCode:(NSString *)currencyCode
                               date:(NSDate *)date {
    self = [super init];
    if (self) {
        _identifier = [identifier copy];
        _title = [title copy];
        _amount = [amount copy];
        _currencyCode = [currencyCode copy];
        _date = [date copy];
    }
    return self;
}

@end
