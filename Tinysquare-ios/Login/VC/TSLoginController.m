//
//  TSLoginController.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/4.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSLoginController.h"
#import "TSRegisterVC.h"
#import "HttpRequestHelper.h"
#import "TSAccount.h"
#import "AppDelegate.h"
#import "TSIndexVC.h"
#import "TSForgetVC.h"
#import "NSUserDefaults+Helper.h"
#import "Common.h"
#import "TSUtilties.h"
@interface TSLoginController ()
@end

@implementation TSLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needKeyboardUp = YES;
    [self.passwordTextF setSecureTextEntry:YES];
    [self setNoLineWithAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
    if([self.navigationController.childViewControllers count] > 1){
          [TSUtilties createLeftReturnButtonBlack:self];
    }
    //UITextViewTextDidChangeNotification
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
//    self.passportTextF.delegate = self;
//    self.passportTextF.placeholder;
}

- (void)textChanged:(NSNotification *)notification{
    if([self.passportTextF.text length]>0){
        self.telPreLabel.textColor = self.passportTextF.textColor;
    }else{
        UIColor *color = [self.passportTextF valueForKeyPath:@"_placeholderLabel.textColor"];
        if(color){
            self.telPreLabel.textColor = color;
        }else{
            self.telPreLabel.textColor = [UIColor lightGrayColor];
        }
    }
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    return YES;
//    //[_userName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    self.telPreLabel
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];s
    [self textChanged:nil];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (IBAction)doLogin:(id)sender {
    NSString *account = self.passportTextF.text?:@"";
    NSString *password = self.passwordTextF.text?:@"";
//    account = @"18051094205";//@"13041403124" 111111 18888888888; 123456
//    password = @"123456";
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_LOGIN postData:@{@"account":account,@"password":password} backSucess:^(id backData) {
        TSAccount *tsAccount = [TSAccount objectWithDic:backData];
        [AppDelegate shareAppDelegate].account = tsAccount;
        [[NSUserDefaults standardUserDefaults] setAccount:tsAccount];
         [AppDelegate shareAppDelegate].indexVC = [TSIndexVC getVC];
         [AppDelegate shareAppDelegate].window.rootViewController =  [AppDelegate shareAppDelegate].indexVC;
//        [AppDelegate shareAppDelegate].window.rootViewController = [TSIndexVC getVC];
        
    }];
    
    
}
- (IBAction)forget:(id)sender {
    UIViewController *vc = [TSForgetVC getResetVC];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)newUser:(id)sender {
   UIViewController *vc =  [TSRegisterVC getVC];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
