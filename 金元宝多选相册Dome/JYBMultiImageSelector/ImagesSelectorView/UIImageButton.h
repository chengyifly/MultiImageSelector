//
//  UIImageButton.h
//  JinYuanBao
//
//  Created by 易达正丰 on 14-4-18.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageButton : UIImageView

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
