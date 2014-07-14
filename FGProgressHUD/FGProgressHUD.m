//
//  FGProgressHUD.m
//  FGProgressHUDDemo
//
//  Created by wangzz on 14-6-30.
//  Copyright (c) 2014年 FOOGRY. All rights reserved.
//

#import "FGProgressHUD.h"

#define FG_DIAMETER_FLOAT_VALUE     120.0f

#define FG_M_PI 3.14159265358979323846264338327950288
#define FG_DEGREE_TO_RADIAN(angle) (angle * (FG_M_PI/180))

#define FG_KEY_ANIMATION_SCALE_REPEAT     @"animation.transform.repeat"
#define FG_KEY_ANIMATION_SCALE_ONECE      @"animation.transform.once"





@interface FGProgressHUD ()
{
    CGFloat         _radius;            //旋转的小圆圈最大半径
    CGFloat         _cycleDuration;     //旋转一个周期所用时间
}

@property (nonatomic, assign) BOOL isVisible;

@property (nonatomic, assign) FGProgressHUDMaskType maskType;

@property (nonatomic, assign) FGProgressHUDShapeType shapeType;

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, strong) UIView *hudView;

@end

static FGProgressHUD *sharedView;

@implementation FGProgressHUD

#pragma mark - Public
+ (void)show
{
    [[self class] showWithDuration:0];
}

+ (void)showWithDuration:(NSTimeInterval)duration
{
    [[self class] showWithMaskType:FGProgressHUDMaskTypeNone duration:duration];
}

+ (void)showWithMaskType:(FGProgressHUDMaskType)maskType
{
    [[self class] showWithMaskType:maskType duration:0];
}

+ (void)showWithMaskType:(FGProgressHUDMaskType)maskType
                duration:(NSTimeInterval)duration
{
    [[self class] showWithMaskType:maskType
                         shapeType:FGProgressHUDShapeCircle
                          duration:duration];
}

+ (void)showWithShapeType:(FGProgressHUDShapeType)shapeType
{
    [[self class] showWithShapeType:shapeType duration:0];
}

+ (void)showWithShapeType:(FGProgressHUDShapeType)shapeType
                 duration:(NSTimeInterval)duration
{
    [[self class] showWithMaskType:FGProgressHUDMaskTypeNone
                         shapeType:shapeType
                          duration:duration];
}

+ (void)showWithMaskType:(FGProgressHUDMaskType)maskType
               shapeType:(FGProgressHUDShapeType)shapeType
{
    [[self class] showWithMaskType:maskType shapeType:shapeType duration:0];
}

+ (void)showWithMaskType:(FGProgressHUDMaskType)maskType
               shapeType:(FGProgressHUDShapeType)shapeType
                duration:(NSTimeInterval)duration
{
    NSAssert([NSThread isMainThread], ([NSString stringWithFormat:@"%s should running on main thread",__func__]));
    
    sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]
                                    maskType:maskType
                                   shapeType:shapeType
                                    duration:duration];
    
    [sharedView startAnimation];
}



+ (void)dismiss
{
    NSAssert([NSThread isMainThread], ([NSString stringWithFormat:@"%s should running on main thread",__func__]));
    
    [sharedView stopAnimation];
    
    [sharedView.hudView removeFromSuperview];
    [sharedView removeFromSuperview];
    sharedView = nil;
}

+ (BOOL)isVisible
{
    return sharedView.isVisible;
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self registerNotifications];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
           maskType:(FGProgressHUDMaskType)maskType
          shapeType:(FGProgressHUDShapeType)shapeType
           duration:(NSTimeInterval)duration
{
    self = [self initWithFrame:frame];
    if (self) {
        
        _radius = 6;
        _cycleDuration = 1.5f;
        
        _maskType = maskType;
        _shapeType = shapeType;
        _duration = duration;
        
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    switch (_shapeType) {
        case FGProgressHUDShapeCircle:
            [self setupCircleView];
            break;
        case FGProgressHUDShapeLinear:
            [self setupLinearView];
            break;
            
        default:
            break;
    }
    
    [self addSubview:self.hudView];
    self.backgroundColor = [UIColor clearColor];
    
    if(!self.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows)
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self];
                break;
            }
    }
    
    if (self.maskType == FGProgressHUDMaskTypeNone) {
        self.userInteractionEnabled = NO;
    } else if (self.maskType == FGProgressHUDMaskTypeBlack) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
}

- (void)setupCircleView
{
    for (NSInteger index = 0; index < 8; index++) {
        CGFloat x = [self xCoordinateAtIndex:index];
        CGFloat y = [self yCoordinateAtIndex:index];
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(x, y, _radius*2, _radius*2)];
        subView.layer.cornerRadius = _radius;
        subView.layer.masksToBounds = YES;
        subView.backgroundColor = [UIColor colorWithRed:42.0f/255 green:121.0f/255 blue:251.0f/255 alpha:1.0f];
        
        CGFloat startScale = [self circleStartScaleAtIndex:index];
        CATransform3D startTransform = CATransform3DMakeScale(startScale, startScale, 1.0f);
        subView.layer.transform = startTransform;
        
        [self.hudView addSubview:subView];
    }
}

