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
    NSArray *_pointsArray;
    UIView *_view;
    CGFloat _radius;
    BOOL _isAnimating;
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
        
        [self startAnimation];
        
        _pointsArray = [self createPointsArray];
    }
    return self;
}

- (void)setup
{
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    _view.backgroundColor = [UIColor clearColor];
    [self addSubview:_view];

    for (NSInteger count = 0; count < 8; count++) {
        CGFloat xAxis = [self xAxisAtIndex:count];
        CGFloat yAxis = [self yAxisAtIndex:count];
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(xAxis, yAxis, _radius*2, _radius*2)];
        subView.layer.cornerRadius = _radius;
        subView.layer.masksToBounds = YES;
        subView.backgroundColor = [UIColor redColor];
        [self transformViewScale:subView atIndex:count];
        [_view addSubview:subView];
    }
}

#pragma mark - 动画相关方法

- (void)transformViewScale:(UIView *)view atIndex:(NSInteger)index
{
    
}

//开始旋转动画
- (void)startAnimation
{
    if (!_isAnimating) {
        _isAnimating = YES;
        [self spinTheHotWheel];
    }
}

//停止旋转动画
- (void)stopAnimation
{
    _isAnimating = NO;
}

- (void)spinTheHotWheel
{
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _view.transform = CGAffineTransformRotate(_view.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished && _isAnimating) {
                             [self spinTheHotWheel];
                         }
                     }];
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
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context,10,10,10,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, 150, 150, 150-_radius, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
}


- (NSArray *)createPointsArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    float duration = 1;
    NSInteger totalCount = 12;
    for (NSInteger count = 0; count < totalCount; count++) {
        [array addObject:[NSNumber numberWithFloat:count*duration/totalCount]];
    }
    
    return array;
}


//- (void)startAnimation
//{
//    [UIView animateWithDuration:0.5f animations:^{
//        if (_view.frame.size.width == 30) {
//            _view.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
//        } else {
//            _view.transform = CGAffineTransformMakeScale(1, 1);
//        }        
//    } completion:^(BOOL finished) {
//        [self performSelector:@selector(startAnimation)
//                   withObject:nil
//                   afterDelay:0.2f];
//    }];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
