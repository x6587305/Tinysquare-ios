//
//  TSNewVM.m
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/8.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//
// | - 10 - xxx -5-|-10-|
#import "TSNewVM.h"
#import "Common.h"
@interface TSNewVM()

@end
@implementation TSNewVM
-(void)setNews:(TSNews *)news{
    _news = news;
    CGRect contentRect = [news.content boundingRectWithSize:CGSizeMake(kDeiveWidth - 80 -15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15] } context:nil];
    self.contentRect = (CGRect){ CGPointMake(80, 40),contentRect.size};
    
    //sss
    self.hegith =  MAX(70, CGRectGetMaxY(self.contentRect) + 20);
    
    if([news.imgs count]>0){
       //图片是 280  210
        float width = (kDeiveWidth - 10 - 15 -10)/2;
        float height = 210.0/280 *width;
        self.imagesRect = CGRectMake(10, self.hegith +10, kDeiveWidth - 10 - 15, height);
        self.hegith  = CGRectGetMaxY( self.imagesRect);
    }else{
        self.imagesRect = CGRectZero;
    }
    
    self.bottomRect = CGRectMake(10, self.hegith, kDeiveWidth - 10 -15, 33);
    self.hegith  = CGRectGetMaxY( self.bottomRect);
}

+(NSMutableArray *) arrayFromNewsArr:(NSArray<TSNews *> *) arr{
    NSMutableArray *vmArr = [NSMutableArray array];
    for (TSNews *news in arr) {
        TSNewVM *newVm = [[TSNewVM alloc]initWithNews:news];
        [vmArr addObject:newVm];
    }
    return vmArr;
}

-(instancetype)initWithNews:(TSNews *)news{
    self = [super init];
    if(self){
        self.news = news;
    }
    return  self;
}

@end
