//
//  TSBigImageCell.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/28.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSBigImageView.h"
@interface TSBigImageCell : UICollectionViewCell
-(void) setImage:(NSString *)url atIndex:(int)index ofCount:(int) count;
@property(nonatomic,weak)TSBigImageView *bigView;
@property(nonatomic,strong) UIImageView *imageView;
@end
