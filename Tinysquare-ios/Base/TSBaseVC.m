//
//  TSBaseVC.m
//  Tinysquare-ios
//
//  Created by aurora-IOS on 16/4/6.
//  Copyright © 2016年 xiezhaojun. All rights reserved.
//

#import "TSBaseVC.h"
#import "UIView+Addition.h"
#import "Common.h"
#import "TSUtilties.h"
@interface TSBaseVC ()
@property(nonatomic,strong)UIImageView *navBarHairlineImageView;
@property(nonatomic,strong) UIColor *barColor;
@property(nonatomic,assign) BOOL noLine;
@end

@implementation TSBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[TSUtilties getColorImage:MAIN_RED rect:CGRectMake(0, 0, kDeiveWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
   
}

-(void) setNoLineWithAllColor:(UIColor *)color titleColor:(UIColor *)titleColor{
    self.noLine = YES;
    [self setAllColor:color titleColor:titleColor];
}

-(void) setAllColor:(UIColor *)color titleColor:(UIColor *)titleColor{
    [self.navigationController.navigationBar setBackgroundImage:[TSUtilties getColorImage:color rect:CGRectMake(0, 0, kDeiveWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:titleColor];
    self.view.backgroundColor = color;
    self.barColor = color;
}



-(void)doTap{
    [self.view endEditing:YES];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navBarHairlineImageView.hidden = YES;
//    
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navBarHairlineImageView.hidden = NO;
//    [self.navigationController.navigationBar setBarTintColor:MAIN_RED];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if(self.needKeyboardUp){
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    }
    if(self.noLine){
        self.navBarHairlineImageView= [self findHairlineImageViewUnder:self.navigationController.navigationBar];
        self.navBarHairlineImageView.hidden = YES;
    }else{
        
    }
    
    if(self.barColor){
        
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_SIGLE(54),
                                                                         NSForegroundColorAttributeName,
                                                                         [UIFont systemFontOfSize:20],
                                                                         NSFontAttributeName, nil]];
          [[UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleDefault];
        [self.navigationController.navigationBar setTintColor:self.barColor];
//        self.navigationController.navigationBar.barStyle = UIStatusBarStyleBlackTranslucent;
//        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

        
        
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[TSUtilties getColorImage:MAIN_RED rect:CGRectMake(0, 0, kDeiveWidth, 64)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                                                              NSForegroundColorAttributeName,
                                                              [UIFont systemFontOfSize:20],
                                                              NSFontAttributeName, nil]];
        
         [[UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    if(self.barColor){
        return UIStatusBarStyleDefault;
    }else{
        return UIStatusBarStyleLightContent;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//     if(self.needKeyboardUp){
//         [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//         [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//     }
    self.navBarHairlineImageView.hidden = NO;
}

- (void)keyboardWillShow:(NSNotification*)notification{
    
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.top = -keyboardRect.size.height/2;
    }];
    
    
}
- (void)keyboardWillHide:(NSNotification*)notification{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.top = 0;
    }];
}
-(void) createRightBarTitle:(NSString *) btnTitle TitleColor:(UIColor *)color btnSize:(CGSize)btnSize
                     target:(UIViewController *) target select:(SEL)clichEvent{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, btnSize.width , btnSize.height)];
    [btn addTarget:target action:clichEvent forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.titleLabel.textAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f] forState:UIControlStateDisabled];
    //    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 9, 0,-9);
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    target.navigationItem.rightBarButtonItems = @[rightButtonItem];
    
}

-(void) createRightBarTitle:(NSString *) btnTitle btnSize:(CGSize)btnSize
                     target:(UIViewController *) target select:(SEL)clichEvent{
    [self createRightBarTitle:btnTitle TitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] btnSize:btnSize target:target select:clichEvent];
    
}

- (UIImageView*)findHairlineImageViewUnder:(UIView*)view {
    if([view isKindOfClass:UIImageView.class] && view.bounds.size.height<=1.0) {
        return(UIImageView*)view;
    }
    for(UIView *subview in view.subviews) {
        UIImageView*imageView = [self findHairlineImageViewUnder:subview];
        if(imageView) {
            return imageView;
        }
    }
    return nil;
}


-(void)doBack:(id) btn{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
