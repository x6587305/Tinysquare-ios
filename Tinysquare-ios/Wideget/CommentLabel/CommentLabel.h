//
//  CommentLabel.h
//  ContextTest
//
//  Created by aurora-IOS on 15/8/21.
//  Copyright (c) 2015年 aurora-IOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kLinkString @"link"
typedef void(^LinkBlock)(id data);
typedef NSString*(^CopyBlock)(NSString *text);
@protocol LingPro <NSObject>

-(void) didSelectedLink:(id) data;

@end
@interface CommentLabel : UILabel<UIGestureRecognizerDelegate>
@property (nonatomic,weak) id<LingPro> delegate;

-(void) addlLinkObject:(id) object andRange:(NSRange) range;
- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
-(void) setLinkBlock:(LinkBlock) lindBlock;

+(float)getContentHeight:(NSAttributedString *) showAttributedString preferedWidth:(float)preferedWidth andFontSize:(float )fontSize;
@end
