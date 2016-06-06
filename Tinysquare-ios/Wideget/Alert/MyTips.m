//
//  MyTips.m
//  iGrow
//
//  Created by Aurora_sgbh on 14-9-18.
//  Copyright (c) 2014年 Aurora_sgbh. All rights reserved.
//

#import "MyTips.h"
#import "Common.h"
#import "MJExtension.h"
#import "Masonry.h"
//#import <Masonry.h>
@implementation MyTips

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)tip{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *vc =(UINavigationController *) window.rootViewController;
    float top = 64;
    
    if([vc isKindOfClass:[UINavigationController class]]){
        if(vc.navigationBar.hidden){
            top = 0;
//            self = [super initWithFrame:CGRectMake(0, top-35, kDeiveWidth, 35)];
        }
    }
//    if(vc.navigationBar.hidden){
//        top = 0;
//    }
    
    self = [super initWithFrame:CGRectMake(0, top-35, kDeiveWidth, 35)];
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIView *_bgView =[[UIView alloc] init];//背景黄色的最大的view
        _bgView.backgroundColor = [UIColor colorWithRed:1 green:244/255.0 blue:64/255.0 alpha:1];
        _bgView.alpha=0.9f;
        [self addSubview:_bgView];
        
        _bgView.translatesAutoresizingMaskIntoConstraints = NO;
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.height.greaterThanOrEqualTo(@44);
        }];
        
        UIView *_centerView = [[UIView alloc]init];//中间的view 包含一个图片跟后面的文本
        [_bgView addSubview:_centerView];
//        _centerView.backgroundColor = [UIColor orangeColor];
        _centerView.translatesAutoresizingMaskIntoConstraints = NO;
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bgView.mas_top);
            make.bottom.equalTo(_bgView.mas_bottom);
            make.left.equalTo(_bgView.mas_left).offset(14);
//            make.left.greaterThanOrEqualTo(_bgView.mas_left);
            make.right.lessThanOrEqualTo(_bgView.mas_right);
//            make.centerX.equalTo(_bgView.mas_centerX);
            
        }];
        
        

        UILabel *label = [[UILabel alloc]init];
        [label setBackgroundColor:[UIColor clearColor]];
        label.text =tip;
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:12.0]];
//        label.layer.borderWidth =0;
        label.textColor = [UIColor redColor];
        //[UIColor colorWithRed:224/255 green:48/255 blue:60/255 alpha:1];
        [_centerView addSubview:label];
        
        UIImageView *tipImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        tipImage.image = [UIImage imageNamed:@"icon_tip"];
        tipImage.translatesAutoresizingMaskIntoConstraints = NO;
        [_centerView addSubview:tipImage];
        
        
        label.translatesAutoresizingMaskIntoConstraints = NO;
//        [_centerView addSubview:label];
         label.textAlignment = NSTextAlignmentCenter;
        [tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_centerView.mas_left);
//            make.right.equalTo(label.mas_left).offset(-9.0);
            make.width.equalTo(@18);
            make.height.equalTo(@18);
            make.centerY.equalTo(_centerView.mas_centerY);
            
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipImage.mas_right).offset(10.0);
            make.right.equalTo(_centerView.mas_right);

            make.top.equalTo(_centerView.mas_top);
            make.bottom.equalTo(_centerView.mas_bottom);
        }];
        
//        CGSize size = CGSizeMake(261,2000);
//        CGSize labelsize = [tip sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
//        
//        CGFloat left = (kDeiveWidth -25 -labelsize.width)/2;
//        self.frame = CGRectMake(0, 64, kDeiveWidth,  labelsize.height+20);
        
//        _bgView.frame = CGRectMake(0, 0, kDeiveWidth,  labelsize.height+20);
        
        
//        [label setFrame:CGRectMake(left+25,10 , labelsize.width, labelsize.height)];
 
    }
    return self;
}
+ (void) showTips: (NSString *) tips {
    
    //判断是否已经弹出提示
    UIView  *_lastTips= [[UIApplication sharedApplication].keyWindow viewWithTag:990];
    if (_lastTips!=nil) {
        [_lastTips removeFromSuperview];
    }
    MyTips *mytips =[[MyTips alloc]initWithTitle:tips];
    mytips.tag=990;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIViewController *vc = window.rootViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        [nav.topViewController.view addSubview:mytips];
    } else {
        UITabBarController *controller = (UITabBarController *)window.rootViewController;
        UINavigationController *nav = controller.selectedViewController;
        CGRect rect = mytips.frame;
        rect.origin.y = -nav.topViewController.view.frame.origin.y - 35;
        //nav.topViewController.view.frame.origin.y - 64 -35;
        mytips.frame = rect;
        [nav.topViewController.view addSubview:mytips];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        CGRect rect = mytips.frame;
        mytips.frame = CGRectMake(0, rect.origin.y+rect.size.height, kDeiveWidth, 35);
    }];
    
    
    [self performSelector:@selector(removeTips:) withObject:mytips afterDelay:3];
}

//#mark pragma 这个是消失提示框的方法 不需要调用。3S后会自动调用
+ (void)removeTips:(UIView *)mytips{
    [UIView animateWithDuration:1.0f animations:^{
        CGRect rect = mytips.frame;
        mytips.frame = CGRectMake(0, rect.origin.y-rect.size.width, kDeiveWidth, 35);
    } completion:^(BOOL finished) {
        [mytips removeFromSuperview];
    }];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
