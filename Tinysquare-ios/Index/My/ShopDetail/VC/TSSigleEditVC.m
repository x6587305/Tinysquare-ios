//
//  TSSigleEditVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/29.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSSigleEditVC.h"
#import "TSShop.h"
#import "HttpRequestHelper.h"
#import "AppDelegate.h"
#import "Common.h"
#import "TSUtilties.h"
@interface TSSigleEditVC ()
@property(nonatomic,weak) TSShop *shop;
@property(nonatomic,assign) int type;
@end

@implementation TSSigleEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TSUtilties createLeftReturnButtonBlack:self];
    [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
    self.view.backgroundColor = COLOR_RGB(241, 241, 241, 1);
    [self createRightBarTitle:@"comfirm" TitleColor:COLOR_SIGLE(52) btnSize:CGSizeMake(100, 30) target:self select:@selector(doSubmit)];
    switch (self.type) {
        case 1:{
            self.title = @"Name";
            self.sigleText.text = self.shop.name;
        }
            break;
        case 2:{
            self.title = @"Telephone";
            self.sigleText.text = self.shop.tel;
        }
            break;
        case 3:{
            self.title = @"Address";
            self.sigleText.text = self.shop.address;
        }
            break;
        case 4:{
            self.title = @"Brief";
            self.sigleText.text = self.shop.brief;
        }
            break;
            
        default:
            break;
    }
    self.sigleText.backgroundColor = COLOR_SIGLE(241);
    
}

-(void)doSubmit{
    NSString *url = TS_INTER_SHOP_NAME;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"" forKey:@"token" ];
    switch (self.type) {
        case 1:{
            url= TS_INTER_SHOP_NAME;
            [dic setObject:self.sigleText.text forKey: @"name"];
        }
            break;
        case 2:{
            [dic setObject:self.sigleText.text forKey: @"tel"];
             url= TS_INTER_SHOP_TEL;
        }
            break;
        case 3:{
            [dic setObject:self.sigleText.text forKey: @"address"];
            url= TS_INTER_SHOP_ADDRESS;
        }
            break;
        case 4:{
            [dic setObject:self.sigleText.text forKey: @"brief"];
             url= TS_INTER_SHOP_BRIEF;
        }
            break;
            
        default:
            break;
    }
//    [self.delegate doSubmit:self.sigleText.text];
    [HttpRequestHelper sendHttpRequestBlock:url postData:dic backSucess:^(id backData) {
        switch (self.type) {
            case 1:{
                self.shop.name = self.sigleText.text;
            }
                break;
            case 2:{
                self.shop.tel = self.sigleText.text;
            }
                break;
            case 3:{
                self.shop.address = self.sigleText.text;
            }
                break;
            case 4:{
                self.shop.brief = self.sigleText.text;
            }
                break;
                
            default:
                break;
        }
        [self.navigationController popViewControllerAnimated:YES];
    } backFalied:^(id backData) {
        
    }];
}

+(instancetype)getVcShop:(TSShop *)shop atType:(int)type{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"ShopDetail" bundle:nil];
    TSSigleEditVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"TSSigleEditVC"];
    vc.shop = shop;
    vc.type = type;
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
