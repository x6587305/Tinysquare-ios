//
//  TSCountTextView.m
//  Tinysquare-ios
//
//  Created by xiezhaojun on 16/4/27.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSCountTextView.h"
@interface TSCountTextView()
@property(nonatomic,assign) int limit;
@property(nonatomic,weak)UILabel *showCountLabel;
@end
@implementation TSCountTextView
-(instancetype)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)textChanged:(NSNotification *)notification{
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
