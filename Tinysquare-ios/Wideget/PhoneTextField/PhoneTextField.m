//
//  PhoneTextField.m
//  iGrow
//
//  Created by Nan Hu on 14-9-19.
//  Copyright (c) 2014年 Aurora_sgbh. All rights reserved.
//

#import "PhoneTextField.h"
@interface PhoneTextField()
 @property (nonatomic,assign) int myLimit;
//@property(strong,nonatomic) LimitTextFiled *textLimitDelgate;
@end

@implementation PhoneTextField

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        _edgeInsetLeft = 14;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _edgeInsetLeft = 14;
    }
    return self;
}
//-(void)setLimit:(int)limit{
//    _myLimit = limit;
//    self.textLimitDelgate =[[LimitTextFiled alloc]initWithLimt:limit];
//    self.delegate = self.textLimitDelgate;
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
//                                                name:UITextFieldTextDidChangeNotification
//                                              object:self];
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //设置文字颜色
    self.textColor = [UIColor colorWithRed:15.0/255.0 green:15.0/255.0 blue:15.0/255.0 alpha:1.0];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect phoneRect = CGRectMake(bounds.origin.x + _edgeInsetLeft, bounds.origin.y+self.placeholderTop, bounds.size.width, bounds.size.height);
    return phoneRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect phoneRect = CGRectMake(bounds.origin.x + _edgeInsetLeft, bounds.origin.y, bounds.size.width, bounds.size.height);
    return phoneRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + _edgeInsetLeft, bounds.origin.y, bounds.size.width, bounds.size.height);
}

//-(void)textFiledEditChanged:(NSNotification *)obj{
//    if(self.myLimit!=0){
//        [Utilities textFieldSetLength:self putLength:self.myLimit];
//
//    }
//}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UITextFieldTextDidChangeNotification
                                                 object:self];
}
@end
