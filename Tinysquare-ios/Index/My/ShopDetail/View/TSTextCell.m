//
//  TSTextCell.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/28.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSTextCell.h"

@implementation TSTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
      self.selectionStyle = UITableViewCellSelectionStyleNone;
}

static NSString *cellId = @"TSTextCell";
//+(void)registTableViewCell:(UITableView *)tableview{
//    [tableview registerClass:self forCellReuseIdentifier:cellId];
//}

+(instancetype) getCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath leftText:(NSString *)leftText rightText:(NSString *)rightText{
    TSTextCell *cell =  [tableview dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.leftTextLabel.text = leftText;
    cell.rightTextLabel.text = rightText;
    
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
