//
//  TSMessageDetailVC.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/5.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseVC.h"
typedef void (^XMLSuccess)(NSString *,NSString *);
typedef void (^XMLError)();

@class TSMessage;
@interface TSMessageDetailVC : TSBaseVC
+(TSMessageDetailVC *)getVC:(TSMessage *)message;
@end
