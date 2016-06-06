//
//  TSAccount.h
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/6.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseModel.h"
enum ACCOUNT_TYPE{
    ACCOUNT_TYPE_NORMAL = 1,
    ACCOUNT_TYPE_SHOPER =2
};
@interface TSAccount : TSBaseModel
@property(nonnull,copy) NSString *account;
@property(nonnull,copy) NSString *token;
@property(nonnull,copy) NSString *tel;
@property(nonnull,copy) NSString *mobile;
@property(nonnull,copy) NSString *email;
@property(nonnull,copy) NSNumber *category;
@end
