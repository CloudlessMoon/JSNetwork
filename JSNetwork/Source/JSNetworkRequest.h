//
//  JSNetworkRequest.h
//  JSNetwork
//
//  Created by jiasong on 2020/4/17.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSNetworkRequest : NSObject

@property (nonatomic, strong, readonly) NSURLSessionTask *requestTask;

@end

NS_ASSUME_NONNULL_END
