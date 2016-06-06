//
//  TSBigImageView.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/5/27.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBigImageView.h"
#import "TSBigImageCell.h"
#import "Common.h"
#import "TSUtilties.h"
#import "AppDelegate.h"
#import "UIView+Addition.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MyCenterTips.h"
@interface TSBigImageView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)  UICollectionView *collectionView;
//@property(nonatomic,strong) NSArray<NSString *> *imageStrArr;
@property(nonatomic,weak) id<TSBigImageDelegate > delegate;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *saveView;

@property(nonatomic,strong) UIButton *rightBtn;
@end
static NSString *collectionCell = @"collectionCell";
@implementation TSBigImageView

-(instancetype)initWithDelegate :(id<TSBigImageDelegate>) delegete andFirstIndex:(NSInteger) index{
    self = [super initWithFrame:CGRectMake(0, 0, kDeiveWidth, kDeiveHeight)];
   
    if(self){
         self.backgroundColor = [UIColor clearColor];
        self.index = index;
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, kDeiveHeight)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.3;
        [self addSubview:backView];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, kDeiveHeight) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
//        self.collectionView.
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self addSubview:self.collectionView];
        
      
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeiveWidth, 64)];
        topView.backgroundColor = [UIColor clearColor];
        //COLOR_SIGLE(131);
         self.topView = topView;
        [self addSubview:topView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, 20, kDeiveWidth, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [topView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIButton *backBtuuon = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtuuon.frame = CGRectMake(10, 27, 44, 30);

        [backBtuuon setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [backBtuuon addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:backBtuuon];
        
        
        
       
       
       
        
     
        
        self.delegate = delegete;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.bounces = NO;
        [self.collectionView registerClass:[TSBigImageCell class] forCellWithReuseIdentifier:collectionCell];
        
        self.saveView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeiveWidth, kDeiveHeight-64)];
        self.saveView.hidden = YES;
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.backgroundColor = [UIColor whiteColor];
        saveBtn.frame = CGRectMake(0, kDeiveHeight - 98 - 64, kDeiveWidth, 44);
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:COLOR_SIGLE(51) forState:UIControlStateNormal];
        [saveBtn addTarget:self  action:@selector(doRealSave) forControlEvents:UIControlEventTouchUpInside];
        [self.saveView addSubview:saveBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.frame = CGRectMake(0, kDeiveHeight - 44 - 64, kDeiveWidth, 44);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:COLOR_SIGLE(51) forState:UIControlStateNormal];
        [self.saveView addSubview:cancelBtn];
        [cancelBtn addTarget:self  action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.saveView];
        
        
        if([self.delegate hadDelete]){
            UIButton *rightBtuuon = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtuuon.frame = CGRectMake(kDeiveWidth-60-14, 27, 60, 30);
//            rightBtuuon.backgroundColor = [UIColor redColor];
            [topView addSubview:rightBtuuon];
            self.rightBtn = rightBtuuon;
            
            [rightBtuuon addTarget:self action:@selector(doDelete) forControlEvents:UIControlEventTouchUpInside];
            [rightBtuuon setTitle:@"delete" forState:UIControlStateNormal];
            rightBtuuon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            rightBtuuon.titleLabel.textAlignment = UIControlContentHorizontalAlignmentRight;
            //            [rightBtuuon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            [rightBtuuon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            [rightBtuuon setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            
            //            [rightBtuuon setTitleColor:color forState:UIControlStateNormal];
            [rightBtuuon setTitleColor:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
            [rightBtuuon setTitleColor:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f] forState:UIControlStateDisabled];
            //    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 9, 0,-9);
            rightBtuuon.titleLabel.font = [UIFont systemFontOfSize:16.0];
            //            [self createRightBarTitle:@"delete" btnSize:CGSizeMake(60, 30) target:self select:@selector(doDelete)];
            //        self.index = 0;
                       //        if([self.delegate canDelete:0]){
            //            self.navigationItem.rightBarButtonItem.enabled = YES;
            //        }else{
            //            self.navigationItem.rightBarButtonItem.enabled = NO;
            //
            //        }
        }
        
        [self refresh];


//        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(doSave:)];
//        [self.saveView addGestureRecognizer:longGes];

    }
    return self;
}

-(void)doBack:(id)btn{
    [self removeFromSuperview];
}

-(void)doDelete{
    int index = round(self.collectionView.contentOffset.x/kDeiveWidth);
    [self.delegate deleteIndexAt:index];
    [self.collectionView reloadData];
      [self refresh];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.delegate getImageCount];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TSBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    if([self.delegate getImageAtIndex:(int)indexPath.row]){
        cell.imageView.image = [self.delegate getImageAtIndex:(int)indexPath.row];
    }else{
         [cell setImage:[self.delegate getImageUrlAtIndex:(int)indexPath.row] atIndex:(int)indexPath.row ofCount:(int) [self.delegate getImageCount]];
    }
   
    cell.bigView = self;
    return  cell;
}


-(void) doShow{
    self.topView.hidden = !self.topView.hidden;
}

-(void)doSave:(UIGestureRecognizer *)ges{
    if(ges.state == UIGestureRecognizerStateBegan){
        if(self.saveView.hidden){
            self.saveView.top = kDeiveHeight;
            [UIView animateWithDuration:0.25 animations:^{
                self.saveView.top = 64;
                self.saveView.hidden = NO;
            }];
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                self.saveView.top = kDeiveHeight;
                self.saveView.hidden = YES;
            }];
        }

    }
}

-(void )doRealSave{
    TSBigImageCell *cell =(TSBigImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.index - 1 inSection:0]];
   UIImage *image = cell.imageView.image;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
   
     @weakify(self);
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL* assetURL, NSError* error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MyCenterTips showNoImageTips:@"save success!"];
            @strongify(self);
            [self doCancel];
        });
    }];
    
}

-(void)doCancel{
    [UIView animateWithDuration:0.25 animations:^{
        self.saveView.top = kDeiveHeight;
        self.saveView.hidden = YES;
    }];

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     return CGSizeMake(kDeiveWidth, kDeiveHeight);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float x = scrollView.contentOffset.x;
    self.index = floor( x/kDeiveWidth);
    [self refresh];
    
}

-(void) refresh{
    if([self.delegate canDelete:self.index]){
        self.rightBtn.enabled = YES;
    }else{
        self.rightBtn.enabled = NO;
        
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%d/%d",self.index+1,[self.delegate getImageCount]];
}

+(void) showBigDelegate:(id<TSBigImageDelegate>) delegate andFirstIndex:(NSInteger) index{
    TSBigImageView *bigView = [[TSBigImageView alloc]initWithDelegate:delegate andFirstIndex:index];
    
    if(bigView.index>0){
        bigView.collectionView.contentOffset = CGPointMake(bigView.index*kDeiveWidth, bigView.collectionView.contentOffset .y);
        
        //        NSLog(@"%f",self.collectionView.contentOffset.x);
        //        int index = round(self.collectionView.contentOffset.x/kDeiveWidth);
        
    }

    [[AppDelegate shareAppDelegate].window addSubview:bigView];
}


//TSBigImageVC *vc = [TSBigImageVC getVCDelete:self andFirstIndex:index];

@end
