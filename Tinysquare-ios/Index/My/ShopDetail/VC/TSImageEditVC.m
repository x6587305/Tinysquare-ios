//
//  TSImageEditVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/30.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSImageEditVC.h"
#import "Common.h"
#import <Masonry.h>
#import "TSShop.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyImagePickerViewController.h"
#import "TSUtilties.h"
#import <Photos/Photos.h>
#import "MyCenterTips.h"
#import "HttpRequestHelper.h"
#import "UIView+Addition.h"
#import "ImageData.h"
#import "TSHUDView.h"
#import "AppDelegate.h"
#import "TSImage.h"
@interface TSImageEditVC ()<ImagePickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) TSShop *shop;
@property(nonatomic,strong) NSMutableArray *lastArr;
@property(nonatomic,strong) NSMutableArray *thisArr;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) NSMutableArray *imageViews;
@property(nonatomic,strong) NSMutableArray<UIButton *> *imageDeleteBtnArr;
//@property(nonatomic,strong) NSMutableArray *images;
@property(nonatomic,strong) NSMutableArray<ImageData *> *imageDatas;
@property(nonatomic,assign)PHAuthorizationStatus photoStatus;

@end

@implementation TSImageEditVC
+(instancetype)getVcShop:(TSShop *)shop{
   TSImageEditVC *vc = [[TSImageEditVC alloc]init];
    vc.shop = shop;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [super viewDidLoad];
    [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
    [TSUtilties createLeftReturnButtonBlack:self];
    [self createRightBarTitle:@"confirm" TitleColor:COLOR_SIGLE(52) btnSize:CGSizeMake(100, 30) target:self select:@selector(submit)];
    
    self.title = @"Picture Editor";
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        self.photoStatus = status;
    } ];
    
    
//    float top = 220;
//    float width = (kDeiveWidth - 55 )/4;
    
    self.imageViews = [NSMutableArray array];
    self.imageDeleteBtnArr = @[].mutableCopy;
    //    self.images = [NSMutableArray array];
    self.imageDatas = [NSMutableArray array];
    
    float top = 30.0;
    float left = 10.0;
    float width = (kDeiveWidth -20 -12) /3;
    for (int i = 0; i<5; i++) {
        float row = i/3;
        float coloum = i %3;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(left +(width +6)*coloum , top +(width +6)*row, width, width)];
        [self.view addSubview:imageView];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.imageViews addObject:imageView];
    }
    
    for (int i = 0; i<5; i++) {
        UIImageView *imageView = self.imageViews[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width-10, -10, 20, 20);
        //        button.backgroundColor = [UIColor redColor];
        [button setBackgroundImage:[UIImage imageNamed:@"delete_btn"] forState:UIControlStateNormal];
        button.tag = 1000 + i;
        button.center = CGPointMake(CGRectGetMaxX(imageView.frame), CGRectGetMinY(imageView.frame));
        [button addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [self.imageDeleteBtnArr addObject:button];
        
    }

//    for (int i = 0; i<5; i++) {
//        UIImageView *imageView = [[UIImageView alloc]init];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.layer.masksToBounds = YES;
//        float imagetop = i/4*(width +10) + top;
//        float left = 10 + i%4*(width +10);
//        imageView.frame= CGRectMake(left, imagetop, width, width);
//        [self.view addSubview:imageView];
//        [self.imageViews addObject:imageView];
//        imageView.hidden = YES;
//        imageView.tag = 1000 + i;
//        UIGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookBig:)];
//        imageView.userInteractionEnabled = YES;
//        [imageView addGestureRecognizer:ges];
//        //UITapGestureRecognizer
//    }
    
    
    
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeiveHeight-40 -64, kDeiveWidth, 40)];
    self.bottomView.backgroundColor = COLOR_RGB(242, 242, 242, 1);
    [self.view addSubview:self.bottomView];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    //
    [self.bottomView addSubview:leftButton];
    UIView *lineView = [[UIView alloc]init];
    [lineView setBackgroundColor:COLOR_SIGLE(201)];
    [self.bottomView addSubview:lineView];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"imagePick"] forState:UIControlStateNormal];
    [self.bottomView addSubview:rightButton];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@13);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.width.equalTo(@SINGLE_LINE_WIDTH);
    }];
    
    UIView *lineView2 = [[UIView alloc]init];
    [lineView2 setBackgroundColor:COLOR_SIGLE(201)];
    [self.bottomView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@SINGLE_LINE_WIDTH);
        make.left.equalTo(self.bottomView.mas_left);
        make.right.equalTo(self.bottomView.mas_right);
        make.top.equalTo(self.bottomView.mas_top);
    }];
    
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left);
        make.top.equalTo(self.bottomView.mas_top);
        make.right.equalTo(lineView.mas_left);
        make.bottom.equalTo(self.bottomView.mas_bottom);
    }];
    [leftButton addTarget:self action:@selector(doPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right);
        make.top.equalTo(self.bottomView.mas_top);
        make.right.equalTo(self.bottomView.mas_right) ;
        make.bottom.equalTo(self.bottomView.mas_bottom);
    }];
    [rightButton addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if(self.shop){
        for (TSImage *image in self.shop.imgs) {
            ImageData *data = [[ImageData alloc]init];
            data.url = image.url;
            [self.imageDatas addObject:data];
        }
    }
    [self refreshImageView];

}

