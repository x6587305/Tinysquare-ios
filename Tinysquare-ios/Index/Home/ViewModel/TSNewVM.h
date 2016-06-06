//
//  TSNewVM.h
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/8.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TSNews.h"
@interface TSNewVM : NSObject
@property(nonatomic,strong) TSNews *news;

@property(nonatomic,assign) CGRect dataRect;
@property(nonatomic,assign) CGRect contentRect;
@property(nonatomic,assign) CGRect imagesRect;
@property(nonatomic,assign) float hegith;
@property(nonatomic,assign) CGRect bottomRect;

+(NSMutableArray *) arrayFromNewsArr:(NSArray<TSNews *> *) arr;
@end
