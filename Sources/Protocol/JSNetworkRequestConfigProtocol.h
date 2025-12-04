//
//  JSNetworkRequestConfigProtocol.h
//  JSNetwork
//
//  Created by jiasong on 2020/4/17.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSNetworkPluginProtocol;
@protocol JSNetworkRequestProtocol;
@protocol JSNetworkResponseProtocol;

typedef NS_ENUM(NSInteger, JSRequestMethod) {
    JSRequestMethodGET     NS_SWIFT_NAME(get),
    JSRequestMethodPOST    NS_SWIFT_NAME(post),
    JSRequestMethodHEAD    NS_SWIFT_NAME(head),
    JSRequestMethodPUT     NS_SWIFT_NAME(put),
    JSRequestMethodDELETE  NS_SWIFT_NAME(delete),
    JSRequestMethodPATCH   NS_SWIFT_NAME(patch),
};

typedef NS_ENUM(NSInteger, JSRequestSerializerType) {
    JSRequestSerializerTypeJSON        NS_SWIFT_NAME(json),         /// POST时Body转换为JSON字符串传输
    JSRequestSerializerTypeHTTP        NS_SWIFT_NAME(http),         /// POST时Body转换为自定义的字符串传输
    JSRequestSerializerTypeFormData    NS_SWIFT_NAME(formData),     /// POST时Body转换为FormData传输
    JSRequestSerializerTypeBinaryData  NS_SWIFT_NAME(binaryData),   /// POST时Body转换为二进制数据传输
};

typedef NS_ENUM(NSInteger, JSResponseSerializerType) {
    JSResponseSerializerTypeJSON       NS_SWIFT_NAME(json),
    JSResponseSerializerTypeHTTP       NS_SWIFT_NAME(http),
    JSResponseSerializerTypeXMLParser  NS_SWIFT_NAME(xmlParser),
};

NS_ASSUME_NONNULL_BEGIN

@protocol JSNetworkRequestConfigProtocol <NSObject>

@required

/**
 *  @brief URLString
 */
- (NSString *)requestURLString NS_SWIFT_NAME(requestUrlString());

@optional

/**
 *  @brief BaseURLString
 */
- (NSString *)baseURLString NS_SWIFT_NAME(baseUrlString());

/**
 *  @brief URL中需要拼接的路径
 */
- (nullable NSArray<NSString *> *)requestPaths;

/**
 *  @brief URL中需要拼接的参数, 注意：会拼接上全局的设置
 */
- (nullable NSDictionary<NSString *, id> *)requestParameters;

/**
 *  @brief 需要忽略的全局设置的参数
 */
- (nullable NSArray<NSString *> *)ignoreGlobalParameterForKeys;

/**
 *  @brief request中的HTTPBody
 */
- (nullable id)requestBody;

/**
 *  @brief 请求方式GET/POST, 默认为GET
 */
- (JSRequestMethod)requestMethod;

/**
 *  @brief POST时Body的转换方式，默认JSRequestSerializerTypeJSON
 */
- (JSRequestSerializerType)requestSerializerType;

/**
 *  @brief 请求超时时间, 默认是全局设置的超时时间
 */
- (NSTimeInterval)requestTimeoutInterval;

/**
 *  @brief 缓存策略
 */
- (NSURLRequestCachePolicy)requestCachePolicy;

/**
 *  @brief 请求头, 默认是全局设置的请求头, 注意：会拼接上全局的设置
 */
- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary;

/**
 *  @brief 筛选URL
 *
 *  @param URLString 需要筛选的URL
 *
 *  @return 返回新的URL
 */
- (NSString *)requestURLStringFilterWithURLString:(NSString *)URLString NS_SWIFT_NAME(requestUrlFilter(_:));

/**
 *  @brief 拼接FormData
 *
 *  @param multipartFormData 可拼接的FormData, 如果外部使用AFN, 则是AFMultipartFormData
 */
- (void)constructingMultipartFormData:(id)multipartFormData NS_SWIFT_NAME(constructingMultipart(formData:));

/**
 *  @brief 拼接URLRequest
 *
 *  @param urlRequest 可拼接的URLRequest
 */
- (void)constructingMultipartURLRequest:(NSMutableURLRequest *)urlRequest NS_SWIFT_NAME(constructingMultipart(urlRequest:));

/**
 *  @brief 响应的数据解析方式，默认为JSResponseSerializerTypeJSON
 */
- (JSResponseSerializerType)responseSerializerType;

/**
 *  @brief 响应的内容类型
 */
- (nullable NSSet<NSString *> *)responseAcceptableContentTypes;

/**
 *  @brief 响应的状态码，默认是100 - 500
 */
- (NSIndexSet *)responseAcceptableStatusCodes;

/**
 *  @brief 请求类，继承于NSOperation, 默认全局设置的request
 */
- (__kindof NSOperation<JSNetworkRequestProtocol> *)request;

/**
 *  @brief 响应类, 默认全局设置的response
 */
- (id<JSNetworkResponseProtocol>)response;

/**
 *  @brief 插件, 默认全局设置的Plugins, 注意：会拼接上全局的设置
 */
- (NSArray<id<JSNetworkPluginProtocol>> *)requestPlugins;

@end

NS_ASSUME_NONNULL_END
