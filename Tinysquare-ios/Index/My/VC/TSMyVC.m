//
//  TSMyVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/10.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSMyVC.h"
#import "AppDelegate.h"
#import "Common.h"
#import <Masonry.h>
#import "TSHomeController.h"
#import "TSSettingVC.h"
#import "TSMessageVC.h"
#import "TSCardVC.h"
#import "TSCouponVC.h"
#import "TSNewPostVC.h"
#import "TSShop.h"
#import "HttpRequestHelper.h"
#import "TSCard.h"
#import "TSEditShopDetailVC.h"
#import "TSPreviousVC.h"
#import "TSIndexVC.h"
#import "TSCardCloseCell.h"
#import "TSUtilties.h"
#import "NSUserDefaults+Helper.h"
#import "TSShare.h"
#import "TSShareView.h"
#import "TSHUDView.h"
typedef  void(^ClickBlock)();
@interface TableData : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,strong) UIImage *headerImage;
@property(nonatomic,copy) ClickBlock clickBlock;


-(void) doClick;
-(instancetype)initName:(NSString *)name headerImage:(UIImage *)image clickBlock:(ClickBlock)block;
@end

@implementation TableData
-(instancetype)initName:(NSString *)name headerImage:(UIImage *)image clickBlock:(ClickBlock)block{
    self = [super init];
    if (self) {
        self.name = name;
        self.headerImage = image;
        self.clickBlock = block;
    }
    return self;
}
-(void) doClick{
    
}
@end

@interface TSMyVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign) int pageNumber;
@property(nonatomic,strong) NSArray* tableData;
//@property(nonatomic,strong) TSCardCloseCell *headerView;
@property(nonatomic,strong) TSCard *vipCard;
@property(nonatomic,strong) TSShop *shop;

//@property(nonatomic,weak) TSAccount *account;
@end

@implementation TSMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [TSCardCloseCell registTableViewCell:self.tableView];
    self.tableView.bounces = NO;
//    self.account = [[AppDelegate shareAppDelegate] accountwithVC:self];

//    float width = kDeiveWidth;
//    float height = 308.0/640.0*width;

//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
//    self.headerView =[[TSCardCloseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"test"];
//    self.headerView.frame = CGRectMake(0, 0, width, height);
    //[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self refreshNetData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    NSNumber *category =  [AppDelegate shareAppDelegate].accountWithNotLogout.category;
//    
//    if(category.intValue == ACCOUNT_TYPE_NORMAL){
//        [headerView addSubview:self.headerImageView];
//        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(headerView.mas_width).offset(-20);
//            make.height.equalTo(headerView.mas_height).offset(-20);
//            make.centerX.equalTo(headerView.mas_centerX);
//            make.centerY.equalTo(headerView.mas_centerY);
//        }];
//        
//    }
    
    if(![AppDelegate shareAppDelegate].accountWithNotLogout){
       UIViewController *vc = [AppDelegate shareAppDelegate].window.rootViewController;
        if([vc isKindOfClass:[TSIndexVC class]]){
            TSIndexVC *indexVC = (TSIndexVC *)vc;
            indexVC.selectedIndex = 0;
            [[AppDelegate shareAppDelegate] accountwithVC:[[indexVC.childViewControllers firstObject].childViewControllers lastObject]];
        }
    }
    @weakify(self);
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_MINE postData:@{@"token": [AppDelegate shareAppDelegate].accountWithNotLogout.token?:@""} backSucess:^(NSDictionary *backData) {
        if(backData){
            @strongify(self);
            NSDictionary *cardDic = [backData objectForKey:@"vipCard"];
            NSDictionary *shopDic = [backData objectForKey:@"shop"];

            self.vipCard = [TSCard objectWithDic:cardDic];
            self.shop = [TSShop objectWithDic:shopDic];
            [self setUpData];
            [self.tableView reloadData];
        }
    } ];
    
}

