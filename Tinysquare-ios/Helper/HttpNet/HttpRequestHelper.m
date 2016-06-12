//
//  HttpRequestHelper.m
//  iGrow3
//
//  Created by Developer on 11/19/14.
//  Copyright (c) 2014 Aurora_sgbh. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "Common.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "TSUtilties.h"
#import "MyCenterTips.h"
#import "AppDelegate.h"
@implementation HttpRequestHelper

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
                   backSucess:(void (^)(id backData)) successBlock{
    [self sendHttpRequestBlock:interfaceName postData:data backSucess:successBlock backDelete:nil backFalied:nil];
}
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
                   backFalied:(void (^)(id backData)) faliedBlock{
    [self sendHttpRequestBlock:interfaceName postData:data backSucess:successBlock backDelete:nil backFalied:faliedBlock];
}
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
                   backFalied:(void (^)( id backData)) faliedBlock{
    [self sendHttpRequestBlock:interfaceName postData:data backSucess:successBlock backDelete:deleteBlock backFalied:faliedBlock andWithErrorTips:YES];
}




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
                   backFalied:(void (^)(id backData)) faliedBlock andWithErrorTips:(BOOL) hadTips{
    //接口访问地址
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@", hostURL, interfaceName];
    
    [self sendHttpRequestWithFullUrlBlock:str postData:data backSucess:successBlock backDelete:deleteBlock backFalied:faliedBlock andWithErrorTips:hadTips];
    
    
}

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
+ (void )sendHttpRequestWithFullUrlBlock:(NSString *)url
                     postData:(NSDictionary *)data
                      backSucess:(void (^)(id backData)) successBlock
                      backDelete:(void (^)()) deleteBlock
                      backFalied:(void (^)(id backData)) faliedBlock andWithErrorTips:(BOOL) hadTips{
    
    //accountId、OS、os_version、model、app_version、系统来源（IOS或安卓）
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
    [dic setObject:@"iOS" forKey:@"platform"];
    [dic setObject:@"1.0.0" forKey:@"version"];
    [dic setObject:  [TSUtilties sign:dic] forKey:@"sign"];

   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:nil URLString:[[NSURL URLWithString:@"xxx" relativeToURL:manager.baseURL] absoluteString] parameters:nil error:nil];

//    AFHTTPRequestOperation *op = [manager HTTPRequestOperationWithRequest:request
//                                                               success:nil
//                                                               failure:nil];
//    [op start];//NSOperation
//    [op waitUntilFinished];
    
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(operation.response.statusCode == 200){
            
            NSDictionary *dic = (NSDictionary *) responseObject;
           
            NSNumber *status = [dic objectForKey:@"status"];
            NSString *code = [dic objectForKey:@"code"];
//            NSString *msg = [dic objectForKey:@"msg"];
            
            NSDictionary *returnData = [dic objectForKey:@"result"];
            
            
            if (status.intValue == REQUEST_SUCCESS) {
                
                successBlock(returnData);
                
            }else {
                if([code isEqualToString:@"ERROR_TOKEN"]){
                    [AppDelegate logout];
                    
                }else{
                    NSString *message = NSLocalizedString(code, nil);
                    [MyCenterTips showNoImageTips:message];
                    
                    if (faliedBlock) {
                        faliedBlock(returnData);
                        
                    }

                }
            }
            
        }else{

           
        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络失败! %@",error.description);
        NSDictionary *dic = (NSDictionary *)  operation.responseObject;
        NSString *code = [dic objectForKey:@"code"];
        if([code isEqualToString:@"ERROR_TOKEN"]){
            [AppDelegate logout];
            
        }else{
            NSString *message = NSLocalizedString(code, nil);
            if(!([message length]>0)){
                
                message = error.localizedDescription;
            }

            [MyCenterTips showNoImageTips:message];
            
            if (faliedBlock) {
                faliedBlock(nil);
                
            }
            
        }
       
        //ERROR_TOKEN
        if (faliedBlock) {
            faliedBlock(nil);
            
        }
    }];
    

}

///**
// * 检查网络状态并返回
// */
//+ (NSString *)checkNetwork {
//    NSString *str = [NSString string];
//    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
//    switch (status) {
//        case NotReachable:
//            str = NONETWORK;
//            break;
//        case ReachableViaWWAN:
//            str = VIAWWAN;
//            break;
//        case ReachableViaWiFi:
//            str = VIAWIFI;
//            break;
//    }
//    return str;
//}
///**
// *  查看是否有网络
// */
//+ (BOOL) checkHadNetwork{
//    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
//    BOOL returnData = NO;
//    switch (status) {
//        case NotReachable:
//            returnData = NO;
//            break;
//        case ReachableViaWWAN:
//            returnData = YES;
//            break;
//        case ReachableViaWiFi:
//            returnData = YES;
//            break;
//    }
//    return returnData;
//}
//
//
///**
// * 检查网络状态显示提示信息，并返回
// */
//+ (BOOL)checkNetworkAndShowTips {
//    if ([[self checkNetwork] isEqualToString:NONETWORK]) {
//        [AlertViewHelper showblackTips:NSLocalizedString(@"msgConnServerFailed", nil)];
//        return NO;
//    }
//    return YES;
//}
//
///**
// *  微信分享log请求
// *
// */
//+ (void)sendWeiXinRequest:(NSString *)interfaceName postData:(NSDictionary *)data {
//   
//    if (![self checkNetworkAndShowTips]) {
//        return;
//    }
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:interfaceName parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if(operation.response.statusCode == 200){
//            NSLog(@"WXSuccess");
//        }else{
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//}

@end
