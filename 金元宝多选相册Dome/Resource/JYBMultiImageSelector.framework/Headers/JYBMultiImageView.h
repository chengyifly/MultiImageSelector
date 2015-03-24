//
//  JYBMultiImageView.h
//  JinYuanBao
//
//  Created by 易达正丰 on 14/11/11.
//  Copyright (c) 2014年 easymob.com.cn All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYBMultiImageViewDelegate;

@interface JYBMultiImageView : UIView

/**
 *  每个图片宽度，默认 = view宽度 / lineCount
 */
@property (nonatomic, assign) CGFloat        itemWidth;

/**
 *  每行显示个数，默认4个
 */
@property (nonatomic, assign) NSInteger      lineCount;

/**
 *  图片最多显示数，默认12个
 */
@property (nonatomic, assign) NSUInteger     maxItem;

/**
 *  存放要显示的图片数组[UIImage类型]
 */
@property (nonatomic, strong) NSMutableArray *images_MARR;

@property (nonatomic, weak) id <JYBMultiImageViewDelegate> delegate;

@end



@protocol JYBMultiImageViewDelegate <NSObject>

/**
 *  添加新图片“+”点击回调
 */
- (void)addButtonDidTap;

/**
 *  每张图片点击回调
 *
 *  @param index 图片位置的下标[和数组保持一致]
 *  @param image 被点击的图片
 */
- (void)multiImageBtn:(NSInteger)index withImage:(UIImage *)image;

@end
