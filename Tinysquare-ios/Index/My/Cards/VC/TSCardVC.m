//
//  TSCardVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/22.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSCardVC.h"
#import <Masonry.h>
#import "HttpRequestHelper.h"
#import "AppDelegate.h"
#import "TSCard.h"
#import "TSCardCloseCell.h"
#import "Common.h"
#import "TSUtilties.h"
@interface TSCardVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *tableData;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) TSCard *defaultCard;
@end

@implementation TSCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
      [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
        [TSUtilties createLeftReturnButtonBlack:self];
    [self setTitle:@"My Cards"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
//    [TSCardOpenCell registTableViewCell:self.tableView];
    [TSCardCloseCell registTableViewCell:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self refreshNetData];

}

-(NSArray *)tableData{
    NSMutableArray *data = [NSMutableArray arrayWithArray:_tableData];
    [data removeObject:self.defaultCard];
    return [data copy];
}

-(void)refreshNetData{
    
    
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_CARD_LIST postData:@{@"token":[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@""} backSucess:^(NSArray *backData) {
        if(backData){
//            NSArray *newsJsonArr = [backData objectForKey:@"result"];
            NSArray *newsArr = [TSCard objectArrayWithKeyValuesArray:backData];
            self.defaultCard = nil;
            for (TSCard *card in newsArr) {
                if([card.isDefault boolValue]){
                    self.defaultCard = card;
                }
            }
            self.tableData = newsArr;
            [self.tableView reloadData];
        }
    } ];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.defaultCard?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.defaultCard != nil) {
        return 1;
    }
    return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.defaultCard != nil) {
        TSCardCloseCell *cell = [TSCardCloseCell getCell:self.tableView atIndexPath:indexPath withCards:self.defaultCard isFirstDefault:YES];
        cell.vc = self;
        return cell;
    }else{
        TSCard *card = self.tableData[indexPath.row];
        TSCardCloseCell *cell = [TSCardCloseCell getCell:self.tableView atIndexPath:indexPath withCards:card isFirstDefault:NO];
        cell.vc = self;
         return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && self.defaultCard != nil) {
        return ;
    }
    TSCardCloseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell update];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 && self.defaultCard != nil) {
        return 10;
    }
    return 0.1;
}



-(void)setTableDefaultCard:(TSCard *)card{
    self.defaultCard = card;
    for (TSCard *tableCard in self.tableData) {
        if(tableCard.objId.longLongValue == card.objId.longLongValue){
            tableCard.isDefault = @YES;
        }else{
             tableCard.isDefault = @NO;
        }
    }
    [self.tableView reloadData];
    
}


+(instancetype)getVC{
    return [[TSCardVC alloc]init];
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
