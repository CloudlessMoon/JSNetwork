//
//  JSNetworkUtil.h
//  JSNetwork
//
//  Created by jiasong on 2020/4/20.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSNetworkUtil : NSObject

@end

@interface JSNetworkUtil (Data)

+ (nullable NSData *)dataFromObject:(id)object;

@end

@interface JSNetworkUtil (Logger)

FOUNDATION_EXPORT void JSNetworkLog(NSString *format, ...);

@end

NS_ASSUME_NONNULL_END
