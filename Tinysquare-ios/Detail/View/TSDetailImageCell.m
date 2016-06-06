//
//  TSDetailImageCell.m
//  Tinysquare
//
//  Created by xiezhaojun on 16/6/5.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSDetailImageCell.h"
#import "Common.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TSShareView.h"
#import "TSImageCollectionCell.h"
#import "TSBigImageView.h"
#import "TSImage.h"
@interface TSDetailImageCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TSBigImageDelegate>
@property(nonatomic,strong) UIImageView *headerView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UILabel *dataLabel;
@property(nonatomic,strong) UIButton *shareBtn;
@property(nonatomic,strong) UICollectionView *imagesCollectionView;

@property(nonatomic,strong) UIView *lineView;
@end

@implementation TSDetailImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.headerView = [[UIImageView alloc]init];
        self.headerView.layer.cornerRadius = 5;
        self.headerView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.width.equalTo(@50);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.lessThanOrEqualTo (self.contentView.mas_bottom).offset(-5);
        }];
        self.headerView.layer.cornerRadius = 4;
        self.headerView.layer.masksToBounds = YES;
        
        self.nameLabel = [[UILabel alloc]init];
        [self.nameLabel setFont:[UIFont systemFontOfSize:16]];
        [self.nameLabel setTextColor:COLOR_SIGLE(26)];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_top).offset(6);
            make.left.equalTo(self.headerView.mas_right).offset(10);
            make.height.equalTo(@17);
        }];
        
        self.contentLabel = [[UILabel alloc]init];
        [self.contentLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentLabel setTextColor:COLOR_SIGLE(76)];
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(12);
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        self.contentLabel.numberOfLines = 0;
        
        
        self.dataLabel = [[UILabel alloc]init];
        [self.dataLabel setFont:[UIFont systemFontOfSize:11]];
        [self.dataLabel setTextColor:COLOR_SIGLE(51)];
        [self.contentView addSubview:self.dataLabel];
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(6);
            make.height.equalTo(@15);
            make.left.equalTo(self.nameLabel.mas_left);
            //            make.width.equalTo(@60);
//            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-8);
        }];
        self.dataLabel.layer.cornerRadius = 2;
        self.dataLabel.layer.masksToBounds = YES;
        self.dataLabel.backgroundColor = COLOR_RGB(254, 235, 235, 1);
        
        self.shareBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.shareBtn];
        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"share_selected"] forState:UIControlStateNormal];
        [self.shareBtn addTarget: self action:@selector(doshare) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@24);
            make.width.equalTo(@24);
            make.centerY.equalTo(self.dataLabel.mas_centerY);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        
        [self.contentView addSubview:self.imagesCollectionView];
        float width = (kDeiveWidth - 10 - 15 -10)/2;
        float height = 210.0/280 *width;
//        self.imagesRect = CGRectMake(10, self.hegith +10, kDeiveWidth - 10 - 15, height);
        [self.imagesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kDeiveWidth - 10 - 15));
            make.height.equalTo(@(height));
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.dataLabel.mas_bottom).offset(8);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        }];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = COLOR_SIGLE(221);
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@SINGLE_LINE_WIDTH);
        }];
        
    }
    return self;
}

-(UICollectionView *)imagesCollectionView{
    if(!_imagesCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        //
        _imagesCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, 235, 115) collectionViewLayout:layout ];
        _imagesCollectionView.backgroundColor = [UIColor whiteColor];
        _imagesCollectionView.delegate = self;
        _imagesCollectionView.dataSource = self;
        //        _imagesCollectionView.pagingEnabled = YES;
        _imagesCollectionView.showsHorizontalScrollIndicator = NO;
        _imagesCollectionView.bounces = NO;
        
        //        _imagesCollectionView.clipsToBounds = NO;
        //        UICollectionViewScrollDirectionVertical
        //        _imagesCollectionView.scrolld
        [_imagesCollectionView registerClass:[TSImageCollectionCell class] forCellWithReuseIdentifier:collectioncellId];
        
    }
    return  _imagesCollectionView;
}

-(void)doshare{
    [TSShareView show: self.news.share];
}
#pragma mark ----------------------------------------
#pragma mark  --  collectionview delegate datasource
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.imagesCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    [TSBigImageView showBigDelegate:self andFirstIndex:indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.news.imgs count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TSImage *image = [self.news.imgs objectAtIndex:indexPath.row];
    TSImageCollectionCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:collectioncellId forIndexPath:indexPath];
    NSURL *imageUrl = [NSURL URLWithString:image.url];
    [cell.imageView sd_setImageWithURL:imageUrl placeholderImage: [UIImage imageNamed:@"img_photo_default"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float width = (kDeiveWidth - 10 - 15 -10)/2;
    float height = 210.0/280 *width ;
    
    return  CGSizeMake(width , height);
}
#pragma mark --  TSBigImageDelegate
-(BOOL) hadDelete{
    return NO;
}

-(BOOL)canDelete:(int)index{
    return NO;
}

-(int) getImageCount{
    return (int)[self.news.imgs count];
    //    return (int)[self.imageUrls count];
}
-(NSString *) getImageUrlAtIndex:(int)index{
    if([self.news.imgs count] > index){
        TSImage *image = self.news.imgs[index];
        return image.url;
    }
    return @"";
}
-(UIImage *)getImageAtIndex:(int)index{
    return nil;
}



static NSString *TSDetailImageCellId = @"TSDetailImageCell";
static NSString *collectioncellId = @"collectioncellId";
+(void)registTableViewCell:(UITableView *)tableview{
    [tableview registerClass:self forCellReuseIdentifier:TSDetailImageCellId];
}

+(instancetype) getAdeCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withNews:(TSNews *)news andShop:(TSShop *) shop isLast:(BOOL) isLast;{
    TSDetailImageCell *cell =  [tableview dequeueReusableCellWithIdentifier:TSDetailImageCellId forIndexPath:indexPath];
    cell.news = news;
    cell.shop = shop;
    if(isLast){
        [cell.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.height.equalTo(@SINGLE_LINE_WIDTH);
        }];

    }else{
        [cell.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(10);
            make.right.equalTo(cell.contentView.mas_right);
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.height.equalTo(@SINGLE_LINE_WIDTH);
        }];
    }
    [cell resetSubFrameAndData];
    return cell;
}

-(void)resetSubFrameAndData{
    
    [self.headerView  sd_setImageWithURL:[NSURL URLWithString:self.news.avator] placeholderImage: [UIImage imageNamed:@"img_touxiang_default"]];
    [self.nameLabel setText:self.shop.name];
    [self.dataLabel setText:self.news.entrydate];
    [self.contentLabel setText:self.news.content];
    
    
}

@end
