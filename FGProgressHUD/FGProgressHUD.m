//
//  FGProgressHUD.m
//  FGProgressHUDDemo
//
//  Created by wangzz on 14-6-30.
//  Copyright (c) 2014年 FOOGRY. All rights reserved.
//

#import "FGProgressHUD.h"


#define FG_M_PI                           3.14159265358979323846264338327950288
#define FG_DEGREE_TO_RADIAN(angle)        (angle * (FG_M_PI/180))

#define FG_RGBA(r,g,b,a)                  [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

#define FG_KEY_ANIMATION_SCALE            @"com.fgprogresshud.animation.transform"
#define FG_KEY_ANIMATION_COLOR            @"com.fgprogresshud.animation.color"

@interface FGProgressHUD ()
{
    CGFloat         _radius;            //旋转的小圆圈最大半径
    CGFloat         _cycleDuration;     //一个周期动画时间
    CGFloat         _hudWidth;          //HUD方形base view宽度
    NSUInteger      _hudSubviewCounts;  //HUD上的子view数目
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
    
    if (sharedView) {
        [[self class] dismiss];
    }
    
    sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]
                                    maskType:maskType
                                   shapeType:shapeType
                                    duration:duration];
    
    [sharedView startAnimation];
}

+ (void)dismiss
{
    NSAssert([NSThread isMainThread], ([NSString stringWithFormat:@"%s should running on main thread",__func__]));
    [self cancelPreviousPerformRequestsWithTarget:self
                                         selector:@selector(dismiss)
                                           object:nil];
    [sharedView stopAnimation];
    
    [sharedView.hudView removeFromSuperview];
    [sharedView removeFromSuperview];
    sharedView = nil;
}

+ (BOOL)isVisible
{
    return sharedView.isVisible;
}

#pragma mark - Dealloc
- (void)dealloc
{
    _hudView = nil;
    [self unregisterNotifications];
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
        _maskType = maskType;
        _shapeType = shapeType;
        _duration = duration;
        
        _radius = 6;
        _cycleDuration = 1.6f;
        _hudWidth = 120.0f;
        
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    if(!self.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self];
                break;
            }
    }
    
    switch (_shapeType) {
        case FGProgressHUDShapeCircle:
            _hudSubviewCounts = 8;
            [self setupCircleView];
            break;
        case FGProgressHUDShapeLinear:
            _hudSubviewCounts = 6;
            [self setupLinearView];
            break;
            
        default:
            break;
    }
    
    [self addSubview:self.hudView];
    
    if (self.maskType == FGProgressHUDMaskTypeNone) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
    } else if (self.maskType == FGProgressHUDMaskTypeBlack) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
}

- (void)setupCircleView
{
    for (NSInteger index = 0; index < _hudSubviewCounts; index++) {
        CGFloat x = [self xCoordinateAtIndex:index];
        CGFloat y = [self yCoordinateAtIndex:index];
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(x, y, _radius*2, _radius*2)];
        subView.layer.cornerRadius = _radius;
        subView.layer.masksToBounds = YES;
        subView.backgroundColor = FG_RGBA(42.0f, 121.0f, 251.0f, 1.0f);
        
        [self.hudView addSubview:subView];
    }
}

- (void)setupLinearView
{
    CGFloat y = (_hudWidth - _radius*2)/2;
    CGFloat xSace = (_hudWidth - _radius*2*_hudSubviewCounts)/(_hudSubviewCounts - 1);
    for (NSInteger index = 0; index < _hudSubviewCounts; index++) {
        CGFloat x = index*(xSace + _radius*2);
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(x, y, _radius*2, _radius*2)];
        subView.layer.cornerRadius = _radius;
        subView.layer.masksToBounds = YES;
        
        [self.hudView addSubview:subView];
    }
}

#pragma mark - Gets
- (UIView *)hudView
{
    if (!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.backgroundColor = [UIColor clearColor];
        _hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleLeftMargin);
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
    
    if (_duration > 0) {
        [[self class] performSelector:@selector(dismiss)
                           withObject:nil
                           afterDelay:_duration];
    }
}

