//
//  TSUtilties.m
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/6.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSUtilties.h"
#import <CommonCrypto/CommonDigest.h>

#import "HttpRequestHelper.h"
#import <QiniuSDK.h>
#import "Common.h"
@implementation TSUtilties

+ (NSString *)sha1:(NSString *)str {
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+ (NSString *)md5Hash:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}

//code=456456&platform=iOS&token=93d9f08fcc4a3270667cb594437c29b1&version=1.0.0&jy00735758
//code=456&platform=iOS&token=93d9f08fcc4a3270667cb594437c29b1&version=1.0.0&jy00735758
+(NSString *) sign:(NSDictionary<NSString *,NSString *> *)postData{
    static NSString * SIGN_SECRET = @"jy00735758";//jy00735758 jy00735858
    NSArray *keys =  [postData.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return  [obj1 compare:obj2];
        
    }];
    
    NSMutableString *string = [[NSMutableString alloc]init];
    for (NSString *key in keys) {
        NSString *value = [postData objectForKey:key];
        if(value && ![key isEqualToString:@"sign"]){
            [string appendFormat:@"%@=%@&",key,value];
        }
    }
    [string appendString:SIGN_SECRET];
    return [self md5Hash:[string copy]];
}

/**
 *  根据需要的类型获得动画效果(push)
 *
 *  @param subType kCATransitionFromRight   kCATransitionFromLeft  kCATransitionFromTop   kCATransitionFromBottom
 *
 *  @return
 */
+ (CATransition *)getPushAnimationBySubType:(NSString *)subType {
    CATransition *animation = [CATransition animation];
    //时间间隔
    [animation setDuration:0.3];
    //动画效果:1.kCATransitionFade 淡出  2.kCATransitionMoveIn 覆盖原图 3.kCATransitionPush 推出 4.kCATransitionReveal 底部显示出来
    [animation setType:kCATransitionMoveIn];
    //动画方向 kCATransitionFromRight   kCATransitionFromLeft  kCATransitionFromTop   kCATransitionFromBottom
    [animation setSubtype:subType];
    //动画的开始与结束时间的快慢
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}
/**
 *  根据需要的类型获得动画效果(pop)
 *
 *  @param subType kCATransitionFromRight   kCATransitionFromLeft  kCATransitionFromTop   kCATransitionFromBottom
 *
 *  @return
 */
+ (CATransition *)getPopAnimationBySubType:(NSString *)subType {
    CATransition *animation = [CATransition animation];
    //时间间隔
    [animation setDuration:0.3];
    //动画效果:1.kCATransitionFade 淡出  2.kCATransitionMoveIn 覆盖原图 3.kCATransitionPush 推出 4.kCATransitionReveal 底部显示出来
    [animation setType:kCATransitionPush];
    //动画方向 kCATransitionFromRight   kCATransitionFromLeft  kCATransitionFromTop   kCATransitionFromBottom
    [animation setSubtype:subType];
    //动画的开始与结束时间的快慢
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}

+ (UIImage *)scaleImageToMaxSize:(UIImage *)img maxSize:(int) maxSize{
    int newWidth =maxSize;
    int newHeight =maxSize;
    if (img.size.width>=img.size.height) {
        newHeight =img.size.height/img.size.width*maxSize;
    }else{
        newWidth =img.size.width/img.size.height*maxSize;
    }
    CGSize newSize =CGSizeMake(newWidth,  newHeight);
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newSize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newSize.width,  newSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


+(void)uploadImage:(UIImage *)image success:(void (^)( UIImage *viewImage, NSString *imageUrl)) success fail:(void (^)()) fail{
    
    
    UIImage *viewImage = [TSUtilties scaleImageToMaxSize:image maxSize:800];
    NSData *data =  UIImageJPEGRepresentation(viewImage, 0.8);
    UIGraphicsEndImageContext();
    
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_GetToken postData:@{} backSucess:^(NSDictionary *dic) {
        NSString *token = [dic objectForKey:@"token"];
        NSString *urlPre = [dic objectForKey:@"urlPrefix"];
        QNUploadManager *upManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        NSLog(@"pic count --%lu",(unsigned long)data.length);
        [upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",urlPre,[resp objectForKey:@"key"]];
            if(success){
                success(viewImage,imageUrl);
            }
            
            
        } option:nil];
        
    } backFalied:^(id backData) {
        if(fail){
            fail();
        }
        
        
    }];
    
}

+(UIImage *) getColorImage:(UIColor *)color rect:(CGRect) rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+(void) createLeftReturnButton:(UIViewController *)view
{
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    //nav_back 17 30
    [btn setFrame:CGRectMake(0, 0, 44 ,30)];
    [btn addTarget:view action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //小屏幕 局左边 16 *2 大屏幕 局左边 10 *3
    if ([UIScreen mainScreen].bounds.size.width > 375) {
        negativeSeperator.width = 1;
    }else{
        negativeSeperator.width = -5;
    }
    view.navigationItem.leftBarButtonItems = @[negativeSeperator,leftButtonItem];
}

+(void) createLeftReturnButtonBlack:(UIViewController *)view
{
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    //nav_back 17 30
    [btn setFrame:CGRectMake(0, 0, 44 ,30)];
    [btn addTarget:view action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //小屏幕 局左边 16 *2 大屏幕 局左边 10 *3
    if ([UIScreen mainScreen].bounds.size.width > 375) {
        negativeSeperator.width = 1;
    }else{
        negativeSeperator.width = -5;
    }
    view.navigationItem.leftBarButtonItems = @[negativeSeperator,leftButtonItem];
}
@end
