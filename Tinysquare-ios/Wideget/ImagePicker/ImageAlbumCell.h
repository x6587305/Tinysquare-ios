//
//  ImageAlbumCell.h
//  ImagePickTest
//
//  Created by Aurora_sgbh on 14-10-28.
//  Copyright (c) 2014年 Aurora_sgbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAlbumCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UIImageView *leftImage;
@property(nonatomic,strong) IBOutlet UILabel *dicNameLabel;
@property(nonatomic,strong) IBOutlet UILabel *imageCountLabel;
@property(nonatomic,strong) IBOutlet UIImageView *rightImage;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@end
