//
//  TSImageCell.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/28.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  TSShop;
@interface TSImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftTextLabel;
//+(void)registTableViewCell:(UITableView *)tableview;
@property(nonatomic,strong)NSMutableArray<NSString *> *imageUrls;
+(instancetype) getCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath andShop:(TSShop *)shop;
@end
