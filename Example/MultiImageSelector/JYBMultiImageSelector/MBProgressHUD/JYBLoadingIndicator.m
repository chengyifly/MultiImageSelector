//
//  JYBLoadingIndicator.m
//  JinYuanBao
//
//  Created by 易达正丰 on 15/1/7.
//  Copyright (c) 2015年 newstep. All rights reserved.
//

#import "JYBLoadingIndicator.h"
#import "JYBMacros.h"

#define DEGREES_TO_RADIANS(x) (3.14159265358979323846 * x / 180.0)

@interface JYBLoadingIndicator ()

@property (nonatomic, assign) BOOL          isAnimated;
@property (nonatomic, strong) CAShapeLayer *shapeLayer1;
@property (nonatomic, strong) CAShapeLayer *shapeLayer2;

@end

@implementation JYBLoadingIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (void)removeFromSuperview
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}

- (void)sharedInit
{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
    iv.image = [UIImage imageNamed:@"loadingIndicator"];
    [self addSubview:iv];
    
    [self initShapeLayerNum:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAnimation) name:@"viewWillAppear" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)refreshAnimation
{
    [self.shapeLayer1 removeFromSuperlayer];
    [self.shapeLayer2 removeFromSuperlayer];
    [self initShapeLayerNum:1];
}

- (void)initShapeLayerNum:(NSInteger)num
{
    switch (num) {
        case 1:
            self.shapeLayer1 = [self layerInitWithColor:UIColorFromRGB(0xFF9B25)];
            break;
        case 2:
            self.shapeLayer2 = [self layerInitWithColor:UIColorFromRGB(0xFFE2C0)];
            break;
    }
}

- (CAShapeLayer *)layerInitWithColor:(UIColor *)color
{
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineWidth     = 1.7;
    shapeLayer.strokeColor   = color.CGColor;
    shapeLayer.fillColor     = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin      = kCALineJoinRound;
    shapeLayer.path          = [self createPath];
    [self.layer addSublayer:shapeLayer];
    
    CABasicAnimation *theStrokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    theStrokeAnimation.duration         = 1.5;
    theStrokeAnimation.fromValue        = @0.f;
    theStrokeAnimation.toValue          = @1.f;
    theStrokeAnimation.delegate         = self;
    [shapeLayer addAnimation:theStrokeAnimation forKey:@"shape"];

    return shapeLayer;
}

- (CGPathRef)createPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(14, 19) radius:4.5 startAngle:DEGREES_TO_RADIANS(120) endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(12, 11)];
    [path addLineToPoint:CGPointMake(32, 11)];
    [path addLineToPoint:CGPointMake(34.5, 19)];
    [path addArcWithCenter:CGPointMake(30, 19) radius:4.5 startAngle:0 endAngle:DEGREES_TO_RADIANS(70) clockwise:YES];
    [path addLineToPoint:CGPointMake(32, 33)];
    [path addLineToPoint:CGPointMake(12, 33)];
    [path addLineToPoint:CGPointMake(12, 23)];
    [path addArcWithCenter:CGPointMake(14, 19) radius:4.5 startAngle:DEGREES_TO_RADIANS(120) endAngle:DEGREES_TO_RADIANS(25) clockwise:NO];
    [path addArcWithCenter:CGPointMake(22, 19.5) radius:4 startAngle:DEGREES_TO_RADIANS(150) endAngle:DEGREES_TO_RADIANS(25) clockwise:NO];
    [path addArcWithCenter:CGPointMake(30, 19) radius:4.5 startAngle:DEGREES_TO_RADIANS(155) endAngle:DEGREES_TO_RADIANS(25) clockwise:NO];
    
    return path.CGPath;
}


#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        self.isAnimated = _isAnimated ? NO : YES;
        if (_isAnimated) {
            [self.shapeLayer2 removeFromSuperlayer];
            [self initShapeLayerNum:2];
        } else {
            [self.shapeLayer1 removeFromSuperlayer];
            [self initShapeLayerNum:1];
        }
    }
}




@end
