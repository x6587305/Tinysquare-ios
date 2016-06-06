//
//  TSPreviousCell.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/3.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSNews.h"
#import "TSShop.h"
@interface TSPreviousCell : UITableViewCell
@property(nonatomic,strong) TSNews *news;
@property(nonatomic,strong) TSShop *shop;
+(void)registTableViewCell:(UITableView *)tableview;

+(instancetype) getAdeCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withNews:(TSNews *)news andShop:(TSShop *)shop;
@end