-(void) doRealSubmit{
    NSString *url;
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (ImageData *data in self.imageDatas) {
        if(data.url){
            [imageUrls addObject:data.url?:@""];
        }
        
    }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"" forKey:@"token" ];
        //11
    
        [dic setObject: [imageUrls componentsJoinedByString:@","] forKey:@"imgs"];
    
    @weakify(self);
        [HttpRequestHelper sendHttpRequestBlock:TS_INTER_SHOP_UPDATEIMAGE postData:dic backSucess:^(id backData) {
            @strongify(self);
            [self.shop setImageUrls:imageUrls];
             [MyCenterTips showTips:@"publish success!"];
            [TSHUDView hide];
            [self.navigationController popViewControllerAnimated:YES];
        } backFalied:^(id backData) {
            
        }];
    
    
}

-(void)submit{
    [TSHUDView show];

    __block unsigned long needUploadCount = [self.imageDatas count];
    @weakify(self);
    for (ImageData *data in self.imageDatas) {
        if(data.image){
            [TSUtilties uploadImage:data.image success:^(UIImage *viewImage,NSString *imageUrl){
                @strongify(self);
                data.image = nil;
                data.url = imageUrl;
                needUploadCount --;
                if(needUploadCount == 0){
                    [self doRealSubmit];
                }
                
            } fail:^{
                @strongify(self);
                needUploadCount --;
                if(needUploadCount == 0){
                    [self doRealSubmit];
                }
                
            }];
        }else{
            needUploadCount--;
            if(needUploadCount == 0){
                [self doRealSubmit];
            }
            
        }
    }
}


//-(void)doSubmit{

//    
//}

- (void)doPhoto:(id)sender {
    if([self.imageDatas count] >= 5 ){
        
        [MyCenterTips showTips:@"只能上传5张照片"];
        
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
    //------
}

- (void)addImage:(id)sender {
    MyImagePickerViewController *myImagePicAlbumViewController = [MyImagePickerViewController getImagePickerViewController];
    myImagePicAlbumViewController.hidesBottomBarWhenPushed = YES;
    myImagePicAlbumViewController.imagePickerDelegate = self;
    [self.navigationController pushViewController:myImagePicAlbumViewController animated:NO];
    [self.navigationController.view.layer addAnimation:[TSUtilties getPushAnimationBySubType:kCATransitionFromTop] forKey:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    @weakify(self);
    ImageData *data = [[ImageData alloc]init];
    data.image = image;
    [self.imageDatas addObject:data];
    [self addPicFinish:YES];
}

#pragma mark --- image pick delegate
-(void) doImgPickerSelected:(UIButton *)sender andData:(ImageCollectionData *)data{
    if([data cannotSelected:self.lastArr]){
        return;
    }
    if([data toggleSelected:self.thisArr]){
        int count = (int)self.thisArr.count;
        if([self.imageDatas count] + count > 5 ){
            [data toggleSelected:self.thisArr];
            
            [MyCenterTips showTips:@"只能上传5张照片"];
            
            return;
        }
        
        [sender setBackgroundImage:[UIImage imageNamed:@"img_select"] forState:UIControlStateNormal ];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"img_unselect"] forState:UIControlStateNormal ];
    }
}


