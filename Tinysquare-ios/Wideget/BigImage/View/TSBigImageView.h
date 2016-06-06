//
//  TSBigImageView.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/27.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TSBigImageDelegate<NSObject>
-(BOOL) hadDelete;
-(int) getImageCount;
-(NSString *) getImageUrlAtIndex:(int)index;
-(UIImage *) getImageAtIndex:(int)index;
-(BOOL) canDelete:(int)index;
@optional
-(void)deleteIndexAt:(int)index;


@end
@interface TSBigImageView : UIView

-(void) doShow;

-(void)doSave:(UIGestureRecognizer *)ges;
+(void) showBigDelegate:(id<TSBigImageDelegate>) delegate andFirstIndex:(NSInteger) index;
@end
