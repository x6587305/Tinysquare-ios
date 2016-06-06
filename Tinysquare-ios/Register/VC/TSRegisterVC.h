//
//  TSRegisterVC.h
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/6.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSBaseVC.h"
@interface TSRegisterVC : TSBaseVC
@property (weak, nonatomic) IBOutlet UITextField *passportTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextF;
@property (weak, nonatomic) IBOutlet UITextField *emailTextF;
@property (weak, nonatomic) IBOutlet UILabel *telPreLabel;
+(instancetype) getVC;
@end
