//
//  ImageCollectionData.h
//  ImagePickTest
//
//  Created by Aurora_sgbh on 14-10-29.
//  Copyright (c) 2014年 Aurora_sgbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
@class PHAsset;
@interface ImageCollectionData : NSObject
@property  (strong,nonatomic) ALAsset *asset;
@property  (strong,nonatomic) PHAsset *phAsset;
@property  (assign,nonatomic) int resourceType;
@property  (strong,nonatomic) NSString *timeShow;
-(BOOL) isImageSelected:(NSMutableArray *)selectedArray;
//这个是切换当前的选中记录
-(BOOL) toggleSelected:(NSMutableArray *)selectedArray;
//这个跟上面的区别在于 单选需要解除其他的选中。注意这里只是处理数据
-(BOOL) toggleSingelSelected:(NSMutableArray *)selectedArray;
-(BOOL) cannotSelected:(NSMutableArray *)cannotSelectArray;

-(UIImage *) getBigImage;
-(NSString *)getRealAssertUrl;
-(instancetype) initWithAsset:(ALAsset*) asset;
-(instancetype) initWithPhAsset:(PHAsset*) asset;
@end
