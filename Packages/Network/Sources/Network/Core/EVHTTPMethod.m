#import "EVHTTPMethod.h"

NSString *EVHTTPMethodName(EVHTTPMethod method) {
    switch (method) {
        case EVHTTPMethodGET:
            return @"GET";
        case EVHTTPMethodPOST:
            return @"POST";
    }
}
