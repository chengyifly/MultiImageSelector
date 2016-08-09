//
//  JYBBaseViewController.h
//  JinYuanBao
//
//  Created by 易达正丰 on 14-3-11.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYBBaseViewController : UIViewController

//回调block
typedef void (^JYBFinishBlock)(id parameter);

@property (nonatomic, copy  ) JYBFinishBlock dofinish;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL noData;
@property (nonatomic, assign) BOOL error;
@property (nonatomic, assign) BOOL hideBackBtn;

- (void)setupNavUI;

- (void)showLoadingStatus;
- (void)showLoadingStatusWithTipText:(NSString *)tip;
- (void)showLoadingStatusWithTipText:(NSString *)tip inView:(UIView *)view plateOffset:(UIOffset)offset;
- (void)hideLoadingStatus;

- (void)showTip:(NSString *)content dismissDelay:(float)time;

- (void)hideKeyboard;

- (void)goBack;


@end
