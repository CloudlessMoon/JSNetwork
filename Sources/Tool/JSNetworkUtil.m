//
//  JSNetworkUtil.m
//  JSNetwork
//
//  Created by jiasong on 2020/4/20.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "JSNetworkUtil.h"
#import "JSNetworkConfig.h"

@implementation JSNetworkUtil

@end

@implementation JSNetworkUtil (Data)

+ (NSData *)dataFromObject:(id)object {
    NSData *data = nil;
    if ([object isKindOfClass:NSString.class]) {
        data = [object dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([object isKindOfClass:NSDictionary.class] || [object isKindOfClass:NSArray.class]) {
        data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    } else if ([object isKindOfClass:NSData.class]) {
        data = object;
    }
    return data;
}

@end

@implementation JSNetworkUtil (Logger)

void JSNetworkLog(NSString *format, ...) {
#ifdef DEBUG
    if (!JSNetworkConfig.sharedConfig.debugLogEnabled) {
        return;
    }
    NSString *result = [NSString stringWithFormat:@"JSNetworLog: %@", format];
    va_list argptr;
    va_start(argptr, format);
    NSLogv(result, argptr);
    va_end(argptr);
#endif
}

@end
