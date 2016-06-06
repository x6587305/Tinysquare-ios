//
//  TSShopDetailVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/28.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSEditShopDetailVC.h"
#import "TSShop.h"
#import "TSHeaderCell.h"
#import "TSTextCell.h"
#import "TSImageCell.h"
#import "TSSigleEditVC.h"
#import "TSTextEditVC.h"
#import "Common.h"
#import "AppDelegate.h"
#import "HttpRequestHelper.h"
#import "MyImagePickerViewController.h"
#import "TSUtilties.h"
#import <Photos/Photos.h>
#import "TSUtilties.h"
#import "TSImageEditVC.h"
#import "TSHUDView.h"

@interface TSEditShopDetailVC ()<UITableViewDelegate,UITableViewDataSource,ImagePickerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,weak) TSImageCell *imageCell;
@property(nonatomic,strong)TSShop *shop;
@property(nonatomic,strong) NSMutableArray *lastArr;
@property(nonatomic,strong) NSMutableArray *thisArr;
@end

@implementation TSEditShopDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TSUtilties createLeftReturnButtonBlack:self];
    [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];

    self.title = @"My Profile";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self createRightBarTitle:@"comfirm" TitleColor:COLOR_SIGLE(52) btnSize:CGSizeMake(100, 30) target:self select:@selector(doSubmit)];
    self.tableView.bounces = NO;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


-(void)doSubmit{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"" forKey:@"token" ];
    //11
    
    [dic setObject: [self.imageCell.imageUrls componentsJoinedByString:@","] forKey:@"imgs"];
    
    //    [self.delegate doSubmit:self.sigleText.text];
    [HttpRequestHelper sendHttpRequestBlock:TS_INTER_SHOP_UPDATEIMAGE postData:dic backSucess:^(id backData) {
        [self.shop setImageUrls:self.imageCell.imageUrls];
        [self.navigationController popViewControllerAnimated:YES];
    } backFalied:^(id backData) {
        
    }];

}

-(void) doImgPickerSelected:(UIButton *)sender andData:(ImageCollectionData *)data{

    


}
-(void) doImgPickerCancel{
    [self.navigationController popToViewController:self animated:YES];
    [TSHUDView hide];

}

-(void) doImgPickerFinish{
    
    [TSHUDView show];
    
    PHFetchResult *asserts =[PHAsset fetchAssetsWithLocalIdentifiers:_thisArr options:nil];
    if(!([asserts count] >0)){
         [TSHUDView hide];
        return;
    }
    PHAsset *phAsset =asserts[0];
    if(phAsset!=nil){
        @weakify(self);
        PHImageRequestOptions *op =[[PHImageRequestOptions alloc]init];
        op.networkAccessAllowed = YES;
        op.resizeMode =PHImageRequestOptionsResizeModeExact;//图片按照尺寸显示，不加此属性，设置尺寸无效
        op.deliveryMode =PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(800, 800) contentMode:PHImageContentModeDefault options:op resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [TSUtilties uploadImage:result success:^(UIImage *image, NSString *imageUrl){
                @strongify(self);
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"" forKey:@"token"];
                [dic setObject: imageUrl forKey:@"avator"  ];
                [HttpRequestHelper sendHttpRequestBlock:TS_INTER_SHOP_UpdateAvator postData:dic backSucess:^(id backData) {
                    self.shop.avator = imageUrl;
                    [self.navigationController popToViewController:self animated:YES];
                    [self.tableView reloadData];
                    [TSHUDView hide];
                    
                } backFalied:^(id backData) {
                    [TSHUDView hide];
                }];
                
                
                
                
            } fail:^{
                
                [self.navigationController popViewControllerAnimated:YES];
                [TSHUDView hide];
                
                
            }];
            
        }];
        
    }
    
}
-(NSMutableArray *) getLastImages{
    if(!_lastArr){
        _lastArr = [NSMutableArray array];
    }
    return _lastArr;
}
-(NSMutableArray *) getThisImages{
    if(!_thisArr){
        _thisArr = [NSMutableArray array];
    }
    return _thisArr;

}
#pragma mark -- tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 5;
    }
    return 1;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                MyImagePickerViewController *myImagePicAlbumViewController = [MyImagePickerViewController getImagePickerViewController];
                myImagePicAlbumViewController.isSingle = YES;
                myImagePicAlbumViewController.hidesBottomBarWhenPushed = YES;
                myImagePicAlbumViewController.imagePickerDelegate = self;
                [self.navigationController pushViewController:myImagePicAlbumViewController animated:NO];
                [self.navigationController.view.layer addAnimation:[TSUtilties getPushAnimationBySubType:kCATransitionFromTop] forKey:nil];
            }
                
                break;
            case 1:{
              
            }
                
            case 2:{
         
            }
                
            case 3:{
                TSSigleEditVC *vc =  [TSSigleEditVC getVcShop:self.shop atType:(int)indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
            case 4:{
                TSTextEditVC *vc = [TSTextEditVC getVcShop:self.shop];
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
                
//            case 5:{
//               
//            }
                
//                break;
                
            default:
                
                break;
        }
    }else{
        TSImageEditVC *vc = [TSImageEditVC getVcShop:self.shop];
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                return [TSHeaderCell getCell:tableView atIndexPath:indexPath withHeaderUrl:self.shop.avator];
            }
                
                break;
            case 1:{
                TSTextCell *cell = [TSTextCell getCell:tableView atIndexPath:indexPath leftText:@"Name" rightText:self.shop.name];
                return cell;
            }
                
                break;
            case 2:{
                TSTextCell *cell = [TSTextCell getCell:tableView atIndexPath:indexPath leftText:@"Tel" rightText:self.shop.tel];
                return cell;
            }
                
                break;
            case 3:{
                TSTextCell *cell = [TSTextCell getCell:tableView atIndexPath:indexPath leftText:@"Address" rightText:self.shop.address];
                return cell;
            }
                
                break;
            case 4:{
                TSTextCell *cell = [TSTextCell getCell:tableView atIndexPath:indexPath leftText:@"Brief" rightText:self.shop.brief];
                return cell;
            }
                
                break;
                
            default:
                return [[UITableViewCell alloc]init];
                break;
        }
    }else{
        self.imageCell = [TSImageCell getCell:tableView atIndexPath:indexPath andShop:self.shop];
        return self.imageCell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                return 70;
            }
                
                break;
            case 1:{
               
            }
                
          
            case 2:{
               
            }
                
            case 3:{
               
               
            }
                
              
            case 4:{
                return 44;
            }
                
                break;
                
            default:
                return 44;
                break;
        }
    }else{
        return 30.0 + ((kDeiveWidth -20 -12) /3 +6)*2;

    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

+(instancetype) getVC:(TSShop *)shop{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"ShopDetail" bundle:nil];
    TSEditShopDetailVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"TSEditShopDetailVC"];
    vc.shop = shop;
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