- (void)startCircleAnimation
{
    for (NSInteger index = 0; index < self.hudView.subviews.count; index++) {
        UIView *subView = [self.hudView.subviews objectAtIndex:index];
        
        NSInteger i = self.hudView.subviews.count - 1;
        CFTimeInterval beginTime = CACurrentMediaTime() + (index - i)*(_cycleDuration/self.hudView.subviews.count);
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4f, 0.4f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7f, 0.7f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2f, 0.2f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 1.0f)]];
        scaleAnimation.beginTime = beginTime;
        scaleAnimation.duration = _cycleDuration;
        scaleAnimation.repeatCount = INT_MAX;
        scaleAnimation.calculationMode = kCAAnimationLinear;
        
        [subView.layer addAnimation:scaleAnimation forKey:FG_KEY_ANIMATION_SCALE];
    }
}

- (void)startLinearAnimation
{
    for (NSInteger index = 0; index < self.hudView.subviews.count; index++) {
        UIView *subView = [self.hudView.subviews objectAtIndex:index];
        
        NSInteger i = self.hudView.subviews.count - 1;
        CFTimeInterval beginTime = CACurrentMediaTime() + (index - i)*(_cycleDuration/self.hudView.subviews.count);
        
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7f, 0.7f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7f, 0.7f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7f, 0.7f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7f, 0.7f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.85f, 0.85f, 1.0f)]];
        scaleAnimation.beginTime = beginTime;
        scaleAnimation.duration = _cycleDuration;
        scaleAnimation.repeatCount = INT_MAX;
        scaleAnimation.calculationMode = kCAAnimationLinear;
        [subView.layer addAnimation:scaleAnimation forKey:FG_KEY_ANIMATION_SCALE];
        
        CAKeyframeAnimation *colorAnimation = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
        colorAnimation.values = @[(id)FG_RGBA(181.0f, 213.0f, 242.0f, 1.0f).CGColor,
                                  (id)FG_RGBA(181.0f, 213.0f, 242.0f, 1.0f).CGColor,
                                  (id)FG_RGBA(181.0f, 213.0f, 242.0f, 1.0f).CGColor,
                                  (id)FG_RGBA(181.0f, 213.0f, 242.0f, 1.0f).CGColor,
                                  (id)FG_RGBA(53.0f, 136.0f, 244.0f, 1.0f).CGColor,
                                  (id)FG_RGBA(110.0f, 172.0f, 244.0f, 1.0f).CGColor,
                                  ];
        colorAnimation.beginTime = beginTime;
        colorAnimation.duration = _cycleDuration;
        colorAnimation.repeatCount = INT_MAX;
        colorAnimation.calculationMode = kCAAnimationLinear;
        [subView.layer addAnimation:colorAnimation forKey:FG_KEY_ANIMATION_COLOR];
    }
}

- (void)stopAnimation
{
    for (UIView *subView in self.hudView.subviews) {
        [subView.layer removeAllAnimations];
    }
    
    _isVisible = NO;
}


#pragma mark - Coordinate Calculation
- (CGFloat)xCoordinateAtIndex:(NSInteger)index
{
    CGFloat radian = FG_DEGREE_TO_RADIAN(index*45);
    CGFloat x = (_hudWidth/2-_radius)*(1-cosf(radian));
    
    return x;
}

- (CGFloat)yCoordinateAtIndex:(NSInteger)index
{
    CGFloat radian = FG_DEGREE_TO_RADIAN(index*45);
    CGFloat y = (_hudWidth/2-_radius)*(1-sinf(radian));
    
    return y;
}

#pragma mark - Notifications
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    if (!self.superview) {
        return;
    }
    
    [self setTransformForCurrentOrientation:YES];
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
    if (!self.superview) {
        return;
    }

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat rotateAngle;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            rotateAngle = 0.0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI/2.0f;
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            break;
        default:
            break;
    }
    
    CGFloat x = (self.frame.size.width - _hudWidth)/2;
    CGFloat y = (self.frame.size.height - _hudWidth)/2;
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
    }
    
    _hudView.frame = CGRectMake(x, y, _hudWidth, _hudWidth);
    _hudView.transform = CGAffineTransformMakeRotation(rotateAngle);
    
    if (animated) {
        [UIView commitAnimations];
    }
}

@end
