//
//  TSTextEditVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/29.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSTextEditVC.h"
#import "TSShop.h"
#import "HttpRequestHelper.h"
#import "AppDelegate.h"
#import "Common.h"
#import "TSUtilties.h"
@interface TSTextEditVC ()
@property(nonatomic,weak) TSShop *shop;
@end

@implementation TSTextEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TSUtilties createLeftReturnButtonBlack:self];
    [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
    self.view.backgroundColor = COLOR_SIGLE(241);//[UIColor whiteColor];
//    self.view.backgroundColor = [UIColor lightGrayColor];
    [self createRightBarTitle:@"comfirm" TitleColor:COLOR_SIGLE(52) btnSize:CGSizeMake(100, 30) target:self select:@selector(doSubmit)];
    self.title = @"Brief";
    self.textView.text = self.shop.brief;
}

-(void)doSubmit{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"" forKey:@"token"];
    [dic setObject: self.textView.text forKey:@"brief"  ];

    //    [self.delegate doSubmit:self.sigleText.text];
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_SHOP_BRIEF postData:dic backSucess:^(id backData) {
        self.shop.brief = self.textView.text;
        [self.navigationController popViewControllerAnimated:YES];
    } backFalied:^(id backData) {
        
    }];
}

+(instancetype)getVcShop:(TSShop *)shop{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"ShopDetail" bundle:nil];
    TSTextEditVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"TSTextEditVC"];
    vc.shop = shop;

    return vc;
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
