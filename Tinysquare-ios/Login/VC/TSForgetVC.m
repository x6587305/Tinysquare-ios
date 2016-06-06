//
//  TSForgetVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/3.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSForgetVC.h"
#import "Common.h"
#import "HttpRequestHelper.h"
#import "MyCenterTips.h"
#import "AppDelegate.h"
#import "NSUserDefaults+Helper.h"
#import "TSUtilties.h"
#import "TSMobileCell.h"
enum Password_Type{
    Password_Type_Reset = 1,
    Password_Type_Update = 2
};
@interface TSForgetVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) enum Password_Type type;

@end

@implementation TSForgetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.type == Password_Type_Reset){
        self.title = @"Forgot password";

    }else{
         self.title = @"Change password";
    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth , 150) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = COLOR_SIGLE(240);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(self.type == Password_Type_Reset){
        [button setTitle:@"Reset Password" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"Confirm" forState:UIControlStateNormal];
    }

    button.frame = CGRectMake(25, 190, kDeiveWidth - 50, 44);
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
   
    [button addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:COLOR_RGB(255, 71, 71, 1)];
    [self.view addSubview:button];
    
    [self setNoLineWithAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
      [TSUtilties createLeftReturnButtonBlack:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TSMobileCell" bundle:nil] forCellReuseIdentifier:@"TSMobileCell"];

    
}


-(void)resetPassword{
    if(self.type == Password_Type_Reset){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            UITextField *textField = [cell viewWithTag:1011];
            NSString *value = textField.text?:@"";
            if(self.type == Password_Type_Reset){
                [dic setObject:value forKey:@"account"];
            }else{
                
            }
            //oldPassword newPassword
        }
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            UITextField *textField = [cell viewWithTag:1011];
            NSString *value = textField.text?:@"";
            [dic setObject:value forKey:@"email"];
        }
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            UITextField *textField = [cell viewWithTag:1011];
            NSString *value = textField.text?:@"";
            [dic setObject:value forKey:@"newPassword"];
        }
        [HttpRequestHelper sendHttpRequestBlock:TS_INTER_RESET postData:dic backSucess:^(id backData) {
            [MyCenterTips  showTips:@"Reset password success!"];
        }];

    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            UITextField *textField = [cell viewWithTag:1011];
            NSString *value = textField.text?:@"";
            [dic setObject:value forKey:@"oldPassword"];
            //oldPassword newPassword
        }
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            UITextField *textField = [cell viewWithTag:1011];
            NSString *value = textField.text?:@"";
            [dic setObject:value forKey:@"newPassword"];
        }
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            UITextField *textField = [cell viewWithTag:1011];
            NSString *value = textField.text?:@"";
            [dic setObject:value forKey:@"renewPassword"];
        }
        [dic setObject:[AppDelegate shareAppDelegate].accountWithNotLogout.token?:@"" forKey:@"token"];
        if(![[dic objectForKey:@"newPassword"] isEqualToString:[dic objectForKey:@"renewPassword"]]){
            [MyCenterTips  showTips:@"两次密码不等！"];

        }
        [HttpRequestHelper sendHttpRequestBlock:TS_INTER_PASSWPRD_UPDATE postData:dic backSucess:^(id backData) {
            TSAccount *tsAccount = [TSAccount objectWithDic:backData];
            [AppDelegate shareAppDelegate].account = tsAccount;
            [[NSUserDefaults standardUserDefaults] setAccount:tsAccount];
            [self.navigationController popViewControllerAnimated:YES];
        }];

    }
   
    

}
///user/resetPassword

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.type == Password_Type_Reset && indexPath.row == 0){
        TSMobileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSMobileCell"];
        return cell;
    }

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forgetCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"forgetCell"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
        [cell.contentView addSubview:imageView];
        imageView.center = CGPointMake(10+9, 25);
        imageView.tag = 1010;
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(38, 0, kDeiveWidth-38, 50)];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField setFont:[UIFont systemFontOfSize:16]];
        textField.tag = 1011;
        [cell.contentView addSubview:textField];
        
    }
    UIImageView *imageView = [cell viewWithTag:1010];
     UITextField *textField = [cell viewWithTag:1011];
    [textField setFont:[UIFont systemFontOfSize:16]];
    
    if(self.type == Password_Type_Reset){
        switch (indexPath.row) {
            case 0:{
                imageView.image = [UIImage imageNamed:@"user"];// //my_post user password
                [textField setPlaceholder:@"User"];
                  textField.secureTextEntry = NO;
            }
                
                break;
            case 1:{
                imageView.image = [UIImage imageNamed:@"my_post"];
                [textField setPlaceholder:@"Email"];
                  textField.secureTextEntry = NO;
            }
                
                break;
            case 2:{
                imageView.image = [UIImage imageNamed:@"password"];
                [textField setPlaceholder:@"New Password"];
                  textField.secureTextEntry = YES;
            }
                
                break;
                
            default:
                break;
        }

    }else{
        switch (indexPath.row) {
            case 0:{
                imageView.image = [UIImage imageNamed:@"password"];// //my_post user password
                [textField setPlaceholder:@"Old password"];
                  textField.secureTextEntry = YES;
            }
                
                break;
            case 1:{
                imageView.image = [UIImage imageNamed:@"password"];
                [textField setPlaceholder:@"New password"];
                  textField.secureTextEntry = YES;
            }
                
                break;
            case 2:{
                imageView.image = [UIImage imageNamed:@"password"];
                [textField setPlaceholder:@"Re-enter new password"];
                  textField.secureTextEntry = YES;
            }
                
                break;
                
            default:
                break;
        }

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
+(instancetype) getResetVC{
    TSForgetVC *vc = [[TSForgetVC alloc]init];
    vc.type = Password_Type_Reset;
    return vc;
}

+(instancetype) getUpdateVC{
    TSForgetVC *vc = [[TSForgetVC alloc]init];
    vc.type = Password_Type_Update;
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
