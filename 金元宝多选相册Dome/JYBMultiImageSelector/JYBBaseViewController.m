//
//  JYBBaseViewController.m
//  JinYuanBao
//
//  Created by 易达正丰 on 14-3-11.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import "JYBBaseViewController.h"
#import "MBProgressHUD.h"
#import "JYBLoading.h"
#import "JYBMacros.h"

@interface JYBBaseViewController () <UIGestureRecognizerDelegate, MBProgressHUDDelegate>
{
    JYBLoading *_Loading;
    
    UIOffset _plateOffset;
}

@end

@implementation JYBBaseViewController


#pragma mark -
#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _plateOffset = UIOffsetMake(0, -40);
    self.view.backgroundColor = UIColorFromRGB(0xFBF9F6);//(0xF0EFF4);
    [self initUI];
    [self setupNavUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"viewWillAppear" object:nil];
    StatusBarStyleDefault(NO)
    // 右滑返回手势
//    if (!iOS6)
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)dealloc
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"--- VC: %@ dealloc ---", NSStringFromClass([self class]));
}


/** ---------------------------------------------------------------------- **/
/*********************************** View ***********************************/
#pragma mark -
#pragma mark - View

- (void)initUI
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.delegate                = self;
    gestureRecognizer.cancelsTouchesInView    = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)setupNavUI
{
    if (!self.hideBackBtn) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"back_new"] forState:UIControlStateNormal];
        [backBtn sizeToFit];
        if (iOS6) backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}



/** --------------------------------------------------------------------- **/
/*********************************** Bar ***********************************/
#pragma mark -
#pragma mark - Controller

- (void)goBack
{
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}


/** -------------------------------------------------------------------------------- **/
/*********************************** Loading & Tips ***********************************/
#pragma mark -
#pragma mark - Control Tip
- (void)showLoadingStatus
{
    [self showLoadingStatusWithTipText:@"" inView:self.view plateOffset:_plateOffset];
}

/**
 *  显示加载视图
 *
 *  @param tip    nil/不显示提示 @""/显示默认提示 @"yourTips"/显示指定字符
 *  @param view   要加载到的视图
 *  @param offset 显示区域偏移量
 */
- (void)showLoadingStatusWithTipText:(NSString *)tip inView:(UIView *)view plateOffset:(UIOffset)offset{
    
    [self hideKeyboard];
    
    if (!_Loading || _Loading.superview == self.navigationController.view ) {
        [_Loading removeFromSuperview];
        _Loading = [[JYBLoading alloc]initWithView:view];
        _Loading.plateOffset = offset;
        [view addSubview:_Loading];
    }
    
    _Loading.type = JYBLoadingTypeLoading;
    
    if (tip) {
        _Loading.tips = tip;
        _Loading.type = StringIsNull(tip) ? JYBLoadingTypeLoadingTipsRoll : JYBLoadingTypeLoadingTips;
    }
    
    [_Loading show];
}

- (void)showLoadingStatusWithTipText:(NSString *)tip
{
    [self hideKeyboard];

    if (!_Loading) {
        
        _Loading = [[JYBLoading alloc]initWithView:self.view];
        _Loading.plateOffset = _plateOffset;
        [self.view addSubview:_Loading];
        
    }
    
    [_Loading refreshTipsWithText:tip];

}

- (void)hideLoadingStatus
{
    [_Loading hide];
}

- (void)showTip:(NSString *)content dismissDelay:(float)time
{
    [self hideKeyboard];
    [self hideLoadingStatus];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.delegate = self;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = content;
    
    [self performBlock:^{
        [self.view.window addSubview:hud];
        [hud show:YES];
    } afterDelay:0.2];
    
    [self performBlock:^{
        [hud hide:YES];
    } afterDelay:time+0.2];
}

#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
}



/**
 *  延时调用block
 */
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}



@end
