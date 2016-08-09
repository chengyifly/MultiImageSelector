//
//  JYBLoading.h
//  JinYuanBao
//
//  Created by yanchen on 15/1/4.
//  Copyright (c) 2015年 newstep. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JYBLoadingType) {
    JYBLoadingTypeLoading,
    JYBLoadingTypeLoadingTips,
    JYBLoadingTypeLoadingTipsRoll
};

@interface JYBLoading : UIView

@property (nonatomic) JYBLoadingType type;

@property (nonatomic, strong) NSString *tips;         //提示
@property (nonatomic, strong) UILabel  *tips_LB;
@property (nonatomic) CGFloat  minShowTime;           //最少显示时间
@property (nonatomic) UIOffset plateOffset;

/**
 *  根据view的大小,创建实例.
 *
 *  @param view 参考view
 *
 *  @return 创建好的实例
 */
- (instancetype)initWithView:(UIView *)view;


- (void)show;

- (void)hide;
/**
 *  刷新提示
 *
 *  @param tips 提示文字
 */
- (void)refreshTipsWithText:(NSString *)tips;


@end
