#import <Foundation/Foundation.h>
#import "EVHTTPMethod.h"

NS_ASSUME_NONNULL_BEGIN

/// Immutable, transport-independent representation of an HTTP request.
@interface EVHTTPRequest : NSObject

@property (nonatomic, copy, readonly) NSURL *URL;
@property (nonatomic, assign, readonly) EVHTTPMethod method;
@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *headers;
@property (nonatomic, copy, nullable, readonly) NSData *body;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithURL:(NSURL *)URL
                      method:(EVHTTPMethod)method
                     headers:(NSDictionary<NSString *, NSString *> *)headers
                        body:(NSData * _Nullable)body NS_DESIGNATED_INITIALIZER;

/// Creates a GET request with the supplied headers.
+ (instancetype)GETRequestWithURL:(NSURL *)URL
                          headers:(NSDictionary<NSString *, NSString *> *)headers;

/// Creates a POST request by serializing a Foundation JSON object.
/// Returns `nil` and populates `error` when the body cannot be serialized.
+ (nullable instancetype)POSTRequestWithURL:(NSURL *)URL
                                    headers:(NSDictionary<NSString *, NSString *> *)headers
                                   JSONBody:(id)JSONBody
                                      error:(NSError **)error;

/// Converts this value into the Foundation request consumed by URLSession.
- (NSURLRequest *)URLRequest;

@end

NS_ASSUME_NONNULL_END
