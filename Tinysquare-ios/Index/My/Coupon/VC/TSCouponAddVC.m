//
//  TSCouponAddVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/25.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSCouponAddVC.h"
#import <Masonry.h>
#import "Common.h"
#import "PhoneTextField.h"
#import "HttpRequestHelper.h"
#import "AppDelegate.h"
#import "TSCoupon.h"
#import "MyCenterTips.h"
#import "TSUtilties.h"
@interface TSCouponAddVC ()
@property(nonatomic,strong) PhoneTextField *codeText;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *submitBtn;
//@property(nonatomic,strong) TSCoupon *coupon;
@end

@implementation TSCouponAddVC

//-(UITextField *)codeText{
//    if(!_codeText){
//        _codeText = [[UITextField alloc]init];
//        [self.view addSubview:_codeText];
//        [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_top).offset(10);
//            make.left.equalTo(self.view.mas_left).offset(10);
//            make.right.equalTo(self.view.mas_right).offset(-10);
//            make.height.equalTo(@44);
//        }];
//        [_codeText setPlaceholder:@"请输入兑换劵码"];
//    }
//    return _codeText;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
      [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
    [TSUtilties createLeftReturnButtonBlack:self];
    self.view.backgroundColor = COLOR_SIGLE(241);
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, 0)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    if(!_codeText){
        _codeText = [[PhoneTextField alloc]init];
        [backView addSubview:_codeText];
        [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(10);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.equalTo(@44);
        }];
        [_codeText setPlaceholder:@"请输入兑换劵码"];
        _codeText.layer.borderWidth = SINGLE_LINE_WIDTH;
        _codeText.layer.borderColor = COLOR_SIGLE(230).CGColor;
    }
    
    UIView *hLine = [[UIView alloc]init];
    hLine.backgroundColor = COLOR_SIGLE(230);
    [backView addSubview:hLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeText.mas_left);
        make.width.equalTo(self.codeText.mas_width);
        make.height.equalTo(@SINGLE_LINE_WIDTH);
        make.top.equalTo(self.codeText.mas_bottom).offset(10);
    }];
    
    UIView *vLine =[[UIView alloc]init];
    vLine.backgroundColor = COLOR_SIGLE(204);
    [backView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.equalTo(@SINGLE_LINE_WIDTH);
     
        make.top.equalTo(hLine.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:COLOR_SIGLE(103) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COLOR_RGB(228, 82, 83, 1) forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(doCance) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeText.mas_left);
        make.height.equalTo(@40);
        make.top.equalTo(hLine.mas_bottom);
        make.right.equalTo(vLine.mas_left);
        
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitleColor:COLOR_SIGLE(103) forState:UIControlStateNormal];
    [submitBtn setTitleColor:COLOR_RGB(228, 82, 83, 1) forState:UIControlStateHighlighted];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.top.equalTo(hLine.mas_bottom);
        make.left.equalTo(vLine.mas_right);
        make.right.equalTo(self.codeText.mas_right);

    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(submitBtn.mas_bottom);
    }];
}

-(void)doSubmit{
    NSLog(@"doSubmit");
    NSString *code = self.codeText.text;
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_Coupon_REDEEM postData:@{@"token":[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"",@"code":code} backSucess:^(NSArray *backData) {
        [MyCenterTips showNoImageTips:@"Redeem success!"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)doCance{
     NSLog(@"doCance");
    [self.navigationController popViewControllerAnimated:YES];
}

+(instancetype)getVC{
    return [[TSCouponAddVC alloc]init];
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
