//
//  TSNewsCell.m
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/8.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSNewsCell.h"
#import "Common.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TSNewVM.h"
#import "TSImageCollectionCell.h"
#import "TSImage.h"
#import "HttpRequestHelper.h"
#import "AppDelegate.h"
#import <WXApi.h>
#import "UIView+Addition.h"
#import "TSBigImageVC.h"
#import "TSShareView.h"
#import "TSBigImageView.h"
static NSString *cellId = @"collectionCell";

@interface TSNewsCell ()
@property(nonatomic,weak) UITableView *tableView;
@end

@interface TSNewsCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TSBigImageDelegate>
@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *distanceLabel;
@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,strong) UILabel *contentLabel;

@property(nonatomic,strong) UIView *imagesView;
@property(nonatomic,strong) UICollectionView *imagesCollectionView;

@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIButton *storeBtn;
@property(nonatomic,strong) UIButton *shareBtn;
@end


@implementation TSNewsCell

#pragma mark  -- lazy property
-(UIImageView *)headImageView{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc]init];
        _headImageView.frame = CGRectMake(10, 15, 60, 60);
        _headImageView.layer.cornerRadius = 5;
        _headImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImageView];
    }
    return _headImageView;
}

-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [_nameLabel setTextColor:COLOR_SIGLE(26)];
//        _nameLabel.frame = CGRectMake( 80, 20, kDeiveWidth - 80 -115, 12);
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@80);
            make.top.equalTo(@20);
            make.height.equalTo(@17);
            make.right.lessThanOrEqualTo(self.distanceLabel.mas_left);
        }];
    }
    return  _nameLabel;
}

-(UILabel *)distanceLabel{
    if(!_distanceLabel){
        _distanceLabel = [[UILabel alloc]init];
        [_distanceLabel setFont:[UIFont systemFontOfSize:11]];
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
        [_distanceLabel setBackgroundColor:COLOR_RGB(239, 249, 252, 1)];
        [_distanceLabel setTextColor:COLOR_SIGLE(102)];
        _distanceLabel.layer.cornerRadius = 3;
        _distanceLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_distanceLabel];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.equalTo(self.nameLabel.mas_centerY);
        }];
    }
    return  _distanceLabel;
}

-(UILabel *)dateLabel{
    if(!_dateLabel){
        
        _dateLabel = [[UILabel alloc]init];
        [_dateLabel setFont:[UIFont systemFontOfSize:11]];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        [_dateLabel setBackgroundColor:COLOR_RGB(239, 249, 252, 1)];
        [_dateLabel setTextColor:COLOR_SIGLE(102)];
        _dateLabel.layer.cornerRadius = 3;
        _dateLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
//            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.left.equalTo(self.contentLabel.mas_left);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        }];
    }
    return  _dateLabel;
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
         _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:COLOR_SIGLE(76)];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UIView *)imagesView{
    if(!_imagesView){
        _imagesView = [[UIView alloc]init];
         [self.contentView addSubview:_imagesView];
        
        [_imagesView addSubview:self.imagesCollectionView];
        float width = (kDeiveWidth - 10 - 15 -10)/2;
        float height = 210.0/280 *width +10;

        [self.imagesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@235);
             make.left.equalTo(self.imagesView.mas_left);
            make.right.equalTo(self.imagesView.mas_right);
            make.height.equalTo(@(height));
            make.top.equalTo(self.imagesView.mas_top);
        }];

    }
    
    return  _imagesView;
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
        [_imagesCollectionView registerClass:[TSImageCollectionCell class] forCellWithReuseIdentifier:cellId];

    }
    return  _imagesCollectionView;
}

