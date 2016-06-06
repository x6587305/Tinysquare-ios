//
//  TSMobileCell.h
//  Tinysquare
//
//  Created by xiezhaojun on 16/6/5.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSMobileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *preLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
