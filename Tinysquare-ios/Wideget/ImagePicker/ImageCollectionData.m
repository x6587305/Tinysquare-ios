//
//  ImageCollectionData.m
//  ImagePickTest
//
//  Created by Aurora_sgbh on 14-10-29.
//  Copyright (c) 2014年 Aurora_sgbh. All rights reserved.
//

#import "ImageCollectionData.h"
#import <Photos/Photos.h>

@implementation ImageCollectionData


-(instancetype) initWithAsset:(ALAsset*) asset{
    self = [super init];
    if(self){
        _asset = asset;
    }
    return self;
}
-(instancetype) initWithPhAsset:(PHAsset*) asset{
    self = [super init];
    if(self){
        _phAsset = asset;
    }
    return self;
}



-(BOOL) toggleSelected:(NSMutableArray *)selectedArray{
    NSString *url = [self getRealAssertUrl];
    if([self isImageSelected:selectedArray]){
        [selectedArray removeObject:url];
        return NO;
    }else{
        [selectedArray addObject:url];
        return YES;
    }
}
-(BOOL) toggleSingelSelected:(NSMutableArray *)selectedArray{
//    BOOL isSelected = [self isImageSelected:selectedArray];
    [selectedArray removeAllObjects];
//    if(!isSelected){
        NSString *url =[self getRealAssertUrl];
        [selectedArray addObject:url];
        return YES;
//    }
//    return NO;
}
-(BOOL) isImageSelected:(NSMutableArray *)selectedArray{
    NSString *url = [self getRealAssertUrl];
    return [selectedArray containsObject:url];
}
-(BOOL) cannotSelected:(NSMutableArray *)cannotSelectArray{
    NSString *url = [self getRealAssertUrl];
    return [cannotSelectArray containsObject:url];
}


-(NSString *)getRealAssertUrl{
    NSString *url;
    if(self.asset){
         url = [[self.asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
    }else{
        url = self.phAsset.localIdentifier;
    }
   
    return url;
}
-(UIImage *) getBigImage{
    ALAssetRepresentation *assetRep = [self.asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullScreenImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       ];
    return img;
}
@end
