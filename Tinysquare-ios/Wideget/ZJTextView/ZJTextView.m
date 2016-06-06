//
//  ZJTextView.m
//  慧学南通
//
//  Created by xiezhaojun on 16/5/11.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "ZJTextView.h"
#import "UIView+Addition.h"
#define PlaceHolder_Tag 999
@interface ZJTextView ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *placeHolderLabel;
//@property(nonatomic,strong) UITextView *backTextView;

@property(nonatomic,assign)float limitHegight;
@end
@implementation ZJTextView

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@"评论"];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
        if ( !self.placeHolderLabel)
        {
            UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4,0,230,0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
            
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = PlaceHolder_Tag;
            self.placeHolderLabel = placeHolderLabel;
            [self addSubview:placeHolderLabel];
        }
        self.placeHolderLabel.font = [UIFont systemFontOfSize:13];//self.font;
        self.placeHolderLabel.text = self.placeholder;
        [self.placeHolderLabel sizeToFit];
        
        if( [[self text] length] == 0 && self.placeholder.length > 0 )
        {
            [[self viewWithTag:PlaceHolder_Tag] setAlpha:1];
        }
        [self setTextContainerInset:UIEdgeInsetsZero];
//        self.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.delegate = self;
    }
    return self;
}


- (void)textChanged:(NSNotification *)notification
{
    self.placeHolderLabel.font = self.font;
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:PlaceHolder_Tag] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:PlaceHolder_Tag] setAlpha:0];
    }
    
    float width = self.bounds.size.width;
    UIFont *font = self.font?:[UIFont systemFontOfSize:13];
      NSLog(@"%@",self.text);
    NSLog(@"left:%f top:%f right:%f bottom:%f",self.contentInset.left, self.contentInset.top,self.contentInset.right,self.contentInset.bottom);
   
      NSLog(@"%@", NSStringFromCGSize(self.textContainer.size));
    //uitextview 左右貌似有4个像素的 pading 不知道怎么去除
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(width-8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    if(rect.size.height >= 32){//48 写死的 2行 就是 48 的样子 4/78
        self.scrollEnabled = YES;
//        self.height = 32;
        [self setNewHeight:32];
        [self scrollRectToVisible:CGRectMake(0, self.contentSize.height-1, 1, 1) animated:NO];
    }else{
        self.scrollEnabled = NO;
//        self.height = rect.size.height;
        [self setNewHeight:rect.size.height];
    }
    
   
}

-(void) setNewHeight:(CGFloat)height{
    if (self.height != height) {
        self.height  = height;
        [self.superview.superview setNeedsLayout];
    }
}


- (void)setText:(NSString *)text {
     NSLog(@"setText");
    [super setText:text];
    [self textChanged:nil];
}


-(void)layoutSubviews{
    [super layoutSubviews];
     _placeHolderLabel.width = self.bounds.size.width;
}

-(void) setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
//    _placeHolderLabel.width = kDeiveWidth;
    _placeHolderLabel.text =  self.placeholder;
//    [_placeHolderLabel sizeToFit];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
