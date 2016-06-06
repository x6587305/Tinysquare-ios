//
//  TSCardVC.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/22.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseVC.h"
@class TSCard;
@interface TSCardVC : TSBaseVC
+(instancetype)getVC;
-(void)setTableDefaultCard:(TSCard *)card;
@end
