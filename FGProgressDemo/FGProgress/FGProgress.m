//
//  FGProgress.m
//  FGProgressDemo
//
//  Created by wangzz on 14-6-28.
//  Copyright (c) 2014年 foogry. All rights reserved.
//

#import "FGProgress.h"

#define M_PI 3.14159265358979323846264338327950288
#define DEGREE_TO_RADIAN(angle) (angle * (M_PI/180))

@interface FGProgress ()
{
    UIView *_view;
    CGFloat _radius;
}

@end


@implementation FGProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _radius = 10;
        
        [self setup];
        
//        [self startAnimation];
    }
    return self;
}

- (void)setup
{
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    _view.backgroundColor = [UIColor clearColor];
    [self addSubview:_view];

    for (NSInteger count = 0; count < 6; count++) {
        CGFloat xAxis = [self xAxisAtIndex:count];
        CGFloat yAxis = [self yAxisAtIndex:count];
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(xAxis, yAxis, _radius*2, _radius*2)];
        subView.layer.cornerRadius = _radius;
        subView.layer.masksToBounds = YES;
        subView.backgroundColor = [UIColor colorWithRed:42.0f/255 green:121.0f/255 blue:251.0f/255 alpha:1.0f];
        [_view addSubview:subView];
    }
}

#pragma mark - Animation
- (void)transformViewScale:(UIView *)view atIndex:(NSInteger)index
{
    CATransform3D fromTransform;
    CATransform3D toTransform;
    CFTimeInterval beginTime = CACurrentMediaTime();
    switch (index) {
        case 0:
            fromTransform = CATransform3DMakeScale(0.3f, 0.3f, 1.0f);
            toTransform = CATransform3DMakeScale(0.05f, 0.05f, 1.0f);
            break;
        case 1:
            fromTransform = CATransform3DIdentity;
            toTransform = CATransform3DMakeScale(0.4f, 0.4f, 1.0f);
            beginTime += 0.2f;
            break;
        case 2:
            fromTransform = CATransform3DIdentity;
            toTransform = CATransform3DIdentity;
            break;
        case 3:
            fromTransform = CATransform3DIdentity;
            toTransform = CATransform3DMakeScale(0.4f, 0.4f, 1.0f);
            beginTime += 0.4f;
            break;
        case 4:
            fromTransform = CATransform3DIdentity;
            toTransform = CATransform3DMakeScale(0.4f, 0.4f, 1.0f);
            beginTime += 0.8f;
            break;
        case 5:
            fromTransform = CATransform3DMakeScale(0.3f, 0.3f, 1.0f);
            toTransform = CATransform3DMakeScale(0.0f, 0.0f, 1.0f);
            beginTime += 0.2f;
            break;
            
        default:
            fromTransform = CATransform3DIdentity;
            toTransform = CATransform3DIdentity;
            break;
    }
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:fromTransform],[NSValue valueWithCATransform3D:toTransform],[NSValue valueWithCATransform3D:fromTransform]];
    scaleAnimation.beginTime = beginTime;
    scaleAnimation.duration = 2.0f;
    scaleAnimation.repeatCount = FLT_MAX;
    [view.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)startAnimation
{
    //旋转动画
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI];
    rotationAnimation.duration = 2.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = FLT_MAX;
    [_view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    //缩放动画
    for (NSInteger index = 0; index < _view.subviews.count; index++) {
        UIView *subView = [_view.subviews objectAtIndex:index];
        [self transformViewScale:subView atIndex:index];
    }
    
    _isAnimating = YES;
}

- (void)removeAnimation
{
    [_view.layer removeAnimationForKey:@"rotationAnimation"];

    for (UIView *subView in _view.subviews) {
        [subView.layer removeAnimationForKey:@"scaleAnimation"];
    }
    
    _isAnimating = NO;
}

- (CGFloat)xAxisAtIndex:(NSInteger)index
{
    CGFloat radian = DEGREE_TO_RADIAN(index*45);
    CGFloat x = (300.0f/2-_radius)*(1-cosf(radian));
    
    return x;
}

- (CGFloat)yAxisAtIndex:(NSInteger)index
{
    CGFloat radian = DEGREE_TO_RADIAN(index*45);
    CGFloat y = (300.0f/2-_radius)*(1-sinf(radian));
    
    return y;
}

- (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetRGBStrokeColor(context,10,10,10,1.0);//画笔线的颜色
//    CGContextSetLineWidth(context, 1.0);//线的宽度
//    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
//    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
//    CGContextAddArc(context, 150, 150, 150-_radius, 0, 2*M_PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
}


@end
