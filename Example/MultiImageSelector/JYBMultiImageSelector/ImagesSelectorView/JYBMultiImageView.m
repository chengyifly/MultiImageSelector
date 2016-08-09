//
//  JYBMultiImageView.m
//  JinYuanBao
//
//  Created by 易达正丰 on 14/11/11.
//  Copyright (c) 2014年 newstep. All rights reserved.
//

#import "JYBMultiImageView.h"
#import "UIImageButton.h"
#import "JYBMacros.h"
#import "UIView+Ext.h"

@interface JYBMultiImageView ()

@property (nonatomic, strong) NSMutableArray *imageBtns_MARR;
@property (nonatomic, strong) UIImageView    *choosed_IV;
@property (nonatomic, assign) NSInteger      from;
@property (nonatomic, assign) NSInteger      to;

@end

@implementation JYBMultiImageView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self shareInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self shareInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self shareInit];
}

- (void)shareInit
{
    if (self.lineCount == 0) self.lineCount = 4;
    if (self.itemWidth == 0) self.itemWidth = 68*LayoutWidthRatio;
    if (self.maxItem == 0) self.maxItem = 12;
    
    self.images_MARR    = [NSMutableArray array];
    self.imageBtns_MARR = [NSMutableArray array];
    
    UILongPressGestureRecognizer *longPG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPG];
}

- (void)setImages_MARR:(NSMutableArray *)images_MARR
{
    _images_MARR = images_MARR;

    [self loadingImageView];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPG
{
    if (self.imageBtns_MARR.count) {
        
        CGPoint point = [longPG locationInView:self];
        
        switch ((int)longPG.state) {
            case UIGestureRecognizerStateBegan:
            {
                [self.imageBtns_MARR enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    UIImageButton *btn = obj;
                    if (CGRectContainsPoint(btn.frame, point)) {
                        btn.hidden                  = YES;
                        self.choosed_IV             = [[UIImageView alloc] initWithImage:btn.image];
                        self.choosed_IV.frame       = btn.frame;
                        self.choosed_IV.contentMode = UIViewContentModeScaleAspectFill;
                        self.choosed_IV.clipsToBounds = YES;
                        
                        [UIView animateWithDuration:0.2 animations:^{
                            self.choosed_IV.transform = CGAffineTransformMakeScale(1.3, 1.3);
                        }];
                        [self addSubview:self.choosed_IV];
                        self.from = idx;
                    }
                }];
            }
                break;
                
            case UIGestureRecognizerStateChanged:
            {
                self.choosed_IV.center = point;
                [self.imageBtns_MARR enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    UIImageButton *btn = obj;
                    if (CGRectContainsPoint(btn.frame, point)) {
                        *stop = YES;
                        self.to = idx;
                        if (self.from != self.to) {
                            UIImageButton *anotherBtn = self.imageBtns_MARR[self.from];
                            
                            if (stop) {
                                [self.imageBtns_MARR removeObject:anotherBtn];
                                [self.imageBtns_MARR insertObject:anotherBtn atIndex:self.to];
                            }
                            ((UIView *)self.imageBtns_MARR[self.to]).hidden = YES;
                            
                            UIImage *anotherImage = self.images_MARR[self.from];
                            [self.images_MARR removeObjectAtIndex:self.from];
                            [self.images_MARR insertObject:anotherImage atIndex:self.to];
                            
                            [self updateUIWithAnimated:YES];
                            self.from = self.to;
                        }
                    }
                }];
            }
                break;
                
            case UIGestureRecognizerStateEnded:
            {
                [self.choosed_IV removeFromSuperview];
                ((UIView *)self.imageBtns_MARR[self.from]).hidden = NO;
            }
                break;
        }
    }
}

- (void)loadingImageView
{
    // 每个item间隔
    CGFloat gap = fmodf(self.width, self.itemWidth)/(self.lineCount-1);
    
    [self.imageBtns_MARR removeAllObjects];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }

    // 显示的图片，用来排序的
    [self.images_MARR enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIImageButton *image_BTN  = [[UIImageButton alloc] initWithFrame:CGRectMake(0, 0, self.itemWidth, self.itemWidth)];
        image_BTN.tag             = idx;
        image_BTN.backgroundColor = [UIColor lightGrayColor];
        image_BTN.contentMode     = UIViewContentModeScaleAspectFill;
        
        // 判断传入的数组数据类型
        UIImage *jybImage = obj;
        if (jybImage)
            [image_BTN setImage:jybImage];
        
        [image_BTN addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:image_BTN];
        [self.imageBtns_MARR addObject:image_BTN];
    }];
    
    // 继续添加按钮
    if (self.images_MARR.count < self.maxItem) {
        
        UIButton *plus_BTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [plus_BTN setBackgroundImage:[UIImage imageNamed:@"goods_add_plus"] forState:UIControlStateNormal];
        plus_BTN.frame = CGRectMake(self.images_MARR.count%self.lineCount * (self.itemWidth+gap), self.images_MARR.count/self.lineCount * (self.itemWidth+gap), self.itemWidth, self.itemWidth);
        [plus_BTN addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plus_BTN];
        
        self.height = plus_BTN.bottom;
    }
    
    [self updateUIWithAnimated:NO];
}

/**
 *  更新图片显示顺序
 */
- (void)updateUIWithAnimated:(BOOL)animated
{
    // 每个item间隔
    CGFloat gap = fmodf(self.width, self.itemWidth)/(self.lineCount-1);
    // 显示的图片，用来排序的
    [self.imageBtns_MARR enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageButton *image_BTN = obj;
        image_BTN.tag = idx;
        [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
            image_BTN.frame = CGRectMake(idx%self.lineCount * (self.itemWidth+gap), idx/self.lineCount * (self.itemWidth+gap), self.itemWidth, self.itemWidth);
        }];
        if (idx >= self.maxItem-1) self.height = image_BTN.bottom;
    }];
}



#pragma mark - Control Action

- (void)addBtnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(addButtonDidTap)]) {
        [self.delegate addButtonDidTap];
    }
}

- (void)imageBtnAction:(UIImageButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(multiImageBtn:withImage:)]) {
        [self.delegate multiImageBtn:sender.tag withImage:sender.image];
    }
}



#pragma mark -
#pragma mark - Logic




@end

