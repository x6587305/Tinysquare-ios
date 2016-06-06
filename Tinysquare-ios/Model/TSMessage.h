//
//  TSMessage.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/22.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseModel.h"

@interface TSMessage : TSBaseModel
@property(nonatomic,strong) NSNumber *objId;
//@property(nonatomic,strong) NSNumber *userId;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subject;
@property(nonatomic,copy) NSString *from;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,strong) NSNumber *isRead;
@property(nonatomic,copy) NSString *entrydate;
@end

