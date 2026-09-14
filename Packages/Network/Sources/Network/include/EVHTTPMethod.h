#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EVHTTPMethod) {
    EVHTTPMethodGET,
    EVHTTPMethodPOST
};

FOUNDATION_EXPORT NSString *EVHTTPMethodName(EVHTTPMethod method);

NS_ASSUME_NONNULL_END
