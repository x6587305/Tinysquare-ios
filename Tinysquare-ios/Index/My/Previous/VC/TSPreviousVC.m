//
//  TSPreviousVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/3.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSPreviousVC.h"
//#import "TSNewsPreVM.h"
#import "TSNews.h"
#import <Masonry.h>
#import "TSPreviousCell.h"
#import "HttpRequestHelper.h"
#import "TSShop.h"
#import <MJRefresh/MJRefresh.h>
#import "Common.h"
#import "TSUtilties.h"
@interface TSPreviousVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) TSShop *shop;
@property(nonatomic,assign) int pageNumber;
@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic,strong) NSArray<TSNews *> *tableData;

@end

@implementation TSPreviousVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TSUtilties createLeftReturnButtonBlack:self];
    [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];

    self.title = @"Previous Post";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top);
    }];

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [TSPreviousCell registTableViewCell:self.tableView];
//    [TSDetailCell registTableViewCell:self.tableView];
    self.tableView.estimatedRowHeight = 120.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self headerRefresh];
    
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self headerRefresh];
    }];
    self.tableView.footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerRefresh];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)refreshNetData:(NSDictionary *)dic isHeader:(BOOL) isHeader{

    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_SHOP_NEWS postData:dic backSucess:^(NSDictionary *backData) {
        if(backData){
            NSArray *newsJsonArr = [backData objectForKey:@"result"];
            self.pageNumber = [[backData objectForKey:@"pageNum"] intValue];
            NSArray *newsArr = [TSNews objectArrayWithKeyValuesArray:newsJsonArr];
            if(isHeader){
                 self.tableData = newsArr;
            }else{
                self.tableData = [ self.tableData arrayByAddingObjectsFromArray:newsArr];
            }
           
            [self.tableView reloadData];
        }
        if(isHeader){
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
    } backFalied:^(id backData) {
        if(isHeader){
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
    }];

}

-(void) headerRefresh{
    [self refreshNetData:@{@"pageSize":@10,@"pageNum":@1,@"shopId":self.shop.objId} isHeader:YES];
}
-(void)footerRefresh{
    [self refreshNetData:@{@"pageSize":@10,@"pageNum":@(self.pageNumber + 1),@"shopId":self.shop.objId}  isHeader:NO];
}


#pragma mark  -- tableview delegate  datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.tableData count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSNews *news = self.tableData[indexPath.row];
    TSPreviousCell *cell = [TSPreviousCell getAdeCell:tableView atIndexPath:indexPath withNews:news andShop:self.shop];
                          //getAdeCell:tableView atIndexPath:indexPath withNews:news];
    return  cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//      TSNews *news = self.tableData[indexPath.row];
//    return newVM.hegith;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+(instancetype)getVC:(TSShop *)shop{
    TSPreviousVC *vc = [[TSPreviousVC alloc]init];
    vc.shop = shop;
    return vc;
}

@end
