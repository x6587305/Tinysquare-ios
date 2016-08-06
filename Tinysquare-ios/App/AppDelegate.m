//
//  AppDelegate.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/4.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "AppDelegate.h"
#import <WXApi.h>

#import "NSUserDefaults+Helper.h"
#import "MyCenterTips.h"
#import <IQKeyboardManager.h>
@interface AppDelegate ()
@property(nonatomic,strong) TSAccount *account;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.indexVC = [TSIndexVC getVC];
    self.window.rootViewController = self.indexVC;
    self.window.backgroundColor = [UIColor whiteColor];
     [WXApi registerApp:@"wxe6a0c5128567dead" withDescription:@"weixin"];
    [self.window makeKeyAndVisible];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.account = [defaults getAccount];
    [UITextField appearance].clearButtonMode = UITextFieldViewModeWhileEditing;
    [IQKeyboardManager sharedManager].enable = YES;
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    
    return [WXApi handleOpenURL:url delegate:self];
}
//微信返回功能处理
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        SendMessageToWXResp *resM = (SendMessageToWXResp *)resp;
        if(resM.errCode == 0){
             [MyCenterTips showTips:@"share success!"];
        }
       
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(TSAccount *)accountwithVC:(UIViewController *)vc{
    if(!_account){
        UIViewController *loginVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"TSLoginController"];
        loginVc.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:loginVc animated:YES];
    }
    return _account;
}
-(void)setAccount:(TSAccount *)account{
    _account = account;
}

-(TSAccount *)accountWithNotLogout{
    return _account;
}

+(void)logout{
    [self shareAppDelegate].account = nil;
    [[NSUserDefaults standardUserDefaults] setAccount:nil];
    UINavigationController *navc = [self shareAppDelegate].indexVC.childViewControllers[[self shareAppDelegate].indexVC.selectedIndex];
    
    UIViewController *loginVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"TSLoginController"];
    loginVc.hidesBottomBarWhenPushed = YES;

    
    if(navc && [navc isKindOfClass:[UINavigationController class]]){
         [navc pushViewController:loginVc animated:YES];
    }else{
        [AppDelegate shareAppDelegate].window.rootViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];

    }
    // self.account = nil;
//    [[NSUserDefaults standardUserDefaults] setAccount:nil];
//    if()
//    [[AppDelegate shareAppDelegate] logout];
}
-(void)logout{
    self.account = nil;
    [[NSUserDefaults standardUserDefaults] setAccount:nil];
    [AppDelegate shareAppDelegate].window.rootViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
}
+(AppDelegate *) shareAppDelegate{
        return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
@end
