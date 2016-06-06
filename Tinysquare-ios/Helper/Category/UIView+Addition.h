//
//  UIView+Addition.h

//
//

#import <UIKit/UIKit.h>

@interface UIView (ViewFrame)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
-(void) printRectLog:(NSString *)title;
- (UIViewController *)findViewController;


@end
