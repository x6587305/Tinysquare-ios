//
//  TSNews.h
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/8.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseModel.h"
#import "TSShare.h"
@interface TSNews : TSBaseModel
@property(nonatomic,copy) NSString *avator;
@property(nonatomic,strong) NSNumber *canFavorite;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *distance;
@property(nonatomic,copy) NSString *entrydate;

@property(nonatomic,strong) NSNumber *favoriteCount;
@property(nonatomic,strong) NSNumber *objId;
@property(nonatomic,strong) NSNumber *shopId;
@property(nonatomic,copy) NSString *shopName;
@property(nonatomic,strong) TSShare *share;
@property(nonatomic,strong)NSArray *imgs;
//@property(nonatomic,strong)NSArray *status;
@end
