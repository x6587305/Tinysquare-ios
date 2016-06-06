//
//  TSImageCell.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/28.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//
#import "UIView+Addition.h"
#import "TSImageCell.h"
#import "TSShop.h"
#import "MyImagePickerViewController.h"
#import "Common.h"
#import <Photos/Photos.h>
#import "TSUtilties.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyCenterTips.h"
#import "TSImage.h"
#import "TSBigImageView.h"
@interface TSImageCell()<TSBigImageDelegate>

@property(nonatomic,strong) NSMutableArray<UIImageView *> *imageViewArr;

@property(nonatomic,weak) TSShop *tsShop;
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong) NSIndexPath *indexPath;


@end
@implementation TSImageCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _imageViewArr = [NSMutableArray array];
//    _imageDeleteBtnArr = [NSMutableArray array];

    float top = 30.0;
    float left = 10.0;
    float width = (kDeiveWidth -20 -12 - 48) /3;
    for (int i = 0; i<5; i++) {
        float row = i/3;
        float coloum = i %3;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(left +(width +6)*coloum , top +(width +6)*row, width, width)];
        [self.contentView addSubview:imageView];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [_imageViewArr addObject:imageView];
        
        UIGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookBig:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:ges];
        imageView.tag = 1000 + i;

    }
    

    self.selectionStyle = UITableViewCellSelectionStyleNone;


}

-(void)lookBig:(UIGestureRecognizer *)ges{
    NSInteger index = ges.view.tag - 1000;
    [TSBigImageView showBigDelegate:self andFirstIndex:index];
}
-(void) refreshImageView{
    for(int i =0 ; i<5;i++){
        UIImageView *imageView =  self.imageViewArr[i];
//        UIButton *deleteBtn = self.imageDeleteBtnArr[i];
        if(([self.imageUrls count])>i){
            imageView.hidden = NO;
//            deleteBtn.hidden = NO;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[i]] placeholderImage: [UIImage imageNamed:@"img_photo_default"]];
           
            
           
        }else{
            imageView.hidden = YES;
//            deleteBtn.hidden = YES;
        }
    }

   
}



-(void)setTsShop:(TSShop *)tsShop{
    //补丁 -- 这个页面只有走一次这个逻辑
//    if(!_tsShop){
        _tsShop = tsShop;
        self.imageUrls = [NSMutableArray array];
        //WithArray:_tsShop.imgs
        for (TSImage *image in tsShop.imgs) {
            [self.imageUrls addObject:image.url];
        }
        [self refreshImageView];

//    }
}

static NSString *cellId = @"TSImageCell";

+(instancetype) getCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath andShop:(TSShop *)shop{
    TSImageCell *cell =  [tableview dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.leftTextLabel.text = @"Display Picture";
    cell.indexPath = indexPath;
    cell.tsShop = shop;
    cell.tableView = tableview;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}

#pragma mark --- tsbigimage delegate
-(BOOL) hadDelete{
    return NO;
}
-(int) getImageCount{
    return (int)[self.tsShop.imgs count];
}
-(NSString *) getImageUrlAtIndex:(int)index{
    TSImage *image = self.tsShop.imgs[index];
    return image.url;
}
-(UIImage *) getImageAtIndex:(int)index{
    return nil;
}
-(BOOL) canDelete:(int)index{
    return NO;
}


@end
