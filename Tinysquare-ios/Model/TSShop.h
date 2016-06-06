//
//  TSShop.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/10.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseModel.h"

@interface TSShop : TSBaseModel
@property(nonatomic,strong) NSNumber *objId;
@property(nonatomic,strong) NSNumber *userId;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *tel;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *brief;
@property(nonatomic,strong) NSString *describe;//description;
@property(nonatomic,strong) NSString *favoriteCount;
@property(nonatomic,strong) NSNumber *lng;
@property(nonatomic,strong) NSNumber *lat;
@property(nonatomic,strong) NSString *distance;
@property(nonatomic,strong) NSString *avator;
@property(nonatomic,strong) NSArray *imgs;
-(void)setImageUrls:(NSArray<NSString *> *)urls;
@end