- (void)setupLinearView
{
    CGFloat y = (FG_DIAMETER_FLOAT_VALUE - _radius*2)/2;
    CGFloat xSace = (FG_DIAMETER_FLOAT_VALUE - _radius*2*6)/5;
    for (NSInteger index = 0; index < 6; index++) {
        CGFloat x = index*(xSace + _radius*2);
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(x, y, _radius*2, _radius*2)];
        subView.backgroundColor = [UIColor redColor];
        self.hudView.backgroundColor = [UIColor greenColor];
        [self.hudView addSubview:subView];
    }
}

- (void)dealloc
{
    self.hudView = nil;
    [self unregisterNotifications];
}

#pragma mark - Gets
- (UIView *)hudView
{
    if (!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.backgroundColor = [UIColor clearColor];
        _hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        [self setTransformForCurrentOrientation:NO];
    }
    
    return _hudView;
}

#pragma mark - Animation
- (void)startAnimation
{
    switch (_shapeType) {
        case FGProgressHUDShapeCircle:
            [self startCircleAnimation];
            break;
        case FGProgressHUDShapeLinear:
            [self startLinearAnimation];
            break;
        default:
            break;
    }
    
    _isVisible = YES;
}

- (void)startCircleAnimation
{
    for (NSInteger index = 0; index < self.hudView.subviews.count; index++) {
        UIView *subView = [self.hudView.subviews objectAtIndex:index];
        
        CAAnimation *repeatAnimation = [self circleRepeatAnimationAtIndex:index];
        [subView.layer addAnimation:repeatAnimation forKey:FG_KEY_ANIMATION_SCALE_REPEAT];
        
        if (index > 2) {
            CAAnimation *onceAnimation = [self circleOnceAnimationAtIndex:index];
            [subView.layer addAnimation:onceAnimation forKey:FG_KEY_ANIMATION_SCALE_ONECE];
        }
    }
}


- (void)startLinearAnimation
{
    for (NSInteger index = 0; index < self.hudView.subviews.count; index++) {
        UIView *subView = [self.hudView.subviews objectAtIndex:index];
        CFTimeInterval beginTime = CACurrentMediaTime() + 0.2f*index;
        
        NSValue *start = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)];
        NSValue *middle = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        NSValue *end = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)];
        
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.values = @[start,middle,end];
        scaleAnimation.beginTime = beginTime;
        scaleAnimation.duration = _cycleDuration;
        scaleAnimation.repeatCount = INT_MAX;
        scaleAnimation.calculationMode = kCAAnimationLinear;
        
        [subView.layer addAnimation:scaleAnimation forKey:FG_KEY_ANIMATION_SCALE_REPEAT];
    }
}

- (void)stopAnimation
{
    for (UIView *subView in self.hudView.subviews) {
        [subView.layer removeAllAnimations];
    }
    
    _isVisible = NO;
}

- (CAAnimation *)circleRepeatAnimationAtIndex:(NSInteger)index
{
    CFTimeInterval beginTime = CACurrentMediaTime() + 0.2f*index;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DIdentity],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)]];
    scaleAnimation.beginTime = beginTime;
    scaleAnimation.duration = _cycleDuration;
    scaleAnimation.repeatCount = INT_MAX;
    scaleAnimation.calculationMode = kCAAnimationLinear;
    
    return scaleAnimation;
}

- (CAAnimation *)circleOnceAnimationAtIndex:(NSInteger)index
{
    CGFloat startScale = [self circleStartScaleAtIndex:index];
    CATransform3D startTransform = CATransform3DMakeScale(startScale, startScale, 1.0f);
    CATransform3D middleTransform = [self circleTransformMiddleAtIndex:index];
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:startTransform],[NSValue valueWithCATransform3D:middleTransform],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)]];
    scaleAnimation.duration = _cycleDuration*(2-startScale);
    scaleAnimation.calculationMode = kCAAnimationLinear;
    scaleAnimation.fillMode = kCAFillModeRemoved;
    
    return scaleAnimation;
}

- (CGFloat)circleStartScaleAtIndex:(NSInteger)index
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

- (CATransform3D)circleTransformMiddleAtIndex:(NSInteger)index
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
    CGFloat radian = FG_DEGREE_TO_RADIAN(index*45);
    CGFloat x = (FG_DIAMETER_FLOAT_VALUE/2-_radius)*(1-cosf(radian));
    
    return x;
}

- (CGFloat)yCoordinateAtIndex:(NSInteger)index
{
    CGFloat radian = FG_DEGREE_TO_RADIAN(index*45);
    CGFloat y = (FG_DIAMETER_FLOAT_VALUE/2-_radius)*(1-sinf(radian));
    
    return y;
}

#pragma mark - Notifications
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIView *superview = self.superview;
    if (!superview) {
        return;
    } else {
        [self setTransformForCurrentOrientation:YES];
    }
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
    if (self.superview) {
        self.frame = CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height);
        [self setNeedsDisplay];
    }
    
    CGFloat size = FG_DIAMETER_FLOAT_VALUE;
    CGFloat x = (self.bounds.size.width - size)/2;
    CGFloat y = (self.bounds.size.height - size)/2;
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
    }
    
    _hudView.frame = CGRectMake(x, y, size, size);
    
    if (animated) {
        [UIView commitAnimations];
    }
}


@end
