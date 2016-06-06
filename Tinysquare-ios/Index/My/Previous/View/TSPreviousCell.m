//
//  TSPreviousCell.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/3.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSPreviousCell.h"
#import "TSImageCollectionCell.h"
#import "TSImage.h"
#import  <SDWebImage/UIImageView+WebCache.h>
#import <Masonry.h>
#import "Common.h"
#import "UIView+Addition.h"
#import "TSNewPostVC.h"
#import "TSBigImageView.h"
@interface TSPreviousCell()<UICollectionViewDelegate,UICollectionViewDataSource,TSBigImageDelegate>
@property(nonatomic,strong) UILabel *dataLabel;
@property(nonatomic,strong) UIButton *editBtn;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UICollectionView *imagesCollectionView;

@end
@implementation TSPreviousCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        self.dataLabel = [[UILabel alloc]init];
        [self.dataLabel setFont:[UIFont systemFontOfSize:11]];
        [self.dataLabel setTextColor:COLOR_SIGLE(51)];
        [self.contentView addSubview:self.dataLabel];
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(10);
        }];
        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"edit_btn"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.height.equalTo(@30);
            make.width.equalTo(@30);
        }];
        [self.editBtn addTarget:self action:@selector(doEdit) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.numberOfLines = 0;
        [self.contentLabel setFont:[UIFont systemFontOfSize:12]];
        [self.dataLabel setTextColor:COLOR_SIGLE(76)];
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dataLabel.mas_bottom).offset(5);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        //
        _imagesCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, 235, 105) collectionViewLayout:layout ];
        _imagesCollectionView.backgroundColor = [UIColor whiteColor];
        _imagesCollectionView.delegate = self;
        _imagesCollectionView.dataSource = self;
        //        _imagesCollectionView.pagingEnabled = YES;
        _imagesCollectionView.showsHorizontalScrollIndicator = NO;
        _imagesCollectionView.bounces = NO;
        

        [_imagesCollectionView registerClass:[TSImageCollectionCell class] forCellWithReuseIdentifier:cellId];
        [self.contentView addSubview:self.imagesCollectionView];
        
         float width = (kDeiveWidth - 10 - 15 -10)/2;
         float height = 210.0/280 *width;
        [self.imagesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(15);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.height.equalTo(@(height));
        }];
    }
    return self;
}

-(void)doEdit{
    [[self findViewController].navigationController pushViewController: [TSNewPostVC getVC:self.shop andNews:self.news]
 animated:YES];
}




#pragma mark ----------------------------------------
#pragma mark  --  collectionview delegate datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.news.imgs count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TSImage *image = [self.news.imgs objectAtIndex:indexPath.row];
    TSImageCollectionCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSURL *imageUrl = [NSURL URLWithString:image.url];
    [cell.imageView sd_setImageWithURL:imageUrl placeholderImage: [UIImage imageNamed:@"img_photo_default"]];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.imagesCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    [TSBigImageView showBigDelegate:self andFirstIndex:indexPath.row];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float width = (kDeiveWidth - 10 - 15 -10)/2;
    float height = 210.0/280 *width ;
    return  CGSizeMake(width , height);
}
#pragma mark  --  ---------------------

static NSString *cellId = @"TSPreviousCell";
+(void)registTableViewCell:(UITableView *)tableview{
    [tableview registerClass:self forCellReuseIdentifier:cellId];
}

+(instancetype) getAdeCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withNews:(TSNews *)news andShop:(TSShop *)shop;{
    TSPreviousCell *cell =  [tableview dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.news = news;
    cell.shop = shop;
    [cell resetSubFrameAndData];
    return cell;
}

#pragma mark -- big image
-(BOOL) hadDelete{
    return  NO;
}
-(int) getImageCount{
    return (int)[self.news.imgs count];
}
-(NSString *) getImageUrlAtIndex:(int)index{
   TSImage *image =   self.news.imgs[index];
    return image.url;
}
-(UIImage *) getImageAtIndex:(int)index{
    return nil;
}
-(BOOL) canDelete:(int)index{
    return NO;
}



-(void)resetSubFrameAndData{
    [self.dataLabel setText:self.news.entrydate];
    [self.contentLabel setText:self.news.content];
    if([self.news.imgs count]>0){
        [self.imagesCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@105);
        }];
    }else{
        [self.imagesCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    [self.imagesCollectionView reloadData];
    
    
}

@end
