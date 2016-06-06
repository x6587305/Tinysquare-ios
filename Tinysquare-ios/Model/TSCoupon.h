//
//  TSCoupon.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/24.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseModel.h"

@interface TSCoupon : TSBaseModel
@property(nonatomic,strong) NSNumber *objId;
@property(nonatomic,strong) NSNumber *userId;
@property(nonatomic,strong) NSNumber *couponId;
@property(nonatomic,strong) NSNumber *status;
@property(nonatomic,strong) NSNumber *shopId;
@property(nonatomic,strong) NSNumber *category;
@property(nonatomic,strong) NSNumber *amount;
@property(nonatomic,copy) NSString *entrydate;
@property(nonatomic,copy) NSString *shopName;
@property(nonatomic,copy) NSString *couponName;
@property(nonatomic,copy) NSString *couponImg;
@property(nonatomic,copy) NSString *startTime;
@property(nonatomic,copy) NSString *endTime;


@end
