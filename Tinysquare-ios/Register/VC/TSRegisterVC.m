//
//  TSRegisterVC.m
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/6.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSRegisterVC.h"
#import "TSAccount.h"
#import "HttpRequestHelper.h"
#import "AppDelegate.h"
#import "MyCenterTips.h"
#import "NSUserDefaults+Helper.h"
#import "TSIndexVC.h"
#import "Common.h"
#import "TSUtilties.h"
@interface TSRegisterVC ()

@end

@implementation TSRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"Register";
    self.needKeyboardUp = YES;
    [self setNoLineWithAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
    [TSUtilties createLeftReturnButtonBlack:self];
    self.passwordTextF.secureTextEntry = YES;
    self.rePasswordTextF.secureTextEntry = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:YES];
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];s
    [self textChanged:nil];
    
    
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
- (IBAction)doRegister:(id)sender {
    NSDictionary *postData = [NSDictionary dictionary];
    NSString *account = self.passportTextF.text;
    NSString *password = self.passwordTextF.text;
    NSString *rePassword = self.rePasswordTextF.text;
    NSString *email = self.emailTextF.text;
    if(!([account length]>0)){
     

        [MyCenterTips showCode:@"ERROR_ACCOUNT_EMPTY"];

        return;
    }
    if(!([password length]>0)){
        
        [MyCenterTips showCode:@"ERROR_PASSWORD_EMPTY"];
        return;
    }
    if(![password isEqualToString:rePassword]){
        
//        [MyCenterTips showCode:@"ERROR_PASSWORD_EMPTY"];

        [MyCenterTips showTips:@"两次密码不同!"];
        return;
    }
    if(!([email length]>0)){
        
        [MyCenterTips showCode:@"ERROR_EMAIL_EMPTY"];
        return;
    }
    postData = @{@"account":account,@"password":password,@"email":email};
    
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_REGISTER postData:postData backSucess:^(id backData) {

        TSAccount *tsAccount = [TSAccount objectWithDic:backData];
        [AppDelegate shareAppDelegate].account = tsAccount;
        [[NSUserDefaults standardUserDefaults] setAccount:tsAccount];
//        [AppDelegate shareAppDelegate].window.rootViewController = [TSIndexVC getVC];
        [AppDelegate shareAppDelegate].indexVC = [TSIndexVC getVC];
        [AppDelegate shareAppDelegate].window.rootViewController =  [AppDelegate shareAppDelegate].indexVC;

    }];
}
+(instancetype) getVC{
    return [[UIStoryboard storyboardWithName:@"Register" bundle:nil] instantiateViewControllerWithIdentifier:@"Register"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