//    [self setUpData];
-(void)setUpData{
    NSNumber *category = [[AppDelegate shareAppDelegate] accountwithVC:self].category;
     NSMutableArray *arr = [NSMutableArray array];
      NSMutableArray *selection1 = [NSMutableArray array];
      @weakify(self);
    if(category.intValue == ACCOUNT_TYPE_SHOPER){
        TableData *newPost = [[TableData alloc]initName:@"New Post" headerImage:[UIImage imageNamed:@"my_post"] clickBlock:^{
            @strongify(self);
            UIViewController *vc = [TSNewPostVC getVC:self.shop andNews:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        [selection1 addObject:newPost];
        
        TableData *myProfile = [[TableData alloc]initName:@"My Profile" headerImage:[UIImage imageNamed:@"my_profile"] clickBlock:^{
            @strongify(self);
            TSEditShopDetailVC * vc = [TSEditShopDetailVC  getVC:self.shop];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            //            UIViewController *vc = [TSCardVC getVC];
            //            vc.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        [selection1 addObject:myProfile];
        
        TableData *previousPost = [[TableData alloc]initName:@"Previous Post" headerImage:[UIImage imageNamed:@"my_pre"] clickBlock:^{
            @strongify(self);
            
            
            TSPreviousVC * vc = [TSPreviousVC  getVC:self.shop];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            //            UIViewController *vc = [TSCardVC getVC];
            //            vc.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        [selection1 addObject:previousPost];

        
    }else{
        TableData *myCards = [[TableData alloc]initName:@"My Cards" headerImage:[UIImage imageNamed:@"my_card"] clickBlock:^{
            @strongify(self);
            UIViewController *vc = [TSCardVC getVC];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        [selection1 addObject:myCards];
        TableData *myCoupon = [[TableData alloc]initName:@"My Coupon" headerImage:[UIImage imageNamed:@"my_coupon"] clickBlock:^{
            @strongify(self);
            
            UIViewController *vc = [TSCouponVC getVC];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }];
        [selection1 addObject:myCoupon];
        TableData *myFavourites = [[TableData alloc]initName:@"My Favourites" headerImage:[UIImage imageNamed:@"my_favourte"] clickBlock:^{
            @strongify(self);
            UIViewController *vc = [TSHomeController getStoreVC];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }];
        [selection1 addObject:myFavourites];
        TableData *Message = [[TableData alloc]initName:@"Message" headerImage:[UIImage imageNamed:@"my_post"] clickBlock:^{
            @strongify(self);
            TSMessageVC *vc = [TSMessageVC getVC];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        [selection1 addObject:Message];
    }
  
   
    
  
    
    [arr addObject:selection1];
    
    NSMutableArray *selection2 = [NSMutableArray array];
    TableData *setting = [[TableData alloc]initName:@"Setting" headerImage:[UIImage imageNamed:@"my_setting"] clickBlock:^{
         @strongify(self);
        TSSettingVC *vc = [TSSettingVC getVC];
          vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    [selection2 addObject:setting];
    [arr addObject:selection2];
    
    NSMutableArray *selection3 = [NSMutableArray array];
   
    TableData *shareThisApp = [[TableData alloc]initName:@"Share" headerImage:[UIImage imageNamed:@"my_share"] clickBlock:^{
        [TSHUDView show];
        [HttpRequestHelper sendHttpRequestBlock:TS_INTER_SHARE postData:@{} backSucess:^(id backData) {
               TSShare *share = [TSShare objectWithDic:backData];
              [TSHUDView hide];
            [TSShareView show:share];
           //share
        }];
        
        
    }];
    [selection3 addObject:shareThisApp];
    
    TableData *logout = [[TableData alloc]initName:@"Logout" headerImage:[UIImage imageNamed:@"my_logout"] clickBlock:^{
//        @strongify(self);
//        [AppDelegate logout];
        
        [AppDelegate shareAppDelegate].account = nil;
        [[NSUserDefaults standardUserDefaults] setAccount:nil];
        [AppDelegate shareAppDelegate].indexVC.selectedIndex = 0;

    }];
    [selection3 addObject:logout];
    [arr addObject:selection3];
    
    self.tableData = [arr copy];
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -- tableview delegate  datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger index = section;
    if(index == 0 && self.vipCard){
        return 1;
    }
    if(self.vipCard){
        index -- ;
    }
    return  [self.tableData[index] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.vipCard){
        return [self.tableData count] +1;
    }
     return  [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 && indexPath.section ==0 &&self.vipCard){
        TSCardCloseCell *cell = [TSCardCloseCell getCell:self.tableView atIndexPath:indexPath withCards:self.vipCard isFirstDefault:YES];
        
        
        
            float width = kDeiveWidth;
            float height = 308.0/640.0*width;
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        [backImage setImage:[UIImage imageNamed:@"card_back"]];
        [cell setBackgroundView:backImage];
//        /
//        cell.vc = self;
        return cell;

    }
    NSInteger index = indexPath.section;
    if(self.vipCard){
        index -- ;
    }
    UITableViewCell *tableviewcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingcell"];
    TableData *data = self.tableData[index][indexPath.row];
    [tableviewcell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [tableviewcell.textLabel setTextColor:COLOR_RGB(30, 30, 30, 1)];
    tableviewcell.textLabel.text =  data.name;
    tableviewcell.imageView.image = data.headerImage;
    return  tableviewcell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0&& indexPath.section ==0 &&self.vipCard){
        float width = kDeiveWidth;
        return  308.0/640.0*width;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0 && indexPath.section ==0 &&self.vipCard){
        return;
        
    }
    NSInteger index = indexPath.section;
    if(self.vipCard){
        index -- ;
    }

    TableData *data = self.tableData[index][indexPath.row];
    if(data.clickBlock){
        data.clickBlock();
    }
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
