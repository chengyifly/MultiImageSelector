//
//  JYBLoading.m
//  JinYuanBao
//
//  Created by yanchen on 15/1/4.
//  Copyright (c) 2015年 newstep. All rights reserved.
//

#import "JYBLoading.h"
#import "JYBLoadingIndicator.h"
#import "JYBMacros.h"
#import "UIView+Ext.h"

@interface JYBLoading ()

@property (nonatomic, strong)UIView *mask_View;                //蒙层
@property (nonatomic, strong)UIView *plate_View;               //平台
@property (nonatomic, strong)JYBLoadingIndicator *indicator;   //指示器

@property (atomic, strong)NSDate *showStarted;
@property (nonatomic)CGFloat retainTime;               //初始提示保持时间

@property (atomic, strong)NSTimer *startRollTimer;
@property (atomic, strong)NSTimer *rollTimer;

@end

@implementation JYBLoading

const static CGFloat maskBackAlpha     = 0.3f;
const static CGFloat plateCornerRadius = 5;

#pragma mark -
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds  = YES;
        _mask_View                 = [[UIView alloc]initWithFrame:frame];
        _mask_View.backgroundColor = [UIColor blackColor];
        _mask_View.alpha           = maskBackAlpha;
        
        _plate_View  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 208, 102)];
        _plate_View.backgroundColor = [UIColor whiteColor];
        
        
        _plate_View.layer.cornerRadius  = plateCornerRadius;
        _plate_View.layer.masksToBounds = YES;
        
        _indicator = [[JYBLoadingIndicator alloc]initWithFrame:CGRectMake((_plate_View.frame.size.width-44)/2.0, 14, 44, 44)];
        
        self.minShowTime = 0.0f;
        self.retainTime  = 0.7f;
        
        self.hidden = YES;
        self.alpha  = 0;
        
        [self.plate_View addSubview:_indicator];
        [self addSubview:_mask_View];
        [self addSubview:_plate_View];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    CGRect frame = self.superview.bounds;
    self.frame       = frame;
    _mask_View.frame = frame;
    _plate_View.center = CGPointMake(frame.size.width/2.0f+self.plateOffset.horizontal,frame.size.height/2.0f+self.plateOffset.vertical);
    
}

#pragma mark - Interface
- (instancetype)initWithView:(UIView *)view{
    NSAssert(view, @"loading: inView must not be nil");
    return [self initWithFrame:view.bounds];
}

- (void)show{
    
    [self refreshSubviews];
    if (self.hidden == NO && self.alpha == 1) {
        return;
    }
    
    self.showStarted = [NSDate date];
    self.hidden      = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha  = 1;
    } completion:nil];
    
    if (self.type == JYBLoadingTypeLoadingTipsRoll) {
        //提示 滚动
        NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:self.showStarted];
        self.startRollTimer = [NSTimer scheduledTimerWithTimeInterval:(self.retainTime - interv) target:self selector:@selector(handleStartRollingTips) userInfo:nil repeats:NO];
    }else{
        
        [self.startRollTimer invalidate];
        [self.rollTimer invalidate];
        self.startRollTimer = self.rollTimer = nil;
    }
    
}
- (void)hide{
    
    if (self.minShowTime > 0.0 && _showStarted) {
        NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:_showStarted];
        if (interv < self.minShowTime) {
        [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv) target:self
                                                               selector:@selector(hideWithAnimation:) userInfo:nil repeats:NO];
            return;
        } 
    }
    
    [self hideWithAnimation:YES];
 
}

/*公开的接口,处理调用刷新提示时需要重置的*/
- (void)refreshTipsWithText:(NSString *)tips{
    if (_rollTimer || _startRollTimer) {
        [self.startRollTimer invalidate];
        [self.rollTimer invalidate];
        self.startRollTimer = self.rollTimer = nil;
    }
    self.type = JYBLoadingTypeLoadingTips;
    self.tips = tips;
    
    [self show];
    
}

#pragma mark - overWrite
- (NSString *)tips{
    if (StringIsNull(_tips)) {
        _tips = @"努力加载中...";
    }
    return _tips;
}

#pragma mark - logic
- (void)hideWithAnimation:(BOOL)animated{
    
    [self.startRollTimer invalidate];
    [self.rollTimer invalidate];
    self.startRollTimer = self.rollTimer = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha  = 0;
    } completion:^(BOOL finished) {
            self.hidden = YES;
    }];
}

- (void)handleStartRollingTips{
    self.rollTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(tipsRolling) userInfo:nil repeats:NO];
}

- (void)refreshSubviews{
    
    if (self.type != JYBLoadingTypeLoading) {
       
        if (!self.tips_LB) {
            self.tips_LB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
            self.tips_LB.numberOfLines = 0;
            self.tips_LB.font          = [UIFont systemFontOfSize:12];
            self.tips_LB.textColor     = UIColorFromRGB(0x999999);
            self.tips_LB.textAlignment = NSTextAlignmentCenter;
            
            [self.plate_View addSubview:self.tips_LB];
        }
        [self refreshTips];
        
    }
}


- (void)refreshTips{
    
    static CGFloat tipsOrginY = 70.0f;

    self.tips_LB.text   = self.tips;

    CGSize size         = [self.tips_LB sizeThatFits:CGSizeMake(187, MAXFLOAT)];
    self.tips_LB.size   = size;
    self.tips_LB.center = CGPointMake(_plate_View.bounds.size.width/2.0f, tipsOrginY+size.height/2.0f);
    
    //更新plate高度
    CGRect lframe         = self.plate_View.frame;
    CGFloat tipsMaxY      = CGRectGetMaxY(self.tips_LB.frame);
    lframe.size.height    = tipsMaxY > 102 ? tipsMaxY +10 : 102;
    self.plate_View.frame = lframe;
    
}

- (void)tipsRolling{
    NSArray *arr = @[
                     @"金元宝与你一起成长",
                     @"每天进步一点点",
                     @"唯有爱与梦想不可辜负",
                     @"金元宝严厉打击诈骗店铺",
                     @"贴士：设置佣金，让朋友一起推广",
                     @"贴士：没有商品？看看货源频道",
                     @"贴士：有口碑，才有回头客",
                     @"贴士：提现自动，2个工作日到账",
                     @"贴士：担保交易让买家购买更放心",
                     @"贴士：招代理？入驻货源频道",
                     @"贴士：商品可以上下架哦",
                     @"贴士：添加1元商品，体验下单流程",
                     @"贴士：支持支付宝、银行卡等支付",
                     @"贴士：运费可以自定义哦",
                     @"贴士：型号可以填写颜色尺寸规格",
                     @"贴士：访问BBS，与微商们共进"
                     ];
    self.tips = arr[arc4random()%(arr.count)];
    [self refreshTips];
}

@end
