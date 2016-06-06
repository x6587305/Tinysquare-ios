
//
//  Common.h
//  iGrow
//
//  Created by aurora-IOS on 15/7/17.
//  Copyright (c) 2015年 aurora-IOS. All rights reserved.
//



#ifndef iGrow_Common_h
#define iGrow_Common_h
//一个像素的线
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)
//iOS宽高
#define kDeiveHeight [[UIScreen mainScreen] bounds].size.height
#define kDeiveWidth  [[UIScreen mainScreen] bounds].size.width
//操作系统版本信息
#define kiOSVersion  [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] systemVersion]]

#define hostURL  @"http://www.tinysquareapi.com/tinysquare-api/"
//#define hostURL  @"http://ec2-54-175-19-148.compute-1.amazonaws.com/tinysquare-api/"
//#define hostURL  @"http://192.168.81.65:8080/tinysquare-api"
//#define hostURL  @"http://192.168.1.106:8080/tinysquare-api"

//#define qiniuHostURL  @""
//@"http://7xtczz.com1.z0.glb.clouddn.com"

#define REQUEST_SUCCESS 200

#define COLOR_RGB(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define COLOR_SIGLE(C) COLOR_RGB(C, C, C, 1)
#define MAIN_RED COLOR_RGB(255,71,71,1)

#endif

#ifndef test
#define test(str) NSLog(@"%@",(str));
#endif




/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif
