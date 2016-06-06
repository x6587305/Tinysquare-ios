//
//  ImageAlbumCell.m
//  ImagePickTest
//
//  Created by Aurora_sgbh on 14-10-28.
//  Copyright (c) 2014年 Aurora_sgbh. All rights reserved.
//

#import "ImageAlbumCell.h"

@implementation ImageAlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundView:nil];
        [self setBackgroundColor:[UIColor clearColor]];
        self.frame = CGRectMake(0, 0, 320, 83);
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
