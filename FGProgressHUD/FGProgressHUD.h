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
//ARC/MRC

typedef NS_ENUM(NSUInteger,FGProgressHUDMaskType) {
    FGProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    FGProgressHUDMaskTypeClear, // don't allow
    FGProgressHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
};



@interface FGProgressHUD : UIView

+ (void)show;
+ (void)showWithMaskType:(FGProgressHUDMaskType)maskType;

+ (void)dismiss;

+ (BOOL)isVisible;

@end
