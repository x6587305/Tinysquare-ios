//
//  HttpRequestHelper.h
//  iGrow3
//
//  Created by Developer on 11/19/14.
//  Copyright (c) 2014 Aurora_sgbh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NetInterface.h"



@interface HttpRequestHelper : NSObject

//访问服务器接口数据（带返回Blocker事件方法）
/**
 *  只有成功回调
 *
 *  @param interfaceName <#interfaceName description#>
 *  @param data          <#data description#>
 *  @param successBlock  <#successBlock description#>
 */
+ (void )sendHttpRequestBlock:(NSString *)interfaceName
                     postData:(NSDictionary *)data
                   backSucess:(void (^)(id backData)) successBlock;
/**
 *  有成功 失败回调
 *
 *  @param interfaceName <#interfaceName description#>
 *  @param data          <#data description#>
 *  @param successBlock  <#successBlock description#>
 *  @param faliedBlock   <#faliedBlock description#>
 */
+ (void )sendHttpRequestBlock:(NSString *)interfaceName
                     postData:(NSDictionary *)data
                   backSucess:(void (^)(id backData)) successBlock
                   backFalied:(void (^)(id backData)) faliedBlock;
/**
 *  有成功 失败 和删除的回调
 *
 *  @param interfaceName <#interfaceName description#>
 *  @param data          <#data description#>
 *  @param successBlock  <#successBlock description#>
 *  @param deleteBlock   <#deleteBlock description#>
 *  @param faliedBlock   <#faliedBlock description#>
 */
+ (void )sendHttpRequestBlock:(NSString *)interfaceName
                     postData:(NSDictionary *)data
                   backSucess:(void (^)(id backData)) successBlock
                   backDelete:(void (^)()) deleteBlock
                   backFalied:(void (^)(id backData)) faliedBlock;

//访问服务器接口数据（带返回Blocker事件方法）
/**
 *  根方法 除 了成功 失败 删除回调 还有个参数 是 是否显示网络提示
 *
 *  @param interfaceName <#interfaceName description#>
 *  @param data          <#data description#>
 *  @param successBlock  <#successBlock description#>
 *  @param deleteBlock   <#deleteBlock description#>
 *  @param faliedBlock   <#faliedBlock description#>
 *  @param hadTips       <#hadTips description#>
 */
+ (void )sendHttpRequestBlock:(NSString *)interfaceName
                     postData:(NSDictionary *)data
                   backSucess:(void (^)(id backData)) successBlock
                   backDelete:(void (^)()) deleteBlock
                   backFalied:(void (^)(id backData)) faliedBlock andWithErrorTips:(BOOL) hadTips;

+ (void )sendHttpRequestWithFullUrlBlock:(NSString *)url
                                postData:(NSDictionary *)data
                              backSucess:(void (^)(id backData)) successBlock
                              backDelete:(void (^)()) deleteBlock
                              backFalied:(void (^)(id backData)) faliedBlock andWithErrorTips:(BOOL) hadTips;
    
//
//
///**
// *  微信分享log请求
// *
// */
//+ (void )sendWeiXinRequest:(NSString *)interfaceName postData:(NSDictionary *)data;

@end