-(UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc]init];
         [self.contentView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = COLOR_RGB(204, 204, 204, 1);
        [_bottomView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@SINGLE_LINE_WIDTH);
//            make.width.equalTo(@12);
            make.height.equalTo(@12);
            make.centerX.equalTo(_bottomView.mas_centerX);
            make.centerY.equalTo(_bottomView.mas_centerY);
        }];
        
      
        [_bottomView addSubview:self.storeBtn];
        [self.storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomView.mas_left);
            make.right.equalTo(lineView.mas_left);
            make.top.equalTo(_bottomView.mas_top);
            make.bottom.equalTo(_bottomView.mas_bottom);
            
            
        }];
        [_bottomView addSubview:self.shareBtn];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineView.mas_right);
            make.right.equalTo(_bottomView.mas_right);
            make.top.equalTo(_bottomView.mas_top);
            make.bottom.equalTo(_bottomView.mas_bottom);
        }];
        
        
        UIView * mainLineView = [[UIView alloc]init];
        [_bottomView addSubview:mainLineView];
        [mainLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomView.mas_left);//.offset(10);
            make.right.equalTo(_bottomView.mas_right);//.offset(-15);
            make.bottom.equalTo(_bottomView.mas_bottom);
            make.height.equalTo(@SINGLE_LINE_WIDTH);
            
        }];
        mainLineView.backgroundColor = COLOR_RGB(219, 219, 219, 1);
        
       

        
    }
    return  _bottomView;
}

-(UIButton *)storeBtn{
    if(!_storeBtn){
        _storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_storeBtn setBackgroundColor:[UIColor grayColor]];
        [_storeBtn setTitleColor:COLOR_RGB(77, 77, 77, 1) forState:UIControlStateNormal];
//        [_storeBtn setTintColor:COLOR_RGB(77, 77, 77, 1)];
        [_storeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _storeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0) ;
        _storeBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 5, 0, 0) ;
        
        [_storeBtn addTarget:self action:@selector(doStore) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _storeBtn;
}

-(UIButton *)shareBtn{
    if(!_shareBtn){
         _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setTintColor:COLOR_RGB(77, 77, 77, 1)];
        [_shareBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0) ;
        _shareBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 5, 0, 0) ;
        [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [_shareBtn setTitleColor:COLOR_RGB(77, 77, 77, 1) forState:UIControlStateNormal];
        [_shareBtn setTitle:@"share" forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];

    }
    return _shareBtn;
}
#pragma mark --  TSBigImageDelegate
-(BOOL) hadDelete{
    return NO;
}

-(BOOL)canDelete:(int)index{
    return NO;
}

-(int) getImageCount{
    return (int)[self.newsVM.news.imgs count];
//    return (int)[self.imageUrls count];
}
-(NSString *) getImageUrlAtIndex:(int)index{
    if([self.newsVM.news.imgs count] > index){
        TSImage *image = self.newsVM.news.imgs[index];
        return image.url;
    }
    return @"";
}
-(UIImage *)getImageAtIndex:(int)index{
    return nil;
}

