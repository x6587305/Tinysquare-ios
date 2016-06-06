//
//  MyCenterTips.h
//  iGrow2
//
//  Created by Aurora_sgbh on 14-11-14.
//  Copyright (c) 2014年 wangt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCenterTips : UIView
- (instancetype)initWithTitle:(NSString *)tip hadImage:(BOOL) hadImage;
+ (void) showTips: (NSString *) tips;
+(void) showCode:(NSString *)code;
//#mark pragma 这个是消失提示框的方法 不需要调用。3S后会自动调用
+ (void) showNoImageTips: (NSString *) tips ;
+ (void)removeTips:(UIView *)mytips;
@end
