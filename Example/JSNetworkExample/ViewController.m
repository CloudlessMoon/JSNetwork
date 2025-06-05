//
//  ViewController.m
//  JSNetworkExample
//
//  Created by jiasong on 2020/4/21.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import "ViewController.h"
#import <JSNetwork.h>
#import <AFNetworking.h>
#import "JSNetworkLoggerPlugin.h"
#import "NetworkResponse.h"
#import "JSNetworkAFRequest.h"
#import "CNodeAPI.h"
#import "DownloadAPI.h"
#import "UploadImageAPI.h"
#import "JSNetworkExample-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /// 全局配置
        JSNetworkConfig.sharedConfig.debugLogEnabled = NO;
        JSNetworkConfig.sharedConfig.timeoutInterval = 5;
        JSNetworkConfig.sharedConfig.buildNetworkRequest = ^__kindof NSOperation<JSNetworkRequestProtocol> *(id<JSNetworkInterfaceProtocol> interface) {
            //            return [[AlamofireRequest1 alloc] init];
            return [[JSNetworkAFRequest alloc] init];
        };
        JSNetworkConfig.sharedConfig.buildNetworkResponse = ^id<JSNetworkResponseProtocol>(id<JSNetworkInterfaceProtocol> interface) {
            return [[NetworkResponse alloc] init];
        };
        JSNetworkConfig.sharedConfig.buildNetworkDiskCache = ^id<JSNetworkDiskCacheProtocol>(id<JSNetworkInterfaceProtocol> interface) {
            return [[JSNetworkDiskCache alloc] init];
        };
        [JSNetworkConfig.sharedConfig addURLParameters:@{@"app": @"1.0.0", @"token": @"token"}];
        [JSNetworkConfig.sharedConfig addURLParameters:@{@"other": @"other"}];
        [JSNetworkConfig.sharedConfig addHTTPHeaderFields:@{@"userName": @"123"}];
        [JSNetworkConfig.sharedConfig addPlugin:JSNetworkLoggerPlugin.new];
    });
}

- (IBAction)onPressNext:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)onPressRequest:(id)sender {
    void (^test)(void) = ^(void) {
        CNodeAPI *api = [[CNodeAPI alloc] init];
        /// 生成接口
        [JSNetworkProvider requestWithConfig:api
                                    onTarget:self
                                   completed:^(ViewController *_Nullable target, id<JSNetworkInterfaceProtocol> aInterface) {
            /// 注意此Block会持有外部变量, 所以若内部引入了target, 必须使用weak, 否则自动释放机制会失效
            NSLog(@"%@", aInterface);
        }];
    };
    /// 测试
    for (int i = 0; i < 5; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            test();
        });
    }
}

- (IBAction)onPressBatch:(id)sender {
    /// 暂未封装
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < 10; i++) {
        CNodeAPI *api = [CNodeAPI new];
        dispatch_group_enter(group);
        [JSNetworkProvider requestWithConfig:api
                                   completed:^(id<JSNetworkInterfaceProtocol> aInterface) {
            NSLog(@"%@", aInterface);
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"全部请求完毕");
    });
}

- (IBAction)onPressChain:(id)sender {
    /// 暂未封装
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 10; i++) {
            CNodeAPI *api = [CNodeAPI new];
            [JSNetworkProvider requestWithConfig:api
                                       completed:^(id<JSNetworkInterfaceProtocol> aInterface) {
                NSLog(@"%@", aInterface);
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });
}

- (IBAction)onPressUpload:(id)sender {
    UploadImageAPI *api = [[UploadImageAPI alloc] init];
    [JSNetworkProvider requestWithConfig:api
                          uploadProgress:^(NSProgress *uploadProgress) {
        NSLog(@"uploadProgress - %@", uploadProgress);
    } completed:^(id<JSNetworkInterfaceProtocol> aInterface) {
        NSLog(@"%@", aInterface);
    }];
}

- (IBAction)onPressDownload:(id)sender {
    /// 生成接口
    DownloadAPI *api = [DownloadAPI apiWithDownloadURLType:DownloadURLTypeTypeCachefly];
    [JSNetworkProvider requestWithConfig:api
                                onTarget:self
                        downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress - %@", downloadProgress);
    } completed:^(__kindof NSObject * _Nullable target, id<JSNetworkInterfaceProtocol>  _Nonnull aInterface) {
        NSLog(@"%@", aInterface);
    }];
}

@end
