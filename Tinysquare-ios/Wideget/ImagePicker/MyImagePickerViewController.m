 //
//  MyImagePickerViewController.m
//  ImagePickTest
//
//  Created by Aurora_sgbh on 14-10-28.
//  Copyright (c) 2014年 Aurora_sgbh. All rights reserved.
//

#import "MyImagePickerViewController.h"
#import "ImageAlbumCell.h"
#import "ImageSelectCell.h"
#import "ImageCollectionData.h"

#import <Photos/Photos.h>
#import "Common.h"


@interface MyImagePickerViewController () <UICollectionViewDelegateFlowLayout>
@property(nonatomic,assign) long selectDicIndex ;
//@property(strong,nonatomic) ALAssetsLibrary *library;
@property (nonatomic, strong) NSMutableArray *assetGroups;
//@property (nonatomic,strong) ALAssetsGroup *selectedGroup;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

//@property (strong) PHImageManager *imageManager;
@property (nonatomic,strong) PHAssetCollection *selectedPHCollection;
@property (nonatomic, strong) NSMutableArray *collectionDatas;


@property (nonatomic,strong) NSMutableArray *lastSelectImage;
@property (nonatomic,strong) NSMutableArray *thisSelectImage;

//@property(nonatomic,assign) BOOL isPHPhoto;


@property(nonatomic,strong)  NSPredicate *imagePredicate ;
@end

@implementation MyImagePickerViewController


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (*stop) {
                //点击“好”回调方法:这里是重点
                NSLog(@"好");
                [self initAlbumData];
                return;
                
            }
            *stop = TRUE;
            
        } failureBlock:^(NSError *error) {
            
            //点击“不允许”回调方法:这里是重点
            NSLog(@"不允许");
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.lastSelectImage = [self.imagePickerDelegate getLastImages];
    self.thisSelectImage = [self.imagePickerDelegate getThisImages];
    
    self.selectDicIndex = -1;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView.alpha = 0;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.layer.cornerRadius = 10;
    [self.tableView.layer setBackgroundColor:[UIColor clearColor].CGColor];
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setTableHeaderView:view];
    [self.tableView setBackgroundColor:[UIColor redColor]];
    
    self.collectionView.dataSource =self;
    self.collectionView.delegate = self;
    self.assetGroups = [[NSMutableArray alloc] init];
    self.collectionDatas = [[NSMutableArray alloc] init];
    
    [self.tableMainView setAlpha:0];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    self.jumpButton.layer.cornerRadius = 0;
    self.finishButton.layer.cornerRadius = 0;
    if(self.isHadJump){
        self.jumpButton.hidden = NO;
    }else{
        self.jumpButton.hidden = YES;
    }
    
    
    [self initAlbumData];
    
    if(self.isSingle){
        LIMIT_COUNT = 1;
        self.countButton.hidden = YES;
        [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    if(self.isHadJump){
        //         self.collectionView.frame = CGRectMake(0, 44, 320, height-48-44-1+0.5);
        [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 45, 0)];
    }else{
        //         self.collectionView.frame = CGRectMake(0, 44, 320, height-44-1);
    }
}
//-(void)viewWillAppear:(BOOL)animated{
//    
//}

-(NSPredicate *)imagePredicate{
    if(!_imagePredicate){
        _imagePredicate = [NSPredicate predicateWithFormat:@"mediaType  = %d ", PHAssetMediaTypeImage];
    }
    return _imagePredicate;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.countButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[self.thisSelectImage count]] forState:UIControlStateDisabled];
    self.countButton.enabled=NO;
    [self.countButton setBackgroundImage:[UIImage imageNamed:@"photo_num_bg"] forState:UIControlStateDisabled];
    [self.collectionView reloadData];
    //    float height = [UIScreen mainScreen].bounds.size.height;
    
     [self initAlbumData];
}

+ (instancetype)getImagePickerViewController {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MyImagePicker" bundle:nil];
    MyImagePickerViewController *vc = [board instantiateViewControllerWithIdentifier:@"MyImagePickerViewController"];
    return vc;
}


- (void) initAlbumData{
    [self initAlbumByPH];

}

