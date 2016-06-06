//
//  MyImagePickerViewController.h
//  ImagePickTest
//
//  Created by Aurora_sgbh on 14-10-28.
//  Copyright (c) 2014年 Aurora_sgbh. All rights reserved.
//
enum IMAGE_PICK_TYPE{
    IMAGE_PICK_TYPE_IMAGE = 1,
    IMAGE_PICK_TYPE_IMAGEANDAUDIO = 2,
};
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageCollectionData.h"
#import "UIView+Addition.h"
@protocol ImagePickerDelegate <NSObject>

-(void) doImgPickerSelected:(UIButton *)sender andData:(ImageCollectionData *)data;
-(void) doImgPickerFinish;
-(void) doImgPickerCancel;


-(NSMutableArray *) getLastImages;
-(NSMutableArray *) getThisImages;
@optional
-(void) doCutImgPickerFinish:(UIImage *)image;
-(void)doAudioFindish:(NSString *)recordFilePath RecordDuration:(double)duration;
@end



static NSInteger LIMIT_COUNT = 200;
@interface MyImagePickerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate
,UICollectionViewDataSource,UICollectionViewDelegate>//UIImagePickerControllerDelegate,
@property (strong, nonatomic) IBOutlet UIButton *countButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableMainView;
@property (strong, nonatomic) IBOutlet UIView *coverView;

@property (strong, nonatomic) IBOutlet UIButton *ablumSelBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIButton *jumpButton;


@property (nonatomic, assign) id<ImagePickerDelegate> imagePickerDelegate;
@property (strong, nonatomic) IBOutlet UIButton *finishButton;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;

@property(assign,nonatomic) BOOL isHadJump;
@property (nonatomic,assign) BOOL isSingle;

@property(nonatomic, assign)BOOL isCover;
//@property(nonatomic, assign)int type;

+ (instancetype)getImagePickerViewController;
@end

