//
//  FGProgress.h
//  FGProgressDemo
//
//  Created by wangzz on 14-6-28.
//  Copyright (c) 2014年 foogry. All rights reserved.
//

#import <UIKit/UIKit.h>

//支持横竖屏
//支持键盘弹出

@interface FGProgress : UIView

- (void)startAnimation;
- (void)removeAnimation;

- (void)show;

- (void)dismiss;

@property (nonatomic, assign) BOOL isAnimating;

@end
