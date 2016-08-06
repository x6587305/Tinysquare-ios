//
//  TSNewPostVC.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/26.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSNewPostVC.h"
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
#import "TSBigImageVC.h"
#import "AppDelegate.h"
#import "MyCenterTips.h"
#import "TSNews.h"
#import "TSImage.h"
#import "TSHUDView.h"
#import "TSUtilties.h"
#import "TSBigImageView.h"
#import "ZJTextView.h"
#import "ImageData.h"

@interface TSNewPostVC ()<ImagePickerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TSBigImageDelegate>
@property(nonatomic,strong) TSShop *shop;
@property(nonatomic,strong) TSNews *news;
@property(nonatomic,strong) NSMutableArray *lastArr;
@property(nonatomic,strong) NSMutableArray *thisArr;
@property(nonatomic,strong) ZJTextView *contentTextView;
@property(nonatomic,strong) UIImageView *headerImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *countLabel;
@property(nonatomic,strong) UIView *bottomView;



@property(nonatomic,strong) NSMutableArray *imageViews;
@property(nonatomic,strong) NSMutableArray<UIButton *> *imageDeleteBtnArr;
//@property(nonatomic,strong) NSMutableArray *images;
@property(nonatomic,strong) NSMutableArray<ImageData *> *imageDatas;
@property(nonatomic,assign)PHAuthorizationStatus photoStatus;
@end

@implementation TSNewPostVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllColor:COLOR_SIGLE(241) titleColor:[UIColor blackColor]];
    [TSUtilties createLeftReturnButtonBlack:self];
    [self createRightBarTitle:@"confirm" TitleColor:COLOR_SIGLE(52) btnSize:CGSizeMake(100, 30) target:self select:@selector(submit)];
    self.title = @"New Profile";
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        self.photoStatus = status;
    } ];

    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(10, 15, kDeiveWidth-20, 40)];
    [self.view addSubview:topView];
    
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.headerImageView.layer.cornerRadius = 5;
    self.headerImageView.layer.masksToBounds = YES;
    [self.headerImageView  sd_setImageWithURL:[NSURL URLWithString:self.shop.avator] placeholderImage: [UIImage imageNamed:@"img_touxiang_default"]];
    [topView addSubview:self.headerImageView];
    
    self.nameLabel = [[UILabel alloc]init];
    [self.nameLabel setText:self.shop.name];
    [topView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(10);
        make.top.equalTo(self.headerImageView.mas_top).offset(8);
        make.height.equalTo(@15);
    }];
    [self.nameLabel setFont:[UIFont systemFontOfSize:15]];
    [self.nameLabel setTextColor:COLOR_SIGLE(26)];
    
    self.countLabel = [[UILabel alloc]init];
    [self.countLabel setText:@"200"];
    [topView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.right.equalTo(topView.mas_right).offset(-5);
        make.height.equalTo(@14);
        
    }];
    [self.countLabel setFont:[UIFont systemFontOfSize:14]];
    [self.countLabel setTextColor:COLOR_RGB(255, 71, 71, 1)];
    
    
    self.contentTextView = [[ZJTextView alloc]init];
    self.contentTextView .backgroundColor = COLOR_SIGLE(241);
    self.contentTextView.delegate = self;
    self.contentTextView.placeholder = @"写点什么吧";
//    self.contentTextView.layer.borderWidth = SINGLE_LINE_WIDTH;
//    self.contentTextView.layer.borderColor = COLOR_SIGLE(62).CGColor;
   

    [self.view addSubview:self.contentTextView];
    [self.contentTextView setFont:[UIFont systemFontOfSize:13]];
    [self.contentTextView setTextColor:COLOR_SIGLE(26)];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.left.equalTo(topView.mas_left);
        make.right.equalTo(topView.mas_right).offset(-5);
        make.height.equalTo(@150);
//        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    //200
    float top = 220;
    float width = (kDeiveWidth - 55 )/4;
   
    self.imageViews = [NSMutableArray array];
      self.imageDeleteBtnArr = @[].mutableCopy;
//    self.images = [NSMutableArray array];
    self.imageDatas = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.masksToBounds = YES;
        float imagetop = i/4*(width +10) + top;
        float left = 10 + i%4*(width +10);
        imageView.frame= CGRectMake(left, imagetop, width, width);
        [self.view addSubview:imageView];
        [self.imageViews addObject:imageView];
        imageView.hidden = YES;
        imageView.tag = 1000 + i;
        UIGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookBig:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:ges];
        //UITapGestureRecognizer
        
    }
    
    for (int i = 0; i<7; i++) {
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
  

    if(self.news){
        [self.contentTextView setText:self.news.content];
        [self textView:self.contentTextView shouldChangeTextInRange:NSMakeRange(0, self.news.content.length) replacementText:self.news.content];
        for (TSImage *image in self.news.imgs) {
            ImageData *data = [[ImageData alloc]init];
            data.url = image.url;
            [self.imageDatas addObject:data];
        }
    }

}

