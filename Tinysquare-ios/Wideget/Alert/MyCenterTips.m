//
//  MyCenterTips.m
//  iGrow2
//
//  Created by Aurora_sgbh on 14-11-14.
//  Copyright (c) 2014年 wangt. All rights reserved.
//

#import "MyCenterTips.h"
#import "Masonry.h"
@implementation MyCenterTips

- (instancetype)initWithTitle:(NSString *)tip hadImage:(BOOL) hadImage{
    self = [super initWithFrame:CGRectMake(0, 64, 320, 35)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;

        
        UIView *blackView =[[UIView alloc] init];
        [blackView setBackgroundColor:[UIColor blackColor]];
        [blackView setAlpha:0.5];
        blackView.layer.cornerRadius = 8;
        blackView.layer.masksToBounds = YES;
        [self addSubview:blackView];
        
        blackView.translatesAutoresizingMaskIntoConstraints= NO;
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);

        }];

        
        
        
       
        UILabel *label = [[UILabel alloc]init];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        label.text =tip;
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:18.0]];
        label.layer.borderWidth =0;
        [self addSubview:label];
         label.translatesAutoresizingMaskIntoConstraints= NO;
        
        UIImageView *tipImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        tipImage.image = [UIImage imageNamed:@"blue_tip"];
        [self addSubview:tipImage];
         tipImage.translatesAutoresizingMaskIntoConstraints= NO;
        
        [tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16) ;
            make.right.equalTo(label.mas_left).offset(-18) ;
            if(hadImage){
                make.width.equalTo(@25) ;
                make.height.equalTo(@19) ;

            }else{
                make.width.equalTo(@0) ;
                make.height.equalTo(@0) ;
            }
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipImage.mas_right).offset(18) ;
            make.right.equalTo(self.mas_right).offset(-22) ;
            make.top.equalTo(self.mas_top).offset(22) ;
            make.bottom.equalTo(self.mas_bottom).offset(-22);
            
        }];
        
        
    }
    return self;
}

+ (void) showNoImageTips: (NSString *) tips {
    //判断是否已经弹出提示
    UIView  *_lastTips= [[UIApplication sharedApplication].keyWindow viewWithTag:990];
    if (_lastTips!=nil) {
        [_lastTips removeFromSuperview];
    }
    MyCenterTips *mytips =[[MyCenterTips alloc]initWithTitle:tips hadImage:NO];
    mytips.tag=990;
    //[rootView addSubview:mytips];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:mytips];
    
    mytips.translatesAutoresizingMaskIntoConstraints = NO;
    
    [mytips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(window.rootViewController.view.mas_centerX);
        make.centerY.equalTo(window.rootViewController.view.mas_centerY);
        make.width.lessThanOrEqualTo(window.rootViewController.view.mas_width);
    }];
    
    [self performSelector:@selector(removeTips:) withObject:mytips afterDelay:3];
}
+(void) showCode:(NSString *)code{
    NSString *message = NSLocalizedString(code, nil);
    [self showNoImageTips:message];
}

+ (void) showTips: (NSString *) tips {
    [self showNoImageTips:tips];
    //判断是否已经弹出提示
//    UIView  *_lastTips= [[UIApplication sharedApplication].keyWindow viewWithTag:990];
//    if (_lastTips!=nil) {
//        [_lastTips removeFromSuperview];
//    }
//    MyCenterTips *mytips =[[MyCenterTips alloc]initWithTitle:tips hadImage:YES];
//    mytips.tag=990;
//    //[rootView addSubview:mytips];
//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    [window addSubview:mytips];
//    
//    mytips.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [mytips mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(window.rootViewController.view.mas_centerX);
//        make.centerY.equalTo(window.rootViewController.view.mas_centerY);
//        make.width.lessThanOrEqualTo(window.rootViewController.view.mas_width);
//    }];
//    
//    [self performSelector:@selector(removeTips:) withObject:mytips afterDelay:3];
}

+ (void)removeTips:(UIView *)mytips{
    [mytips removeFromSuperview];
}

@end
