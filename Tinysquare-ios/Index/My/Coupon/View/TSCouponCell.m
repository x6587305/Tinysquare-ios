//
//  TSCouponCell.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/24.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSCouponCell.h"
#import "TSCoupon.h"
#import <Masonry.h>
#import "Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface TSCouponCell()
@property(nonatomic,strong) UIImageView *backImageView;
@property(nonatomic,strong) UILabel *leftLabel;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UILabel *dataLabel;
@end
@implementation TSCouponCell
// 290 68
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.backImageView];
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@290);
            make.height.equalTo(@68);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        self.backImageView.image = [UIImage imageNamed:@"coupon_back"];
        
        self.leftLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.leftLabel];
        [self.leftLabel setFont:[UIFont systemFontOfSize:25]];
        [self.leftLabel setTextColor:[UIColor whiteColor]];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backImageView.mas_left).offset(15);
            make.centerY.equalTo(self.backImageView.mas_centerY);
        }];
        
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SINGLE_LINE_WIDTH, 28)];
//        lineView.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@SINGLE_LINE_WIDTH);
//            make.height.equalTo(@28);
//            make.left.equalTo(self.);
//            make.centerY.equalTo(self.backImageView.mas_centerY);
//        }];
        
        self.contentLabel = [[UILabel alloc]init];
        [self.contentLabel setTextColor:[UIColor whiteColor]];
        [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backImageView.mas_top).offset(20);
            make.left.equalTo(self.backImageView.mas_left).offset(100);
        }];
        
        self.dataLabel = [[UILabel alloc]init];
        [self.dataLabel setTextColor:[UIColor whiteColor]];
        [self.dataLabel setFont:[UIFont systemFontOfSize:10]];
        [self.contentView addSubview:self.dataLabel];
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backImageView.mas_bottom).offset(-15);
            make.left.equalTo(self.backImageView.mas_left).offset(100);
        }];
        
        
    }
    return self;
}

-(void)resetSubFrameAndData:(TSCoupon *)coupon andIndexPath:(NSIndexPath *)indexPath{
    
    if(coupon.couponImg && coupon.couponImg.length > 0){
        self.leftLabel.hidden = YES;
        self.contentLabel.hidden = YES;
        self.dataLabel.hidden = YES;
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:coupon.couponImg] placeholderImage:[UIImage imageNamed:@"coupon_back"]];
    }
    else{
        self.leftLabel.hidden = NO;
        self.contentLabel.hidden = NO;
        self.dataLabel.hidden = NO;
        [self.leftLabel setText:[NSString stringWithFormat:@"$%d",coupon.amount.intValue]];
        [self.contentLabel setText:[NSString stringWithFormat:@"%@",coupon.shopName]];
        [self.dataLabel setText:[NSString stringWithFormat:@"Validity : %@",coupon.entrydate]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


static NSString *cellId = @"TSCouponCell";
+(void)registTableViewCell:(UITableView *)tableview{
    [tableview registerClass:self forCellReuseIdentifier:cellId];
}

+(instancetype) getCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withCoupon:(TSCoupon *)coupon  {
    TSCouponCell *cell =  [tableview dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [cell resetSubFrameAndData:coupon andIndexPath:indexPath];

    return cell;
}

@end