//+(instancetype) getVCDelete:(id<TSBigImageDelegate>) delegete{
#pragma mark ----------------------------------------
#pragma mark  --  collectionview delegate datasource
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.imagesCollectionView deselectItemAtIndexPath:indexPath animated:YES];
     [TSBigImageView showBigDelegate:self andFirstIndex:indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.newsVM.news.imgs count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TSImage *image = [self.newsVM.news.imgs objectAtIndex:indexPath.row];
    TSImageCollectionCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSURL *imageUrl = [NSURL URLWithString:image.url];
    [cell.imageView sd_setImageWithURL:imageUrl placeholderImage: [UIImage imageNamed:@"img_photo_default"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float width = (kDeiveWidth - 10 - 15 -10)/2;
    float height = 210.0/280 *width ;

    return  CGSizeMake(width , height);
}

-(void)setNewsVM:(TSNewVM *)newsVM{
    _newsVM = newsVM;
    [self resetSubFrameAndData];
}


-(void)resetSubFrameAndData{
    
    [self.headImageView  sd_setImageWithURL:[NSURL URLWithString:self.newsVM.news.avator] placeholderImage: [UIImage imageNamed:@"img_touxiang_default"]];
    
    [self.nameLabel setText:self.newsVM.news.shopName];
    [self.dateLabel setText:[NSString stringWithFormat:@"%@ ",self.newsVM.news.entrydate]];
    [self.distanceLabel setText:[NSString stringWithFormat:@"%@ ",self.newsVM.news.distance]];
    self.contentLabel.frame = self.newsVM.contentRect;
    [self.contentLabel setText:self.newsVM.news.content];
    
    self.imagesView.frame = self.newsVM.imagesRect;
//    [self.imagesCollectionView reloadData];
    self.bottomView.frame = self.newsVM.bottomRect;
    
    if([self.newsVM.news.canFavorite boolValue] || [AppDelegate shareAppDelegate].accountWithNotLogout == nil){
        [self.storeBtn setImage:[UIImage imageNamed:@"store"] forState:UIControlStateNormal];
    }else{
        [self.storeBtn setImage:[UIImage imageNamed:@"store_selected"] forState:UIControlStateNormal];
    }
//    long count = [self.newsVM.news.favoriteCount longValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *string = [formatter stringFromNumber:self.newsVM.news.favoriteCount];
    [self.storeBtn setTitle:string forState:UIControlStateNormal];
    
    [self.imagesCollectionView reloadData];
}


static NSString *newsCell = @"newsCell";
+(void)registTableViewCell:(UITableView *)tableview{
    [tableview registerClass:self forCellReuseIdentifier:newsCell];
}

+(instancetype) getAdeCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withNews:(TSNewVM *)newsVM{
    TSNewsCell *cell =  [tableview dequeueReusableCellWithIdentifier:newsCell forIndexPath:indexPath];
    cell.newsVM = newsVM;
    cell.tableView = tableview;
    return cell;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

#pragma mark -- event
-(void)doStore{
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    TSNews *new =  self.newsVM.news;
    @weakify(self);
    TSAccount *account = [[AppDelegate shareAppDelegate] accountwithVC:[self findViewController]];
    if(!account){
        return;
    }
    if([new.canFavorite boolValue]){
        //TS_INTER_Favorite_Cancel
        [HttpRequestHelper sendHttpRequestBlock:TS_INTER_Favorite_Add postData:@{@"token":[[AppDelegate shareAppDelegate] accountwithVC:[self findViewController]].token?:@"",@"shopId":self.newsVM.news.shopId} backSucess:^(NSDictionary *backData) {
            @strongify(self);
            new.canFavorite =  [NSNumber numberWithBool:NO];
            int count = (new.favoriteCount.intValue +1);
            new.favoriteCount =  [NSNumber numberWithInt:count];
             [self.tableView reloadData];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
        } ];
    }else{
        //TS_INTER_Favorite_Cancel
        [HttpRequestHelper sendHttpRequestBlock:TS_INTER_Favorite_Cancel postData:@{@"token":[[AppDelegate shareAppDelegate] accountwithVC:[self findViewController]].token?:@"",@"shopId":self.newsVM.news.shopId} backSucess:^(NSDictionary *backData) {
            @strongify(self);
            new.canFavorite =  [NSNumber numberWithBool:YES];
            int count = (new.favoriteCount.intValue -1);
            new.favoriteCount =  [NSNumber numberWithInt:count];
            [self.tableView reloadData];
//            if(indexPath){
//                  [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }
//          
            
            
        } ];
    }


    
}
-(void)doShare{
     TSNews *new =  self.newsVM.news;
    [TSShareView show:new.share];
//    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    
//    imageview.image = self.shareImage;
//    UIImage *image;
//    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), YES, [UIScreen mainScreen].scale);
//    CGContextRef context =  UIGraphicsGetCurrentContext();
//    [imageview.layer renderInContext:context];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
  }

@end
