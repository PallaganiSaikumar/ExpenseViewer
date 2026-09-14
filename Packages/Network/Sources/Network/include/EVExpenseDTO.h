#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Objective-C transport model produced by `EVExpenseParser`.
@interface EVExpenseDTO : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSDecimalNumber *amount;
@property (nonatomic, copy, readonly) NSString *currencyCode;
@property (nonatomic, copy, readonly) NSDate *date;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithIdentifier:(NSString *)identifier
                              title:(NSString *)title
                             amount:(NSDecimalNumber *)amount
                       currencyCode:(NSString *)currencyCode
                               date:(NSDate *)date NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
