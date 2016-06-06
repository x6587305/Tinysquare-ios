//
//  TSCouponVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/24.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSCouponVC.h"
#import <Masonry.h>
#import "Common.h"
#import "UIView+Addition.h"
#import "HttpRequestHelper.h"
#import <MJRefresh/MJRefresh.h>
#import "AppDelegate.h"
#import "TSCoupon.h"
#import "TSCouponCell.h"
#import "TSCouponAddVC.h"
#import "MyCenterTips.h"
#import "TSUtilties.h"
@interface TSCouponVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *tableData;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIButton *leftBtn;
@property(nonatomic,strong) UIButton *rightBtn;
@property(nonatomic,strong) UIView *selectLineView;
@property(nonatomic,assign) int selectType;
@property(nonatomic,assign) int pageNo;
@end

@implementation TSCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
      [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
    [TSUtilties createLeftReturnButtonBlack:self];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.topView.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    //    [TSCardOpenCell registTableViewCell:self.tableView];
//    [TSCardCloseCell registTableViewCell:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [TSCouponCell registTableViewCell:self.tableView];
    
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self headerRefresh];
    }];
    self.tableView.footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerRefresh];
    }];
    
     [self setTopSelected:0];
    self.title = @"Coupon";
    [self createRightBarTitle:@"add" TitleColor:COLOR_SIGLE(52) btnSize:CGSizeMake(32, 32) target:self select:@selector(doAdd)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [self.tableView.header beginRefreshing];
}

-(void)doAdd{
    [self.navigationController pushViewController: [TSCouponAddVC getVC] animated:YES];
}

-(void)headerRefresh{
   
    //   [dic setObject:[NSNumber numberWithInt:(self.pageNumber + 1)] forKey:@"pageNum"];
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_Coupon_LIST postData:@{@"token":[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"",@"status": [NSNumber numberWithInt:self.selectType],@"pageSize":@10,@"pageNum":@1} backSucess:^(NSDictionary *backData) {
        if(backData){
            self.pageNo = [[backData objectForKey:@"pageNum"] intValue];

            NSArray *newsJsonArr = [backData objectForKey:@"result"];
            NSArray *newsArr = [TSCoupon objectArrayWithKeyValuesArray:newsJsonArr];
            self.tableData = [NSMutableArray arrayWithArray:newsArr];
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        }
    }  backFalied:^(id backData) {
        [self.tableView.header endRefreshing];
    }];

}
-(void)footerRefresh{
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_Coupon_LIST postData:@{@"token":[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"",@"status": [NSNumber numberWithInt:self.selectType],@"pageSize":@10,@"pageNum":[NSNumber numberWithInt:(self.pageNo + 1)] } backSucess:^(NSDictionary *backData) {
        if(backData){
            self.pageNo = [[backData objectForKey:@"pageNum"] intValue];
            
            NSArray *newsJsonArr = [backData objectForKey:@"result"];
            NSArray *newsArr = [TSCoupon objectArrayWithKeyValuesArray:newsJsonArr];
            [self.tableData  addObjectsFromArray:newsArr];
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
        }
    }  backFalied:^(id backData) {
        [self.tableView.footer endRefreshing];
    }];
}

-(UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, 40)];
        [self.view addSubview:_topView];
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0, kDeiveWidth/2, 40);
        [_leftBtn setTitle:@"unused" forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(selectLeft) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_leftBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(kDeiveWidth/2, 0, kDeiveWidth/2, 40);
         [_rightBtn setTitle:@"used" forState:UIControlStateNormal];
          [_rightBtn addTarget:self action:@selector(selectRight) forControlEvents:UIControlEventTouchUpInside];
         [_topView addSubview:_rightBtn];
        
        _selectLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40-SINGLE_LINE_ADJUST_OFFSET, 60, SINGLE_LINE_WIDTH)];
        [_selectLineView setBackgroundColor:COLOR_RGB(255, 71, 71, 1)];
        [_topView addSubview:_selectLineView];
        
        UIView *middleLineView = [[UIView alloc]initWithFrame:CGRectMake(kDeiveWidth/2, 13, SINGLE_LINE_WIDTH, 14)];
        middleLineView.backgroundColor = COLOR_SIGLE(204);
        [_topView addSubview:middleLineView];
       
    }
    return _topView;
}
-(void)selectLeft{
    [self setTopSelected:0];
}
-(void)selectRight{
    [self setTopSelected:1];
}
-(void)setTopSelected:(int) index{
    self.selectType = index;
    if(index == 0){
        [self.leftBtn setTitleColor:COLOR_RGB(255, 71, 71, 1) forState:UIControlStateNormal];
         [self.rightBtn setTitleColor:COLOR_SIGLE(104) forState:UIControlStateNormal];
        _selectLineView.left = (kDeiveWidth/2 - 60)/2;
    }else{
        [self.leftBtn setTitleColor:COLOR_SIGLE(104) forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:COLOR_RGB(255, 71, 71, 1) forState:UIControlStateNormal];
        _selectLineView.left = kDeiveWidth/2 +(kDeiveWidth/2 - 60)/2;
    }
    [self.tableView.header beginRefreshing];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSCoupon *coupon = self.tableData[indexPath.row];
    TSCouponCell *cell = [TSCouponCell getCell:tableView atIndexPath:indexPath withCoupon:coupon];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.selectType ==0){
        TSCoupon *cou = self.tableData[indexPath.row];
        [HttpRequestHelper sendHttpRequestBlock:TS_INTER_Coupon_USE postData:@{@"token":[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"",@"id":cou.objId} backSucess:^(NSArray *backData) {
            
            [self.tableData removeObjectAtIndex:indexPath.row];
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [MyCenterTips showTips:@"Use coupon success!"];
        }];

    }
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0 && self.defaultCard != nil) {
//        return ;
//    }
//    TSCardCloseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell update];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}

+(instancetype)getVC{
    return [[TSCouponVC alloc]init];
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
