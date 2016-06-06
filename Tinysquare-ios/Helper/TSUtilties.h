//
//  TSUtilties.h
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/6.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@class UIImage;
@interface TSUtilties : NSObject
+ (NSString *)sha1:(NSString *)str;
+ (NSString *)md5Hash:(NSString *)str ;
+(NSString *) sign:(NSDictionary<NSString *,NSString *> *)postData;
+ (CATransition *)getPushAnimationBySubType:(NSString *)subType ;
+ (CATransition *)getPopAnimationBySubType:(NSString *)subType ;
+ (UIImage *)scaleImageToMaxSize:(UIImage *)img maxSize:(int) maxSize;
+(void)uploadImage:(UIImage *)image success:(void (^)( UIImage *viewImage, NSString *url)) success fail:(void (^)()) fail;
+(UIImage *) getColorImage:(UIColor *)color rect:(CGRect) rect;

+(void) createLeftReturnButton:(UIViewController *)view;
+(void) createLeftReturnButtonBlack:(UIViewController *)view;
@end
