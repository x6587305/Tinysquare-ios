//
//  TSNewsCell.h
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/8.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSNewVM;
@interface TSNewsCell : UITableViewCell
@property(nonatomic,strong) TSNewVM *newsVM;

+(void)registTableViewCell:(UITableView *)tableview;
+(instancetype) getAdeCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withNews:(TSNewVM *)newsVM;
@end
