//
//  TSHeaderCell.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/28.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//+(void)registTableViewCell:(UITableView *)tableview;

+(instancetype) getCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withHeaderUrl:(NSString *)headerUrl;
@end
