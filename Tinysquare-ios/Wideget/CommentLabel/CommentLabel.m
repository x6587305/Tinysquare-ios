
//  CommentLabel.m
//  ContextTest
//
//  Created by aurora-IOS on 15/8/21.
//  Copyright (c) 2015年 aurora-IOS. All rights reserved.
//

#import "CommentLabel.h"
#import <CoreText/CoreText.h>


#define kTextPadding 6
@interface CommentLabel()
@property(nonatomic,strong) NSMutableAttributedString *showAttributedString;
@property(nonatomic,strong) NSMutableArray *linkDataArray;
@property(nonatomic,strong) LinkBlock linkBlock;


@property(nonatomic,strong) NSString *nativeText;
//@property(nonatomic,assign) float contentHeight;

//@property(nonatomic,strong) NSNumber *imageHeight;
@end
@implementation CommentLabel

-(void)setLinkBlock:(LinkBlock)lindBlock{
    _linkBlock = lindBlock;
}

-(NSMutableArray *)linkDataArray{
    if(!_linkDataArray){
        _linkDataArray = [NSMutableArray array];
    }
    return _linkDataArray;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.lineBreakMode = NSLineBreakByCharWrapping;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//        tapGesture.cancelsTouchesInView    = NO;
        tapGesture.delegate = self;
        
        [self addGestureRecognizer:tapGesture];

    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.lineBreakMode = NSLineBreakByCharWrapping;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        //        tapGesture.cancelsTouchesInView    = NO;
        tapGesture.delegate = self;
        
        [self addGestureRecognizer:tapGesture];

    }
    return self;
}

-(void)setText:(NSString *)text{
//    [super setText:text];
    NSAttributedString *att =  [[NSAttributedString alloc]initWithString:text];
    [self setAttributedText:att];
    
}
-(void)setAttributedText:(NSAttributedString *)attributedText{
    //性能浪费很多的点
    [super setAttributedText:attributedText];
    
    self.showAttributedString = [attributedText mutableCopy];
    


//    [super setAttributedText:self.showAttributedString];
}
-(void) addlLinkObject:(id) object andRange:(NSRange) range{
    [self.showAttributedString addAttribute:kLinkString value:object range:range];
}
- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range{
    [self.showAttributedString addAttribute:name value:value range:range];
}



-(BOOL) linkAtPoint:(CGPoint) point{
    for(NSDictionary *linkData in self.linkDataArray){
        
        NSString *rectStr = [linkData objectForKey:@"rect"];
        CGRect rect = CGRectFromString(rectStr);
        if (CGRectContainsPoint(rect, point)) {
            return YES;
        }
    }
    return NO;

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //        CGPoint point = [gestureRecognizer locationInView:self];
    CGPoint point = [touch locationInView:self];
    return [self linkAtPoint:point];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    
    CGPoint point = [tapGesture locationInView:self];
    for(NSDictionary *linkData in self.linkDataArray){
        id data = [linkData objectForKey:@"data"];
        NSString *rectStr = [linkData objectForKey:@"rect"];
        CGRect rect = CGRectFromString(rectStr);
        if (CGRectContainsPoint(rect, point)) {
           
            
            rect.origin.x -= 3;
            rect.origin.y -= 1;
            rect.size.width += 6;
            rect.size.height += 6;
            UIView *view = [[UIView alloc] initWithFrame:rect];
            [view.layer setCornerRadius:3];
//            [view setBackgroundColor:[UIColor orangeColor]];
//             [view setBackgroundColor:[UIColor blackColor]];
             [view setBackgroundColor:[UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1]];
            [view setAlpha:0];
            [self addSubview:view];
            [UIView animateWithDuration:0.2 animations:^{
                [view setAlpha:0.2];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    [view setAlpha:0];
                    [view removeFromSuperview];
                }];
            }];

            
            if(self.linkBlock){
                self.linkBlock(data);
            }
            
            if(self.delegate){
                [self.delegate didSelectedLink:data];
            }

            return;
        }
    }

 }



- (void)drawRect:(CGRect)rect{
    [self.linkDataArray removeAllObjects];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(context);
    CTTypesetterRef   typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)
                                                                          (self.showAttributedString));
    
    CGContextScaleCTM(context, 1, -1);
    CGFloat width = CGRectGetWidth(self.frame);
    float lineSize  = [self.font pointSize];
    
