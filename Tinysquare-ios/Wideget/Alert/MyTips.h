//
//  MyTips.h
//  iGrow
// 上面黄色的提示框
//  Created by Aurora_sgbh on 14-9-18.
//  Copyright (c) 2014年 Aurora_sgbh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyTips : UIView
- (instancetype)initWithTitle:(NSString *)tip;
+ (void) showTips: (NSString *) tips;

//#mark pragma 这个是消失提示框的方法 不需要调用。3S后会自动调用
+ (void)removeTips:(UIView *)mytips;
@end
