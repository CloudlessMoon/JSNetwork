//
//  JSNetworkResponse.m
//  JSNetwork
//
//  Created by jiasong on 2020/4/17.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import "JSNetworkResponse.h"
#import "JSNetworkResponseProtocol.h"
#import "JSNetworkUtil.h"

@interface JSNetworkResponse () {
    NSURLSessionTask *_requestTask;
    NSError *_error;
    id _responseObject;
}

@end

@implementation JSNetworkResponse

- (void)processingTask:(NSURLSessionTask *)task
        responseObject:(nullable id)responseObject
                 error:(nullable NSError *)error {
    _requestTask = task;
    _error = error;
    _responseObject = responseObject;
}

- (nullable NSString *)responseURLString {
    return self.originalResponse.URL.absoluteString;
}

- (nullable NSDictionary<NSString *, NSString *> *)responseHeaders {
    NSURLResponse *originalResponse = self.originalResponse;
    if ([originalResponse isKindOfClass:NSHTTPURLResponse.class]) {
        return [(NSHTTPURLResponse *)originalResponse allHeaderFields];
    }
    return nil;
}

- (NSInteger)responseStatusCode {
    NSURLResponse *originalResponse = self.originalResponse;
    if ([originalResponse isKindOfClass:NSHTTPURLResponse.class]) {
        return [(NSHTTPURLResponse *)originalResponse statusCode];
    }
    return 0;
}

- (nullable id)responseObject {
    return _responseObject;
}

- (nullable NSError *)error {
    return _error;
}

- (nullable NSURLResponse *)originalResponse {
    return _requestTask.response;
}

- (BOOL)networkingAbnormal {
    return self.error.code == -1009 || self.error.code == -1001;
}

- (void)dealloc {
    JSNetworkLog(@"%@ - 已经释放", NSStringFromClass([self class]));
}

@end
