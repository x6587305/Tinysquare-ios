//
//  TSShareView.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/26.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSShareView.h"
#import "Common.h"
#import <WXApi.h>
#import "MyCenterTips.h"
#import "TSShare.h"
@interface TSShareView()
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) TSShare *share;
@property(nonatomic,strong) UIButton *leftButton;
@end
@implementation TSShareView

+(instancetype) shareInstance{
    static dispatch_once_t onceToken;
    static id one ;
    dispatch_once(&onceToken, ^{
        one = [[self alloc]init];
    });
    return one;
}

+(void) show:(TSShare *)share{
    TSShareView *view = [self  shareInstance];
    view.share = share;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:view];
//    [view.activeView startAnimating];
}

+(void) hide{
    TSShareView *view = [self  shareInstance];
    [view removeFromSuperview];
}

-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, kDeiveWidth, kDeiveHeight)];
    if(self){
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, kDeiveHeight)];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeiveHeight-60, kDeiveWidth, 60)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bottomView];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(25, 7.5, 45, 45);
        [leftButton setImage:[UIImage imageNamed:@"ico_weixin"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(doShareWeixin:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:leftButton];
        self.leftButton = leftButton;
        //
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(90, 7.5, 45, 45);
        [rightButton setImage:[UIImage imageNamed:@"ico_pengyouquan"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(doSharePenyou:) forControlEvents:UIControlEventTouchUpInside];
          [self.bottomView addSubview:rightButton];
        //
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(kDeiveWidth - 60, 22, SINGLE_LINE_WIDTH, 16)];
        lineView.backgroundColor = COLOR_SIGLE(128);
         [self.bottomView addSubview:lineView];
        
        UIButton *closeButton =[UIButton buttonWithType:UIButtonTypeCustom];
         closeButton.frame = CGRectMake(kDeiveWidth-55, 7.5, 45, 45);
        [closeButton setImage:[UIImage imageNamed:@"ico_close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(doClose:) forControlEvents:UIControlEventTouchUpInside];
         [self.bottomView addSubview:closeButton];

    }
    return self;
}

-(void)doShareWeixin:(id)sender{
      [self share:self.share andType:WXSceneSession];
}

-(void)doSharePenyou:(id)sender{
    [self share:self.share andType:WXSceneTimeline];
}
//UIImage *image;
////    if(self.resourceType == RESOURCE_TYPE_AUDIO || self.resourceType == RESOURCE_TYPE_VIDEO){
//
//UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), YES, [UIScreen mainScreen].scale);
//CGContextRef context =  UIGraphicsGetCurrentContext();
//[_showImgView.layer renderInContext:context];
//image = UIGraphicsGetImageFromCurrentImageContext();
//UIGraphicsEndImageContext();
-(void)share:(TSShare *)share andType:(enum WXScene) type{
    
    if(![WXApi isWXAppInstalled]){
        [MyCenterTips showTips:@"share success!"];
        return;
    }
        
        //  [MyCenterTips showTips:@"share success!"];

    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:share.icon]];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.image = image;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), YES, [UIScreen mainScreen].scale);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    [imageview.layer renderInContext:context];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = share.url;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = share.title;
    message.description = share.brief;
    message.mediaObject = webObj;  //跳转页面
    NSData *data = UIImageJPEGRepresentation(image , 0.9); //缩略图
    message.thumbData = data;
    
    //    message.thumbData = data;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = type;
    req.bText = NO;
    req.message = message;
    //    BOOL re = [WXApi openWXApp];
    //     NSLog(@"%d",re);
    BOOL re = [WXApi sendReq:req];
    NSLog(@"%d",re);

    
    [self removeFromSuperview];
    
}

-(void)doClose:(id)sender{
    [self removeFromSuperview];
}

@end
