//
//  TSHUDView.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/22.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSHUDView.h"
#import "Common.h"
@interface TSHUDView()
@property(nonatomic,strong)  UIActivityIndicatorView *activeView;
@end
@implementation TSHUDView

+(instancetype) shareInstance{
    static dispatch_once_t onceToken;
     static id one ;
    dispatch_once(&onceToken, ^{
         one = [[self alloc]init];
    });
    return one;
}

+(void) show{
    TSHUDView *view = [self  shareInstance];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:view];
    [view.activeView startAnimating];
}

+(void) hide{
    TSHUDView *view = [self  shareInstance];
    [view.activeView stopAnimating];
    [view removeFromSuperview];
}

-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, kDeiveWidth, kDeiveHeight)];
    if(self){
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, kDeiveHeight)];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        
        self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self.activeView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activeView.center = self.center;
        [self addSubview:self.activeView];
        
    }
    return self;
}

@end
