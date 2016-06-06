//
//  TSBaseVC.h
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/6.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSBaseVC : UIViewController

@property(nonatomic,assign) BOOL needKeyboardUp;

-(void) setNoLineWithAllColor:(UIColor *)color titleColor:(UIColor *)titleColor;

-(void) setAllColor:(UIColor *)color titleColor:(UIColor *)titleColor;
-(void) createRightBarTitle:(NSString *) btnTitle TitleColor:(UIColor *)color btnSize:(CGSize)btnSize
                     target:(UIViewController *) target select:(SEL)clichEvent;
-(void) createRightBarTitle:(NSString *) btnTitle btnSize:(CGSize)btnSize
                     target:(UIViewController *) target select:(SEL)clichEvent;
@end
