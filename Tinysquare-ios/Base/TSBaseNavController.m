//
//  TSBaseNavController.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/10.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseNavController.h"
#import "Common.h"
@interface TSBaseNavController ()

@end

@implementation TSBaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[UINavigationBar appearance] setBarTintColor:MAIN_RED];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                                                          NSForegroundColorAttributeName,
                                                          [UIFont systemFontOfSize:20],
                                                          NSFontAttributeName, nil]];
     [[UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    [UINavigationBar appearance].barStyle = UIStatusBarStyleDefault;
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
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
