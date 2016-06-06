//
//  TSShopDetailVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/10.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSShopDetailVC.h"
#import "Common.h"
#import <Masonry.h>
#import "HttpRequestHelper.h"
#import "TSShop.h"
#import "TSNews.h"
#import "TSDetailCell.h"
#import "TSDetailImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TSImage.h"
#import <MJRefresh/MJRefresh.h>
#import "TSBigImageView.h"
@interface TSShopDetailVC ()<UITableViewDelegate,UITableViewDataSource,TSBigImageDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSNumber *shopId;
@property(nonatomic,strong) TSShop *shop;
@property(nonatomic,strong) UIImageView *headerView;
@property(nonatomic,strong) UILabel *headerLabel1;
@property(nonatomic,strong) UILabel *headerLabel2;
@property(nonatomic,assign) int pageNumber;

@property(nonatomic,strong) NSArray<TSNews *> *tableData;
@end

@implementation TSShopDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [TSDetailCell registTableViewCell:self.tableView];
    [TSDetailImageCell registTableViewCell:self.tableView];
    self.tableView.estimatedRowHeight = 120.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self refreshNetData];
    
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self headerRefresh];
    }];
    self.tableView.footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerRefresh];
    }];
    
    // Do any additional setup after loading the view.
}
-(void)refreshNetData{
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_SHOPDETAIL postData:@{@"id":self.shopId} backSucess:^(NSDictionary *backData) {
        self.shop = [TSShop objectWithDic:backData];
        [self refreshHeader];
    }];
    //
    [self headerRefresh];
    
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
    [self refreshNetData:@{@"pageSize":@10,@"pageNum":@1,@"shopId":self.shopId}  isHeader:YES];
}
-(void)footerRefresh{
    [self refreshNetData:@{@"pageSize":@10,@"pageNum":@(self.pageNumber + 1),@"shopId":self.shopId}   isHeader:NO];
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)initview{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, 127)];//147
    topView.backgroundColor = MAIN_RED;
    [self.view addSubview:topView];
    
    self.headerView = [[UIImageView alloc]init];
    self.headerView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerView.layer.masksToBounds = YES;
    self.headerView.layer.cornerRadius = 5;
    [topView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(topView.mas_top).offset(42);
    }];
    
    self.headerLabel1 = [[UILabel alloc]init];
    [self.headerLabel1 setFont:[UIFont systemFontOfSize:15]];
    [self.headerLabel1 setTextColor:[UIColor whiteColor]];
    [topView addSubview:self.headerLabel1];
    [self.headerLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@15);
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(self.headerView.mas_bottom).offset(6);
    }];
    
    self.headerLabel2 = [[UILabel alloc]init];
    [self.headerLabel2 setFont:[UIFont systemFontOfSize:12]];
    [topView addSubview:self.headerLabel2];
    [self.headerLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(self.headerLabel1.mas_bottom).offset(4);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.backgroundColor = [UIColor blueColor];
    backBtn.frame = CGRectMake(10, 31, 19, 25);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [topView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    
    
}
-(UIView *) getTableViewHeaderView{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    CGFloat top = 10;
    if([self.shop.imgs count]>0){
         float width = (kDeiveWidth - 30 - 40) /5;
        for (int i = 0;i< [self.shop.imgs count];i++) {
           
            //TSImage *image in self.shop.imgs
            TSImage *image = self.shop.imgs[i];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15 + (width + 10)*i, top, width, width)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage: [UIImage imageNamed:@"img_photo_default"]];
            [headerView addSubview:imageView];
            
            
            UIGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookBig:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:ges];
            imageView.tag = 1000 + i;
            

        }
        top += (width + 10);
    }
    
    {
        UIImageView *loactionImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, top, 18, 18)];
        [loactionImage setImage:[UIImage imageNamed:@"location"]];
        [headerView addSubview:loactionImage];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(36, top+3, SINGLE_LINE_WIDTH, 12)];
        lineView.backgroundColor = COLOR_SIGLE(219);
        [headerView addSubview:lineView];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, top, kDeiveWidth-45-15, 18)];
        [contentLabel setFont:[UIFont systemFontOfSize:13]];
        [contentLabel setTextColor:COLOR_SIGLE(142)];
        [headerView addSubview:contentLabel];
        [contentLabel setText:self.shop.address];
        
        top +=26;
    }
    
    {
        UIImageView *loactionImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, top, 18, 18)];
        [loactionImage setImage:[UIImage imageNamed:@"photo"]];
        [headerView addSubview:loactionImage];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(36, top+3, SINGLE_LINE_WIDTH, 12)];
        lineView.backgroundColor = COLOR_SIGLE(219);
        [headerView addSubview:lineView];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, top, kDeiveWidth-45-15, 18)];
        [contentLabel setFont:[UIFont systemFontOfSize:13]];
        [contentLabel setTextColor:COLOR_SIGLE(142)];
        [headerView addSubview:contentLabel];
        [contentLabel setText:self.shop.tel];
        
        top +=26;
    }
    
    CGRect rect = [self.shop.brief boundingRectWithSize:CGSizeMake(kDeiveWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}  context:nil];
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, top, rect.size.width, rect.size.height)];
    contentLabel.numberOfLines = 0;
    [contentLabel setFont:[UIFont systemFontOfSize:14]];
    [contentLabel setTextColor:COLOR_SIGLE(142)];
    [contentLabel setText:self.shop.brief];
    [headerView addSubview:contentLabel];
    
    headerView.frame = CGRectMake(0, 0, kDeiveWidth, CGRectGetMaxY(contentLabel.frame)+10);
    
    return headerView;
}

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshHeader{
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.shop.avator] placeholderImage: [UIImage imageNamed:@"img_touxiang_default"]];
    [self.headerLabel1 setText:self.shop.name];
    
    self.tableView.tableHeaderView = [self getTableViewHeaderView];
    [self.tableView reloadData];
}



#pragma mark  -- tableview delegate  datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.tableData count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSNews *news = self.tableData[indexPath.row];
    BOOL islast = ([news.imgs count] == indexPath.row +1);
    if([news.imgs count]>0){
       
         TSDetailImageCell *cell = [TSDetailImageCell  getAdeCell:tableView atIndexPath:indexPath withNews:news andShop:self.shop isLast:islast] ;
        return  cell;
    }
    TSDetailCell *cell = [TSDetailCell  getAdeCell:tableView atIndexPath:indexPath withNews:news andShop:self.shop isLast:islast] ;
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

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//      TSNews *news = self.tableData[indexPath.row];
////    [self.navigationController pushViewController:[TSShopDetailVC getViewByShopId:newVM.news.shopId] animated:YES] ;
//    
//}


-(void)lookBig:(UIGestureRecognizer *)ges{
    NSInteger index = ges.view.tag - 1000;
    [TSBigImageView showBigDelegate:self andFirstIndex:index];
}

#pragma mark --- tsbigimage delegate
-(BOOL) hadDelete{
    return NO;
}
-(int) getImageCount{
    return (int)[self.shop.imgs count];
}
-(NSString *) getImageUrlAtIndex:(int)index{
    TSImage *image = self.shop.imgs[index];
    return image.url;
}
-(UIImage *) getImageAtIndex:(int)index{
    return nil;
}
-(BOOL) canDelete:(int)index{
    return NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(instancetype)getViewByShopId:(NSNumber *)shopId{
    TSShopDetailVC *vc = [[TSShopDetailVC alloc]init];
    vc.shopId = shopId;
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
