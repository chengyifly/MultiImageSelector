//
//  UIImageButton.m
//  JinYuanBao
//
//  Created by 易达正丰 on 14-4-18.
//  Copyright (c) 2014年 Easymob.com.cn. All rights reserved.
//

#import "UIImageButton.h"

@interface UIImageButton ()
{
    UIControl *_clickControl;
    id  _target;
    SEL _action;
}

@end

@implementation UIImageButton

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _clickControl = [[UIControl alloc] initWithFrame:self.bounds];
        _clickControl.exclusiveTouch = NO;
        [self addSubview:_clickControl];
        self.clipsToBounds  = YES;
        self.contentMode    = UIViewContentModeScaleAspectFill;
    }
    return self;
}

#pragma mark -
#pragma mark - JYBImageButton
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    _target = target;
    _action = action;
    [_clickControl addTarget:self action:@selector(innerClick) forControlEvents:controlEvents];
}

- (void)innerClick
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    
}


@end
