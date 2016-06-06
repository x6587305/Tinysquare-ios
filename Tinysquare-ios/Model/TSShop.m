//
//  TSShop.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/10.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSShop.h"
#import "TSImage.h"
@implementation TSShop
+(NSDictionary *)objectClassInArray{
    return @{@"imgs":[TSImage class]};
}
+(NSString *)replacedKeyFromPropertyName121:(NSString *)propertyName{
    if ([propertyName isEqualToString:(@"describe")]) {
        return @"description";
    }
    return  propertyName;
}
-(void)setImageUrls:(NSArray<NSString *> *)urls{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *url in urls) {
        TSImage * image = [[TSImage alloc]init];
        image.objId = nil;
        image.url = url;
        [arr addObject:image];
    }
    self.imgs = [arr copy];
}
@end
