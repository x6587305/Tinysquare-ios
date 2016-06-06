//
//  TSIndexVC.m
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/8.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSIndexVC.h"
#import "TSMyVC.h"
#import "AppDelegate.h"
#import "TSAccount.h"
#import "Common.h"
@interface TSIndexVC ()<UITabBarControllerDelegate>

@end

@implementation TSIndexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: COLOR_SIGLE(153),
                                                        NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    //选中文字大小和颜色

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: COLOR_RGB(255, 71, 71, 1),
                                                        NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([[viewController.childViewControllers firstObject] isKindOfClass:[TSMyVC class]]) {
        TSAccount *account = [AppDelegate shareAppDelegate].accountWithNotLogout;
        if(!account){
             [[AppDelegate shareAppDelegate] accountwithVC:[[self.childViewControllers firstObject].childViewControllers lastObject]];
            return NO;
        }
    }
    return YES;
    
}

+(instancetype)getVC{
   return  [[UIStoryboard storyboardWithName:@"Index" bundle:nil] instantiateViewControllerWithIdentifier:@"TSIndexVC"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
