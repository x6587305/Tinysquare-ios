//
//  AppDelegate.h
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/4.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSAccount.h"
#import "TSIndexVC.h"
#import <WXApi.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)TSIndexVC *indexVC;

@property(nonatomic,weak) TSAccount *accountWithNotLogout;


+(AppDelegate *) shareAppDelegate;
+(void)logout;
-(TSAccount *)accountwithVC:(UIViewController *)vc;
-(void)setAccount:(TSAccount *)account;
@end

