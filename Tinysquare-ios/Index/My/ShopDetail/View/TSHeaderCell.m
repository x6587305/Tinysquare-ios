//
//  TSHeaderCell.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/28.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSHeaderCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation TSHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
   
    // Initialization code
}

static NSString *cellId = @"TSHeaderCell";
//+(void)registTableViewCell:(UITableView *)tableview{
//    [tableview registerClass:self forCellReuseIdentifier:cellId];
//}

+(instancetype) getCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withHeaderUrl:(NSString *)headerUrl{
    TSHeaderCell *cell =  [tableview dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.leftTextLabel.text = @"Avator";
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headImageView.contentMode = UIViewContentModeScaleToFill;
    cell.headImageView.layer.cornerRadius = 4;
   
    cell.headImageView.layer.masksToBounds = YES;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage: [UIImage imageNamed:@"img_touxiang_default"]];
    
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
