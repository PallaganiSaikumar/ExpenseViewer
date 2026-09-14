#import "EVHTTPRequest.h"

@implementation EVHTTPRequest

- (instancetype)initWithURL:(NSURL *)URL
                      method:(EVHTTPMethod)method
                     headers:(NSDictionary<NSString *,NSString *> *)headers
                        body:(NSData *)body {
    self = [super init];
    if (self) {
        _URL = [URL copy];
        _method = method;
        _headers = [headers copy];
        _body = [body copy];
    }
    return self;
}

+ (instancetype)GETRequestWithURL:(NSURL *)URL
                          headers:(NSDictionary<NSString *,NSString *> *)headers {
    return [[self alloc] initWithURL:URL
                              method:EVHTTPMethodGET
                             headers:headers
                                body:nil];
}

+ (instancetype)POSTRequestWithURL:(NSURL *)URL
                            headers:(NSDictionary<NSString *,NSString *> *)headers
                           JSONBody:(id)JSONBody
                              error:(NSError **)error {
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSONBody options:0 error:error];
    if (body == nil) {
        return nil;
    }

    NSMutableDictionary<NSString *, NSString *> *allHeaders = [headers mutableCopy];
    if (allHeaders[@"Content-Type"] == nil) {
        allHeaders[@"Content-Type"] = @"application/json";
    }

    return [[self alloc] initWithURL:URL
                              method:EVHTTPMethodPOST
                             headers:allHeaders
                                body:body];
}

- (NSURLRequest *)URLRequest {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.URL];
    request.HTTPMethod = EVHTTPMethodName(self.method);
    request.HTTPBody = self.body;
    [self.headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    return [request copy];
}

@end
