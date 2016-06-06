//
//  TSHomeController.m
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/8.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSHomeController.h"
#import <MJRefresh.h>
#import <CoreLocation/CoreLocation.h>
#import "HttpRequestHelper.h"
#import "AppDelegate.h"
#import "TSNewVM.h"
#import "TSNewsCell.h"
#import "TSShopDetailVC.h"
//#import "MJRefresh.h"
//#import "MJDIYHeader.h"
#import <MJRefresh/MJRefresh.h>
#import "Common.h"
#import "TSUtilties.h"
@interface TSHomeController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) CLLocationManager *loctionManager;
@property(nonatomic,strong) CLLocation *location;
@property(nonatomic,assign) int pageNumber;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray<TSNewVM *> *tableData;
@property(nonatomic,assign) BOOL isStored;
@end

@implementation TSHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.loctionManager = [[CLLocationManager alloc] init];
    [self.loctionManager requestWhenInUseAuthorization];
    self.loctionManager.delegate = self;
    self.loctionManager.distanceFilter = kCLDistanceFilterNone;
    self.loctionManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.loctionManager startUpdatingLocation];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    UIView *headvew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
//    headvew.backgroundColor = [UIColor redColor];
//    self.tableView.tableHeaderView = headvew;
//    self.tableView.tableFooterView = [[UIView alloc]init];
    [TSNewsCell registTableViewCell:self.tableView];
    
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
    if(self.isStored){
        self.title = @"My Favourites";
        [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
        [TSUtilties createLeftReturnButtonBlack:self];
        
    }else{
        self.title = @"Home";
        
    }

    [super viewWillAppear:animated];
//    NSLog(@"%@",self.location);
//    [self.loctionManager requestLocation];
//    [self headerRefresh];
}

-(void)footerRefresh{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [NSThread sleepForTimeInterval:1];
            if(_location){
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:[AppDelegate shareAppDelegate].accountWithNotLogout.token?:@"" forKey:@"token"];
                NSNumber *lng = [NSNumber numberWithDouble:self.location.coordinate.longitude];
                NSNumber *lat = [NSNumber numberWithDouble:self.location.coordinate.latitude];
                
                //lng
                [dic setObject:lng?:@"" forKey:@"lng"];
                [dic setObject:lat?:@"" forKey:@"lat"];
                [dic setObject:[NSNumber numberWithInt:(self.pageNumber + 1)] forKey:@"pageNum"];
                [dic setObject:@10 forKey:@"pageSize"];
                NSString *postUrl;
                if (self.isStored) {
                    postUrl = TS_INTER_STORELIST;
                    [dic setObject:[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"" forKey:@"token"];
                }else{
                    postUrl = TS_INTER_HOMELIST;
                }
                
                [HttpRequestHelper sendHttpRequestBlock:postUrl postData:dic backSucess:^(NSDictionary *backData) {
                    if(backData){
                        self.pageNumber = [[backData objectForKey:@"pageNum"] intValue];
                        NSArray *newsJsonArr = [backData objectForKey:@"result"];
                        NSArray *newsArr = [TSNews objectArrayWithKeyValuesArray:newsJsonArr];
                        [self.tableData  addObjectsFromArray:  [TSNewVM arrayFromNewsArr:[NSMutableArray arrayWithArray:newsArr]]] ;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                            [self.tableView.footer endRefreshing];
                        });
                        
                    }
                } backFalied:^(id backData) {
                    [self.tableView.footer endRefreshing];
                }];
            }else{
                NSLog(@"获取不到位置 请稍后再试");
                 [self.tableView.footer endRefreshing];
            }
        }
    });

}

-(void) headerRefresh{
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @autoreleasepool {
//            [NSThread sleepForTimeInterval:1];
            if(_location){
                NSLog(@"%@",_location);
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:[AppDelegate shareAppDelegate].accountWithNotLogout.token?:@"" forKey:@"token"];
                NSNumber *lng = [NSNumber numberWithDouble:self.location.coordinate.longitude];
                NSNumber *lat = [NSNumber numberWithDouble:self.location.coordinate.latitude];
                //lng
                [dic setObject:lng?:@"" forKey:@"lng"];
                [dic setObject:lat?:@"" forKey:@"lat"];
                [dic setObject:@1 forKey:@"pageNum"];
                [dic setObject:@10 forKey:@"pageSize"];
                NSString *postUrl;
                if (self.isStored) {
                    postUrl = TS_INTER_STORELIST;
                    [dic setObject:[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"" forKey:@"token"];
                }else{
                     postUrl = TS_INTER_HOMELIST;
                }
                
                [HttpRequestHelper sendHttpRequestBlock:postUrl postData:dic backSucess:^(NSDictionary *backData) {
                    if(backData){
                        self.pageNumber = [[backData objectForKey:@"pageNum"] intValue];
                        NSArray *newsJsonArr = [backData objectForKey:@"result"];
                        NSArray *newsArr = [TSNews objectArrayWithKeyValuesArray:newsJsonArr];
                        self.tableData =  [TSNewVM arrayFromNewsArr:[NSMutableArray arrayWithArray:newsArr]] ;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                            [self.tableView.header endRefreshing];
                        });
                        
                    }
                } backFalied:^(id backData) {
                    [self.tableView.header endRefreshing];
                }];
            }else{
                NSLog(@"获取不到位置 请稍后再试");
                [self.tableView.header endRefreshing];
            }
//        }
//    });

}
#pragma mark  -- tableview delegate  datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.tableData count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSNewVM *newVM = self.tableData[indexPath.row];
    TSNewsCell *cell = [TSNewsCell getAdeCell:tableView atIndexPath:indexPath withNews:newVM];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     TSNewVM *newVM = self.tableData[indexPath.row];
    return newVM.hegith;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TSNewVM *newVM = self.tableData[indexPath.row];
    UIViewController *vc = [TSShopDetailVC getViewByShopId:newVM.news.shopId] ;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES] ;
    
}



#pragma mark -- location delegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(nonnull CLLocation *)oldLocation{
//    NSLog(@"latitude: %f --- longitude: %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    BOOL needRefresh = (self.location == nil);
    self.location = [locations lastObject];
    if (needRefresh) {
        [self performSelector:@selector(headerRefresh) withObject:nil afterDelay:0.5];
//        self performSelectorOnMainThread:@selector(headerRefresh) withObject:nil waitUntilDone:<#(BOOL)#>
//        [self headerRefresh];
    }
//    NSLog(@"latitude: %f --- longitude: %f",[locations lastObject].coordinate.latitude,[locations lastObject].coordinate.longitude);

}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(instancetype) getStoreVC{
    UIStoryboard *sb  = [UIStoryboard storyboardWithName:@"Index" bundle:nil];
    TSHomeController *vc = [sb instantiateViewControllerWithIdentifier:@"TSHomeController"];
    vc.isStored = YES;
    return vc;
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
