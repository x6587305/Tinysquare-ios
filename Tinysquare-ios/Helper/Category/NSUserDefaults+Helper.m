//
//  NSUserDefaults+Helper.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/11.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "NSUserDefaults+Helper.h"
#import "TSAccount.h"
#import <MJExtension/MJExtension.h>
NSString *const ACCOUNT=@"account";
@implementation NSUserDefaults (Helper)


-(void)setAccount:(TSAccount *)account{

    [self setObject:[account JSONObject]  forKey:ACCOUNT];
}
-(TSAccount *)getAccount{
    NSDictionary *jsonString =  [self objectForKey:ACCOUNT];
    return [TSAccount objectWithDic:jsonString];
}
@end
