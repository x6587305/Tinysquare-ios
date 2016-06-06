//
//  TSCardCloseCell.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/22.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSCard;
@class TSCardVC;
@interface TSCardCloseCell : UITableViewCell
@property(nonatomic,strong) TSCard *card;
@property(nonatomic,weak) TSCardVC *vc;
+(void)registTableViewCell:(UITableView *)tableview;

+(instancetype) getCell:(UITableView *)tableview atIndexPath:(NSIndexPath *)indexPath withCards:(TSCard *)card  isFirstDefault:(BOOL) isFirstDefaule;

-(void) update;
//-(void)setDefaultCard:(TSCard *)card;
@end
