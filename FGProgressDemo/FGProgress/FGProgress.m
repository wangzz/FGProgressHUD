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

#define KEY_ANIMATION_SCALE_REPEAT     @"animation.transform.repeat"
#define KEY_ANIMATION_SCALE_ONECE      @"animation.transform.once"


@interface FGProgress ()
{
    UIView          *_view;
    CGFloat         _radius;            //旋转的小圆圈最大半径
    CGFloat         _duration;          //旋转一圈所用时间
}

@end


@implementation FGProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _radius = 6;
        _duration = 1.5f;
        
        [self setup];
        
        [self startAnimation];
    }
    return self;
}

- (void)setup
{
    _view = [[UIView alloc] initWithFrame:CGRectMake(90, 90, 120, 120)];
    _view.backgroundColor = [UIColor clearColor];
    [self addSubview:_view];

    for (NSInteger index = 0; index < 8; index++) {
        CGFloat x = [self xCoordinateAtIndex:index];
        CGFloat y = [self yCoordinateAtIndex:index];
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(x, y, _radius*2, _radius*2)];
        subView.layer.cornerRadius = _radius;
        subView.layer.masksToBounds = YES;
        subView.backgroundColor = [UIColor colorWithRed:42.0f/255 green:121.0f/255 blue:251.0f/255 alpha:1.0f];
        
        CGFloat startScale = [self startScaleAtIndex:index];
        CATransform3D startTransform = CATransform3DMakeScale(startScale, startScale, 1.0f);
        subView.layer.transform = startTransform;
        
        [_view addSubview:subView];
    }
}

- (void)show
{
    
}

- (void)dismiss
{
    
}

#pragma mark - Animation
- (void)startAnimation
{
    for (NSInteger index = 0; index < _view.subviews.count; index++) {
        UIView *subView = [_view.subviews objectAtIndex:index];
        
        CAAnimation *repeatAnimation = [self repeatAnimationAtIndex:index];
        [subView.layer addAnimation:repeatAnimation forKey:KEY_ANIMATION_SCALE_REPEAT];
        
        if (index > 2) {
            CAAnimation *onceAnimation = [self onceAnimationAtIndex:index];
            [subView.layer addAnimation:onceAnimation forKey:KEY_ANIMATION_SCALE_ONECE];
        }
    }
    
    _isAnimating = YES;
}

- (void)removeAnimation
{
    for (UIView *subView in _view.subviews) {
        [subView.layer removeAnimationForKey:KEY_ANIMATION_SCALE_REPEAT];
        [subView.layer removeAnimationForKey:KEY_ANIMATION_SCALE_ONECE];
    }
    
    _isAnimating = NO;
}

- (CAAnimation *)repeatAnimationAtIndex:(NSInteger)index
{
    CFTimeInterval beginTime = CACurrentMediaTime() + 0.2f*index;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DIdentity],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)]];
    scaleAnimation.beginTime = beginTime;
    scaleAnimation.duration = _duration;
    scaleAnimation.repeatCount = INT_MAX;
    scaleAnimation.calculationMode = kCAAnimationLinear;
    
    return scaleAnimation;
}

- (CAAnimation *)onceAnimationAtIndex:(NSInteger)index
{
    CGFloat startScale = [self startScaleAtIndex:index];
    CATransform3D startTransform = CATransform3DMakeScale(startScale, startScale, 1.0f);
    CATransform3D middleTransform = [self transformMiddleAtIndex:index];
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:startTransform],[NSValue valueWithCATransform3D:middleTransform],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)]];
    scaleAnimation.duration = _duration*(2-[self startScaleAtIndex:index]);
    scaleAnimation.calculationMode = kCAAnimationLinear;
    scaleAnimation.fillMode = kCAFillModeRemoved;
    
    return scaleAnimation;
}

- (CGFloat)startScaleAtIndex:(NSInteger)index
{
    CGFloat startValue;
    switch (index) {
        case 7:
            startValue = 0.4f;
            break;
        case 6:
            startValue = 0.7f;
            break;
        case 5:
            startValue = 1.0f;
            break;
        case 4:
            startValue = 0.5f;
            break;
        case 3:
            startValue = 0.2f;
            break;
        default:
            startValue = 0;
            break;
    }
    
    return startValue;
}

- (CATransform3D)transformMiddleAtIndex:(NSInteger)index
{
    CATransform3D middleTransform;
    switch (index) {
        case 4:
            middleTransform = CATransform3DMakeScale(0.0f, 0.0f, 1.0f);
            break;
        case 3:
            middleTransform = CATransform3DMakeScale(0.0f, 0.0f, 1.0f);
            break;
        default:
            middleTransform = CATransform3DIdentity;
            break;
    }

    return middleTransform;
}

#pragma mark - Coordinate Calculation
- (CGFloat)xCoordinateAtIndex:(NSInteger)index
{
    CGFloat radian = DEGREE_TO_RADIAN(index*45);
    CGFloat x = (120.0f/2-_radius)*(1-cosf(radian));
    
    return x;
}

- (CGFloat)yCoordinateAtIndex:(NSInteger)index
{
    CGFloat radian = DEGREE_TO_RADIAN(index*45);
    CGFloat y = (120.0f/2-_radius)*(1-sinf(radian));
    
    return y;
}


@end
