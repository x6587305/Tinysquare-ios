//
//  TSDetailImageCell.h
//  Tinysquare
//
//  Created by xiezhaojun on 16/6/5.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSNews.h"
#import "TSShop.h"
@interface TSDetailImageCell : UITableViewCell
@property(nonatomic,weak) TSNews *news;
@property(nonatomic,weak) TSShop *shop;
+(void)registTableViewCell:(UITableView *)tableview;

+(instancetype) getAdeCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withNews:(TSNews *)news andShop:(TSShop *) shop isLast:(BOOL) isLast;
@end
