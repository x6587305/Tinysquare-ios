//
//  TSBaseModel.m
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/6.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseModel.h"
@implementation TSBaseModel

+(instancetype)objectWithDic:(NSDictionary *)dic{
    return  [self objectWithKeyValues:dic error:nil];
}

@end
