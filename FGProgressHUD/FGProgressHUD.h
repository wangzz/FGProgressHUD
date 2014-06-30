//
//  FGProgressHUD.h
//  FGProgressHUDDemo
//
//  Created by wangzz on 14-6-30.
//  Copyright (c) 2014年 FOOGRY. All rights reserved.
//

#import <UIKit/UIKit.h>

//TODO:
//支持横竖屏
//支持键盘弹出

@interface FGProgressHUD : UIView

- (void)startAnimation;
- (void)removeAnimation;

- (void)show;

- (void)dismiss;

@property (nonatomic, assign) BOOL isAnimating;


@end
