//
//  TSSigleEditVC.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/29.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseVC.h"
@class TSShop;
@interface TSSigleEditVC : TSBaseVC
@property (weak, nonatomic) IBOutlet UITextField *sigleText;
+(instancetype)getVcShop:(TSShop *)shop atType:(int)type;
@end
