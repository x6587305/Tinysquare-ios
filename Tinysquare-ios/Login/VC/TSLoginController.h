//
//  TSLoginController.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/4.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSBaseVC.h"
@interface TSLoginController : TSBaseVC
@property (weak, nonatomic) IBOutlet UITextField *passportTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UILabel *telPreLabel;

@end
