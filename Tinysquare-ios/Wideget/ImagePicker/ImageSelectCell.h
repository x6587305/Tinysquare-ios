//
//  ImageSelectCell.h
//  ImagePickTest
//
//  Created by Aurora_sgbh on 14-10-29.
//  Copyright (c) 2014年 Aurora_sgbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSelectCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *showImageView;

@property (strong, nonatomic) IBOutlet UIButton *imageSeView;

@property (assign,nonatomic) BOOL hadClickEve;

@end
