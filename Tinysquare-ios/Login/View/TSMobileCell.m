//
//  TSMobileCell.m
//  Tinysquare
//
//  Created by xiezhaojun on 16/6/5.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSMobileCell.h"

@implementation TSMobileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.textField setPlaceholder:@"Mobile"];
    self.textField.secureTextEntry = NO;
    [self textChanged:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textChanged:(NSNotification *)notification{
    if([self.textField.text length]>0){
        self.preLabel.textColor = self.textField.textColor;
    }else{
        UIColor *color = [self.textField valueForKeyPath:@"_placeholderLabel.textColor"];
        if(color){
            self.preLabel.textColor = color;
        }else{
            self.preLabel.textColor = [UIColor lightGrayColor];
        }
    }
}

-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
