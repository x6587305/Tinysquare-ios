//
//  TSBigImageCell.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/28.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBigImageCell.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Common.h"

@interface TSBigImageCell()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIImageView *imageView;

@end
@implementation TSBigImageCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, kDeiveHeight-64)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.8;
        [self.contentView addSubview:view];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, kDeiveHeight-64)];
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 2.0;
         self.scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, kDeiveHeight-64)];

        [_scrollView addSubview:_imageView];
//        UIViewContentModeScaleToFill,
//        UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
//        UIViewContentModeScaleAspectFill,
        _imageView.contentMode = UIViewContentModeScaleAspectFit;


    }
    return self;
}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    if (scrollView.zoomScale <= 1) {
//        self.imageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
//    }
//    self.topView.frame=CGRectMake(scrollView.contentOffset.x, self.topViewTop+scrollView.contentOffset.y, self.width, 44);
//    
//    self.bottomView.left = scrollView.contentOffset.x;
//    self.bottomView.top = scrollView.contentOffset.y +   self.bottomViewTop;
//}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

-(void) setImage:(NSString *)url atIndex:(int)index ofCount:(int) count{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

@end
