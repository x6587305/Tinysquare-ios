//
//  TSCouponCell.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/24.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSCoupon;
@interface TSCouponCell : UITableViewCell
+(void)registTableViewCell:(UITableView *)tableview;

+(instancetype) getCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withCoupon:(TSCoupon *)coupon ;
@end
