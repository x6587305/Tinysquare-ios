//
//  NSUserDefaults+Helper.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/11.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TSAccount;
@interface NSUserDefaults (Helper)
-(void)setAccount:(TSAccount *)account;
-(TSAccount *)getAccount;
@end