#pragma mark --- image delegate

-(void) doImgPickerFinish{
    [TSHUDView show];
    PHFetchResult *asserts =[PHAsset fetchAssetsWithLocalIdentifiers:_thisArr options:nil];
    __block unsigned long needUploadCount = [asserts count];
    for (int i=0;i<[asserts count];i++) {
        PHAsset *phAsset =asserts[i];
        if(phAsset!=nil){
            @weakify(self);
            PHImageRequestOptions *op =[[PHImageRequestOptions alloc]init];
            op.networkAccessAllowed = YES;
            op.resizeMode =PHImageRequestOptionsResizeModeExact;//图片按照尺寸显示，不加此属性，设置尺寸无效
            op.deliveryMode =PHImageRequestOptionsDeliveryModeHighQualityFormat;
            [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(800, 800) contentMode:PHImageContentModeDefault options:op resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                ImageData *data = [[ImageData alloc]init];
                data.image = result;
                [self.imageDatas addObject:data];
                needUploadCount --;
                if(needUploadCount == 0){
                    [self addPicFinish:NO];
                }
            }];
            
        }else{
            needUploadCount --;
            if(needUploadCount == 0){
                [self addPicFinish:NO];
            }
        }
    }
    
    if(needUploadCount == 0){
        [self addPicFinish:NO];
    }
    NSLog(@"全部完成了");
}

-(void) refreshImageView{
    for(int i =0 ; i<5;i++){
        UIImageView *imageView =  self.imageViews[i];
        UIButton *deleteBtn = self.imageDeleteBtnArr[i];
        if([self.imageDatas count]>i){
            imageView.hidden = NO;
             deleteBtn.hidden = NO;
            ImageData *data = self.imageDatas[i];
            if(data.image){
                imageView.image = data.image;
            }else{
                [imageView sd_setImageWithURL:[NSURL URLWithString:data.url] placeholderImage: [UIImage imageNamed:@"img_photo_default"]];
            }
            imageView.contentMode = UIViewContentModeScaleAspectFill;
        }else{
            imageView.hidden = YES;
              deleteBtn.hidden = YES;
        }
    }

}

-(void) addPicFinish:(BOOL) ifFromCar{
    [_thisArr removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshImageView];
        
        if(ifFromCar){
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else{
            [self.navigationController popToViewController:self animated:YES];
            //popViewControllerAnimated:YES];
            
        }
        
        [TSHUDView hide];
    });
    
    
    
}

-(void)doDelete:(UIButton *)btn{
    int index = (int)btn.tag - 1000;
    if([self.imageDatas count] > index){
        [self.imageDatas removeObjectAtIndex:index];
        [self refreshImageView];
    }
    
    //    NSMutableArray *imageArr = [NSMutableArray arrayWithArray: self.tsShop.imgs];
    //    if([imageArr count]> index){
    //        [imageArr removeObjectAtIndex:index];
    //        self.tsShop.imgs = [imageArr copy];
    //        [self refreshImageView];
    //    }
    
    //删除旧的图片
}
-(void) doImgPickerCancel{
    //    [_lastArr removeAllObjects];
    [_thisArr removeAllObjects];
    
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
