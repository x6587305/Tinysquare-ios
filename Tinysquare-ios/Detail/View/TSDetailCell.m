//
//  TSDetailCell.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/10.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSDetailCell.h"
#import "Common.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TSShareView.h"
@interface TSDetailCell()
@property(nonatomic,strong) UIImageView *headerView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UILabel *dataLabel;
@property(nonatomic,strong) UIButton *shareBtn;

@property(nonatomic,strong) UIView *lineView;
@end
@implementation TSDetailCell

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
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-8);
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

-(void)doshare{
    [TSShareView show: self.news.share];
}



static NSString *cellId = @"TSDetailCell";
+(void)registTableViewCell:(UITableView *)tableview{
    [tableview registerClass:self forCellReuseIdentifier:cellId];
}

+(instancetype) getAdeCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withNews:(TSNews *)news andShop:(TSShop *) shop isLast:(BOOL) isLast{
    TSDetailCell *cell =  [tableview dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
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
