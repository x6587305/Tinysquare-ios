//
//  TSCard.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/22.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseModel.h"

@interface TSCard : TSBaseModel
@property(nonatomic,strong) NSNumber *objId;
@property(nonatomic,strong) NSNumber *shopId;
@property(nonatomic,copy) NSString *cardNum;
@property(nonatomic,copy) NSString *img;
@property(nonatomic,copy) NSString *brief;
@property(nonatomic,strong) NSNumber *points;
@property(nonatomic,strong) NSNumber *userTimes;
@property(nonatomic,strong) NSNumber *category;
@property(nonatomic,strong) NSNumber *isDefault;
@property(nonatomic,strong) NSNumber *status;
@property(nonatomic,copy) NSString *entrydate;
@property(nonatomic,copy) NSString *shopName;

//userId <null>

@property(nonatomic,assign)BOOL isOpen;
@end

