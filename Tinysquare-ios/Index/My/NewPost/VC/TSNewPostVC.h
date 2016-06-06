//
//  TSNewPostVC.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/26.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseVC.h"
@class TSShop;
@class TSNews;
@interface TSNewPostVC : TSBaseVC
+(instancetype)getVC:(TSShop *)shop andNews:(TSNews *)news;
@end
