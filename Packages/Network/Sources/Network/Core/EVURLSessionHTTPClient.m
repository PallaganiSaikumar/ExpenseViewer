#import "EVURLSessionHTTPClient.h"
#import "EVNetworkError.h"

@interface EVURLSessionTaskAdapter : NSObject <EVHTTPTask>
- (instancetype)initWithTask:(NSURLSessionTask *)task;
@end

@interface EVURLSessionTaskAdapter ()
@property (nonatomic, strong) NSURLSessionTask *task;
@end

@implementation EVURLSessionTaskAdapter

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    self = [super init];
    if (self) {
        _task = task;
    }
    return self;
}

- (void)cancel {
    [self.task cancel];
}

@end

@interface EVURLSessionHTTPClient ()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation EVURLSessionHTTPClient

- (instancetype)init {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 30;
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    return [self initWithSession:[NSURLSession sessionWithConfiguration:configuration]];
}

- (instancetype)initWithNetworkConfiguration:(id<EVNetworkConfiguration>)networkConfiguration {
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForRequest = networkConfiguration.requestTimeout;
    sessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    return [self initWithSession:[NSURLSession sessionWithConfiguration:sessionConfiguration]];
}

- (instancetype)initWithSession:(NSURLSession *)session {
    self = [super init];
    if (self) {
        _session = session;
    }
    return self;
}

- (id<EVHTTPTask>)executeRequest:(EVHTTPRequest *)request
                      completion:(EVHTTPClientCompletion)completion {
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:[request URLRequest]
                                                 completionHandler:^(NSData *data,
                                                                     NSURLResponse *response,
                                                                     NSError *error) {
        if (error != nil) {
            EVNetworkErrorCode code = error.code == NSURLErrorCancelled
                ? EVNetworkErrorCancelled
                : EVNetworkErrorTransport;
            completion(nil, nil, EVMakeNetworkError(
                code,
                error.localizedDescription,
                @{ NSUnderlyingErrorKey: error }
            ));
            return;
        }

        if (![response isKindOfClass:NSHTTPURLResponse.class]) {
            completion(nil, nil, EVMakeNetworkError(
                EVNetworkErrorInvalidResponse,
                @"The server returned an invalid response.",
                nil
            ));
            return;
        }

        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        if (HTTPResponse.statusCode < 200 || HTTPResponse.statusCode >= 300) {
            NSMutableDictionary<NSString *, id> *details = [NSMutableDictionary dictionary];
            details[EVNetworkErrorStatusCodeKey] = @(HTTPResponse.statusCode);
            if (data != nil) {
                details[EVNetworkErrorResponseDataKey] = data;
            }
            NSString *message = [NSHTTPURLResponse localizedStringForStatusCode:HTTPResponse.statusCode];
            completion(nil, HTTPResponse, EVMakeNetworkError(
                EVNetworkErrorHTTPStatus,
                [NSString stringWithFormat:@"Server request failed: %@.", message],
                details
            ));
            return;
        }

        if (data == nil) {
            completion(nil, HTTPResponse, EVMakeNetworkError(
                EVNetworkErrorEmptyData,
                @"The server returned no data.",
                nil
            ));
            return;
        }

        completion(data, HTTPResponse, nil);
    }];
    [task resume];
    return [[EVURLSessionTaskAdapter alloc] initWithTask:task];
}

@end
