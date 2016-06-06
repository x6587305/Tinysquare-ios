//
//  TSTextEditVC.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/29.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseVC.h"
@class TSShop;
@interface TSTextEditVC : TSBaseVC
@property (weak, nonatomic) IBOutlet UITextView *textView;
+(instancetype)getVcShop:(TSShop *)shop;
@end
