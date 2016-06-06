////
////  TSBigImageVC.m
////  Tinysquare-ios
////
////  Created by xiezhaojun on 16/4/28.
////  Copyright © 2016年 xiezhaojun. All rights reserved.
////
//
//#import "TSBigImageVC.h"
//#import "TSBigImageCell.h"
//#import "Common.h"
//#import "TSUtilties.h"
//@interface TSBigImageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
////@property(nonatomic,strong) NSArray<NSString *> *imageStrArr;
//@property(nonatomic,weak) id<TSBigImageDelegate > delegate;
//@property(nonatomic,assign) int index;
//@end
//static NSString *collectionCell = @"collectionCell";
//@implementation TSBigImageVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    
//    [self setNoLineWithAllColor:COLOR_RGB(54, 54, 54, 1) titleColor:[UIColor whiteColor]];
//    [TSUtilties createLeftReturnButton:self];
//    
//    
//    
//  
//}
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];

//    [self refresh];
//}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//}
//
//
//
//+(instancetype) getVCDelete:(id<TSBigImageDelegate>) delegete andFirstIndex:(int) index{
//    UIStoryboard *storboard = [UIStoryboard storyboardWithName:@"BigImage" bundle:nil];
//    TSBigImageVC *vc = [storboard instantiateViewControllerWithIdentifier:@"TSBigImageVC"];
//    vc.index = index;
//    vc.delegate = delegete;
//    return vc;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