//    NSAttributedString *str = self.showAttributedString;
    
    CGFloat y = -lineSize;
    CFIndex start = 0;
    NSInteger length = [self.showAttributedString length];
    while (start < length)
    {
        //性能浪费很多的点
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, width);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        CGContextSetTextPosition(context, 0, y);
        
        // 画字
        CTLineDraw(line, context);
        
        
        [self ProcessLink:context andLine:line andCGpoint:CGPointMake(0, y)];
        
        start += count;
        y -= lineSize+kTextPadding  ;//+ 2;
        CFRelease(line);
    }
    if(typesetter){
         CFRelease(typesetter);
    }
    
    UIGraphicsPopContext();
}

-(void)ProcessLink:(CGContextRef) context andLine:(CTLineRef) line andCGpoint:(CGPoint) lineOrigin{
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    
    // 统计有多少个run
    NSUInteger count = CFArrayGetCount(runs);
    //   CGRect xxx = CTLineGetBoundsWithOptions(line, kCTLineBoundsExcludeTypographicLeading);
    id lastData;
    CGRect lastrect = CGRectZero;
    for(NSInteger i = 0; i < count; i++){
        
        CTRunRef aRun = CFArrayGetValueAtIndex(runs, i);
        CFDictionaryRef attributes = CTRunGetAttributes(aRun);
        id data = CFDictionaryGetValue(attributes, kLinkString);
        if (data){
            CGFloat ascent, descent;
            CGRect runBounds;
            float width = CTRunGetTypographicBounds(aRun, CFRangeMake(0, 0), &ascent, &descent, NULL);
            if([lastData isEqual:data]){//连在一起的
                lastrect.size.width += width;
            }else{
                runBounds.size.width = width;
                runBounds.size.height = ascent + descent;
                float lineSize = [self.font pointSize]+1;
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(aRun).location, NULL); //9
                runBounds.origin.x = xOffset + 0;// self.frame.origin.x +
                runBounds.origin.y = -lineOrigin.y-lineSize;
                if(lastData){
                    NSMutableDictionary *dic= [NSMutableDictionary dictionary];
                    [dic setObject:lastData forKey: @"data"];
                    [dic setObject:NSStringFromCGRect(lastrect) forKey: @"rect"];
                    [self.linkDataArray addObject:dic];
                }
                lastData = data;
                lastrect = runBounds;

            }
           
        }
    }
    if(lastData){
        NSMutableDictionary *dic= [NSMutableDictionary dictionary];
        [dic setObject:lastData forKey: @"data"];
        [dic setObject:NSStringFromCGRect(lastrect) forKey: @"rect"];
        [self.linkDataArray addObject:dic];
    }
}

+(float)getContentHeight:(NSAttributedString *) showAttributedString preferedWidth:(float)preferedWidth andFontSize:(float )fontSize{
    CTTypesetterRef   typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)
                                                                          (showAttributedString));

    CGFloat width = preferedWidth;
//    if(preferedWidth >0){
//        width = preferedWidth;
//    }
    
    float lineSize = fontSize ;
    CGFloat y = -lineSize;
    CFIndex start = 0;
    NSInteger length = [showAttributedString length];
    while (start < length)
    {
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, width);
        start += count;
        y -= lineSize+kTextPadding  ;//+ 2;
        
    }
    if(typesetter){
        CFRelease(typesetter);
    }
    
    float h = -y-(lineSize+kTextPadding)+2;
    
    return h;

    return 0;
}
- (float )getContentHeight{
    float preferedWidth = self.preferredMaxLayoutWidth;
    CGFloat width = CGRectGetWidth(self.frame);
    if(preferedWidth >0){
        width = preferedWidth;
    }
    return [CommentLabel getContentHeight:self.showAttributedString preferedWidth:width andFontSize:self.font.pointSize];
}

-(CGSize)intrinsicContentSize{
    return  CGSizeMake( CGRectGetWidth(self.frame), [self getContentHeight]);
}


-(CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake( CGRectGetWidth(self.frame), [self getContentHeight]);
}

#pragma mark --  copy 复制的逻辑







//- (void)copyText {
//    UIPasteboard *board = [UIPasteboard generalPasteboard];
//    NSArray *array = [self.text componentsSeparatedByString:@"："];
//    NSMutableString *string = [NSMutableString string];
//    if (array.count > 1) {
//        for (int i = 1 ; i < array.count; i++) {
//            [string appendString:array[i]];
//        }
//    } else {
//        string = [array firstObject];
//    }
//    board.string = string;
//}

@end