-(void) initAlbumByPH{
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
  
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:options];
    for(PHAssetCollection *assertCollection in topLevelUserCollections){
         PHFetchOptions *options2 = [[PHFetchOptions alloc] init];
           options2.predicate = self.imagePredicate;
         options2.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
         PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assertCollection options:options2];
        if([assetsFetchResult count]>0){
            [_assetGroups addObject:assertCollection];
        }
    }
    self.selectDicIndex = 0;
    [self selectAblum];
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
    
}



- (void)reloadTableView
{
    [self.tableView reloadData];
    NSInteger cellCount = [self tableView:self.tableView numberOfRowsInSection:0];
    //[self.assetGroups count];
     float mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
//    if(self.isHadJump){
//        self.tableMainView.frame = CGRectMake(0, 0, 320, mainScreenHeight-48-1);
//    }else{
        self.tableMainView.frame = CGRectMake(0, 0, 320, mainScreenHeight);
//    }
   

    self.coverView.frame=self.tableMainView.frame;
    float height = MIN(self.tableMainView.frame.size.height-44,83*cellCount);
//    self.tableView.frame = CGRectMake(0, 44, 320, height);
    
    self.tableViewHeight.constant = height;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doShowAblum:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^(void){
        [self.tableMainView setAlpha:1];
    }];
}
#pragma mark --- 准备图片
- (void)preparePhotos
{
    @autoreleasepool {
    
        _collectionDatas =[NSMutableArray array];

        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.predicate = self.imagePredicate;
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        if(self.selectedPHCollection == nil){
            
            PHFetchResult *fr =[PHAsset fetchAssetsWithOptions:options];
            
            for(PHAsset *result in fr){
                
                [_collectionDatas insertObject:[[ImageCollectionData alloc] initWithPhAsset:result] atIndex:0];
            }
        }else{
            PHAssetCollection *assetCollection = self.assetGroups[self.selectDicIndex-1];
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            for(PHAsset *result in assetsFetchResult){
                [_collectionDatas insertObject:[[ImageCollectionData alloc] initWithPhAsset:result] atIndex:0];
            }
            
        }
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            if([_collectionDatas count]>0){
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            }
        });
    }
}


