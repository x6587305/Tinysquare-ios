//
//  TSMessageVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/22.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSMessageVC.h"
#import "HttpRequestHelper.h"
#import "AppDelegate.h"
#import "TSMessage.h"
#import <Masonry.h>
#import "Common.h"
#import "TSMessageDetailVC.h"
#import "TSUtilties.h"
@interface TSMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *tableData;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *noDataView;
@end

@implementation TSMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
      [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
    [TSUtilties createLeftReturnButtonBlack:self];
    self.title = @"Message";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
         make.top.equalTo(self.view.mas_top);
         make.right.equalTo(self.view.mas_right);
         make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    [self refreshNetData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(UIView *)noDataView{
    if(!_noDataView){
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, kDeiveHeight-64)];
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]];
        imageview.center = CGPointMake(_noDataView.center.x, _noDataView.center.y-50);
        [_noDataView addSubview:imageview];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, 20)];
        [label setTextColor:COLOR_SIGLE(51)];
        [label setFont:[UIFont systemFontOfSize:18]];
        [label setText:@"You have no new replies"];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.center = CGPointMake(_noDataView.center.x, CGRectGetMaxY(imageview.frame) + 25);
        [_noDataView addSubview:label];
    }
    return _noDataView;
}

-(void) showNoDataView{
    [self.view addSubview:self.noDataView];
}

-(void) hideNoDataView{
    [self.noDataView removeFromSuperview];
}

-(void)refreshNetData{
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_MESSAGES postData:@{@"pageSize":@10,@"pageNum":@1,@"token":[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@""} backSucess:^(NSDictionary *backData) {
        if(backData){
            NSArray *newsJsonArr = [backData objectForKey:@"result"];
            NSArray *newsArr = [TSMessage objectArrayWithKeyValuesArray:newsJsonArr];
            if([newsArr count]>0){
                self.tableData = newsArr;
                [self.tableView reloadData];
            }else{
                [self showNoDataView];
            }
           
        }
    } backFalied:^(id backData) {
        if(!([self.tableData count]>0)){
            [self showNoDataView];
        }
    } ];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" ];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
        cell.imageView.image = [UIImage imageNamed:@"message"];
       
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"message_red"]];
        imageView.center =CGPointMake( 39-4, 4);
        [cell.imageView addSubview:imageView];
        imageView.tag = 123;
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.textLabel setTextColor:COLOR_SIGLE(51)];
    TSMessage *message = self.tableData[indexPath.row];
    [cell.textLabel setText:message.title];
    
    if([message.isRead boolValue]){
        [cell.imageView viewWithTag:123].hidden = YES;
    }else{
        [cell.imageView viewWithTag:123].hidden = NO;

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TSMessage *message = self.tableData[indexPath.row];
    TSMessageDetailVC *vc = [TSMessageDetailVC getVC:message];
    [self.navigationController pushViewController:vc animated:YES];
}

+(instancetype)getVC{
    return [[TSMessageVC alloc]init];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