-(void) doRealSubmit{
    NSString *url;
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (ImageData *data in self.imageDatas) {
        [imageUrls addObject:data.url?:@""];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"token":[[AppDelegate shareAppDelegate] accountwithVC:self].token?:@"",@"content":self.contentTextView.text,@"imgs":[imageUrls componentsJoinedByString:@","]}];
    if(self.news){
        url = TS_INTER_NEW_UPDATE;
        [dic setObject:self.news.objId forKey:@"newsId"];
    }else{
        url = TS_INTER_NEW_PUBLISH;
        
    }
    //newsId
    
    
    @weakify(self);
    [HttpRequestHelper sendHttpRequestBlock:url postData:dic backSucess:^(id backData) {
        @strongify(self);
        if(self.news){
            [MyCenterTips showTips:@"edit success!"];
            NSMutableArray *array = [NSMutableArray array];
            [self.news setContent:[dic objectForKey:@"content"]];
            for (ImageData *data in self.imageDatas) {
                TSImage *image = [[TSImage alloc]init];
                image.url = data.url;
                image.objId = nil;
                [array addObject:image];
            }
            self.news.imgs = [array copy];
        }else{
            [MyCenterTips showTips:@"publish success!"];
        }
        [TSHUDView hide];
        [self.navigationController popViewControllerAnimated:YES];
        
    } backFalied:^(id backData) {
        [TSHUDView hide];
    }];
    
}

-(void)submit{
   
    if(!([self.contentTextView.text length]>0)){
        [MyCenterTips showCode:@"ERROR_CONTENT_EMPTY"];
        return;
    }
    if([self.imageDatas count] == 0){
        [self doRealSubmit];
        return;
    }
     [TSHUDView show];
    __block unsigned long needUploadCount = [self.imageDatas count];
    @weakify(self);
    for (ImageData *data in self.imageDatas) {
        if(data.image){
            [TSUtilties uploadImage:data.image success:^(UIImage *image, NSString *imageUrl){
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self refreshImageView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self.contentTextView resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)lookBig:(UIGestureRecognizer *)ges{
    NSInteger index = ges.view.tag - 1000;
    [TSBigImageView showBigDelegate:self andFirstIndex:index];
}
#pragma mark --  TSBigImageDelegate
-(BOOL) hadDelete{
    return NO;
}

-(BOOL)canDelete:(int)index{
//    if(self.news && [self.news.imgs count]>index){
//        return NO;
//    }
    return YES;
}

//if(self.news){
//    [self.contentTextView setText:self.news.content];
//    [self textView:self.contentTextView shouldChangeTextInRange:NSMakeRange(0, self.news.content.length) replacementText:self.news.content];
//    for (TSImage *image in self.news.imgs) {
//        [self.imageUrls addObject:image.url];
//    }
//}

-(int) getImageCount{
    return (int)[self.imageDatas count];
}
-(NSString *) getImageUrlAtIndex:(int)index{
    return self.imageDatas[index].url;
}

-(UIImage *)getImageAtIndex:(int)index{
    return self.imageDatas[index].image;
}


-(void)deleteIndexAt:(int)index{
//    [self.lastArr removeObjectAtIndex:(index - self.news.imgs count)];
    int deleteIndex = (index - (int)[self.news.imgs count]);
    if([self.lastArr count] >deleteIndex){
        [self.lastArr removeObjectAtIndex:deleteIndex];
    }
    
    if([self.imageDatas count] > index){
         [self.imageDatas removeObjectAtIndex:index];
    }
   
    
    [self refreshImageView];

}

-(void)doDelete:(UIButton *)btn{
    int index = (int)btn.tag -  1000;
    [self deleteIndexAt:index];
}

#pragma mark --- keyboad notify
- (void)keyboardWillShow:(NSNotification*)notification{
    
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.top = kDeiveHeight-40 -64 -keyboardRect.size.height;
        //-keyboardRect.size.height/2;
    }];
    
    
}
- (void)keyboardWillHide:(NSNotification*)notification{
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.top = kDeiveHeight-40 -64;
    }];
}


- (void)doPhoto:(id)sender {
    if([self.imageDatas count] > 7 ){
        
        [MyCenterTips showTips:@"只能上传7张照片"];
        
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
        if([self.imageDatas count] + count > 7 ){
            [data toggleSelected:self.thisArr];
            
            [MyCenterTips showTips:@"只能上传7张照片"];
            
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
    for(int i =0 ; i<7;i++){
        UIImageView *imageView =  self.imageViews[i];
        UIButton *deleteBtn = self.imageDeleteBtnArr[i];

        if([self.imageDatas count]>i){
            imageView.hidden = NO;
            if([self canDelete:i]){
                deleteBtn.hidden = NO;
            }else{
                deleteBtn.hidden = YES;
            }
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

#define LIMIT_COUNT 200
#pragma make -- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    NSInteger rangeLength = range.length;
    NSInteger textLength = text.length;
    
    if(self.contentTextView.text.length == LIMIT_COUNT && ((rangeLength - textLength)<0)){
        return NO;
    }
    
    NSString * newString = self.contentTextView.text;
    newString = [newString stringByReplacingCharactersInRange:range withString:text];
    
    if(newString.length > LIMIT_COUNT){//替换的文字的位置已近长于了LIMIT_COUNT
        newString = [newString substringToIndex:LIMIT_COUNT];
        self.contentTextView.text = newString;
        [self.countLabel setText:@"0"];
        return NO;
    }
    
    int count = LIMIT_COUNT - (int)newString.length;
    [self.countLabel setText:[NSString stringWithFormat:@"%d",count]];
    
    return  YES;
}

+(instancetype)getVC:(TSShop *)shop andNews:(TSNews *)news{
    TSNewPostVC *vc = [[TSNewPostVC alloc]init];
    vc.shop = shop;
    vc.news = news;
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
