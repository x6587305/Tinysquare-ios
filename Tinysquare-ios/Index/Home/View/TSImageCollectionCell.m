//
//  TSImageCollectionCell.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/9.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSImageCollectionCell.h"
#import "Common.h"
@interface TSImageCollectionCell()

@end
@implementation TSImageCollectionCell

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        float width = (kDeiveWidth - 10 - 15 -10)/2;
        float height = 210.0/280 *width;
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 5;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
@end