#pragma mark ---- table delegate
-(void) selectAblum{
 [self selectAblumByPH];

}
-(void) selectAblumByPH{
    NSString *ablumName = nil;
    if(self.selectDicIndex == 0){
        self.selectedPHCollection = nil;
        ablumName = @"所有照片";
    }else{
       self.selectedPHCollection = [self.assetGroups objectAtIndex: self.selectDicIndex-1];
        ablumName = self.selectedPHCollection.localizedTitle;
    }
   
    
    [self.ablumSelBtn setTitle:ablumName forState:UIControlStateNormal];
    [self.ablumSelBtn setImage:[UIImage imageNamed:@"ablum_select_arrow"] forState:UIControlStateNormal];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = CGSizeMake(200,1000);
    CGRect rect = [ablumName boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    CGSize labelsize = rect.size;
    self.ablumSelBtn.width = labelsize.width + 7 +12;//TODO...  没这个属性
    
    [self.ablumSelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
    [self.ablumSelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, labelsize.width + 7, 0, -(labelsize.width + 7))];
    [self.tableView reloadData];
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectDicIndex = indexPath.row;
    [self selectAblum];
    [UIView animateWithDuration:0.3 animations:^(void){
        //        self.tableView.frame = CGRectMake(0, -self.tableView.frame.size.height, 320, self.tableView.frame.size.height);
        [self.tableMainView setAlpha:0];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
         return [self.assetGroups count] + 1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageAlbumCell"];
    if(cell ==nil){
        cell = [[ImageAlbumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ImageAlbumCell"];
    }
    if(indexPath.row == 0){
        cell.lineView.hidden=YES;
    }else{
        cell.lineView.hidden=NO;
    }
 
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = self.imagePredicate;
    NSUInteger count =0;
    NSString *name;
    if(indexPath.row == 0){
        PHFetchResult *fr =[PHAsset fetchAssetsWithOptions:options];
        count = fr.count;
        name = @"所有照片";
        if([fr count]>0){
            [[PHImageManager defaultManager] requestImageForAsset:fr[0]
                                                       targetSize:CGSizeMake(157, 157)
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:nil
                                                    resultHandler:^(UIImage *result, NSDictionary *info) {
                                                        [cell.leftImage setImage:result];
                                                    }];
            
        }
        
        
        
    }else{
        PHAssetCollection *assetCollection = self.assetGroups[indexPath.row -1];
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
        count = [assetsFetchResult count];
        name = assetCollection.localizedTitle;
        if([assetsFetchResult count]>0){
            [[PHImageManager defaultManager]  requestImageForAsset:assetsFetchResult[0]
                                                        targetSize:CGSizeMake(157, 157)
                                                       contentMode:PHImageContentModeAspectFill
                                                           options:nil
                                                     resultHandler:^(UIImage *result, NSDictionary *info) {
                                                         [cell.leftImage setImage:result];
                                                     }];
        }
        
    }
    cell.dicNameLabel.text =name;
    cell.imageCountLabel.text = [NSString stringWithFormat:@"%ld张照片",(long)count];
    
    if(self.selectDicIndex == indexPath.row ){
        [cell.rightImage setHidden:NO];
    }else{
        [cell.rightImage setHidden:YES];
    }

        
    
    
    return cell;
}

#pragma mark -------- collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.collectionDatas count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    long index = indexPath.row;
    ImageSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageSelectCell" forIndexPath:indexPath];
        
        if(self.isSingle){
            [cell.imageSeView setHidden:YES];
        }else{
            [cell.imageSeView setHidden:NO];
            [cell.imageSeView setTag:index];
            if(!cell.hadClickEve){
                [cell.imageSeView addTarget:self action:@selector(doSelected:) forControlEvents:UIControlEventTouchUpInside];
                cell.hadClickEve = YES;
            }
        }
    
        
        ImageCollectionData *data = self.collectionDatas[index];

        cell.tag = indexPath.row;
        cell.imageSeView.tag = indexPath.row;

    
            
            [[PHImageManager defaultManager] requestImageForAsset:data.phAsset
                                                       targetSize:CGSizeMake(157, 157)
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:nil
                                                    resultHandler:
             ^(UIImage *result, NSDictionary *info) {
                 if(cell.tag == indexPath.row){
                     if(data.phAsset.mediaType == PHAssetMediaTypeVideo){
                         NSLog(@"------------------------%f",data.phAsset.duration);
                     }
                     // duration mediaType
                     [cell.showImageView setImage: result];
                 }
             }];

            
        if([data cannotSelected:self.lastSelectImage]){
            [cell.imageSeView setBackgroundImage:[UIImage imageNamed:@"img_disselect"] forState:UIControlStateNormal ];
            [cell.imageSeView setBackgroundImage:[UIImage imageNamed:@"img_disselect"] forState:UIControlStateDisabled ];
            cell.imageSeView.enabled=NO;
            
        }else{
            cell.imageSeView.enabled=YES;
            if([data isImageSelected:self.thisSelectImage]){
                [cell.imageSeView setBackgroundImage:[UIImage imageNamed:@"img_select"] forState:UIControlStateNormal ];
            }else{
                [cell.imageSeView setBackgroundImage:[UIImage imageNamed:@"img_unselect"] forState:UIControlStateNormal ];
            }
        }


    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)iPath{
    ImageSelectCell *cell = (ImageSelectCell*)[collectionView cellForItemAtIndexPath:iPath];
    [self doSelected:cell.imageSeView];
    
    //[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageSelectCell" forIndexPath:indexPath];
}






#pragma mark -----照片选择 自定义 协议
-(void) doSelected:(UIButton *)sender {
    long index = sender.tag;
    ImageCollectionData *data = self.collectionDatas[index];
    if(self.isSingle){
        
        [self.imagePickerDelegate  doImgPickerSelected:sender andData:data];
        [data toggleSingelSelected:self.thisSelectImage];
        [self.collectionView reloadData];
        [self.imagePickerDelegate doImgPickerFinish];

    }else{
        [self.imagePickerDelegate  doImgPickerSelected:sender andData:data];
        [self.countButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[self.thisSelectImage count] ] forState:UIControlStateDisabled];
        
        self.countButton.enabled=NO;
    }
    
    
}
- (IBAction)doFinish:(id)sender {
    if(self.isSingle){
        [self.imagePickerDelegate doImgPickerCancel];
    }else{
        [self.imagePickerDelegate doImgPickerFinish];
    }
}


- (IBAction)doCancel:(id)sender {
    [self.thisSelectImage removeAllObjects];
    [self.imagePickerDelegate doImgPickerCancel];
}

#pragma mark - collection flow layout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kDeiveWidth - 40 - 5 * 2) / 3;
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


@end
