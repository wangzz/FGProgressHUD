//
//  FGProgressHUD.h
//  FGProgressHUDDemo
//
//  Created by wangzz on 14-6-30.
//  Copyright (c) 2014年 FOOGRY. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,FGProgressHUDMaskType) {
    FGProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed,it's the default value
    FGProgressHUDMaskTypeClear, // don't allow user interactions
    FGProgressHUDMaskTypeBlack, // don't allow user interactions and dim the UI in the back of the HUD
};


typedef NS_ENUM(NSUInteger, FGProgressHUDShapeType) {
    FGProgressHUDShapeCircle, //circle HUD,it's the default value
    FGProgressHUDShapeLinear, //linear HUD
};


@interface FGProgressHUD : UIView

/**
 *  show method with default value FGProgressHUDMaskTypeNone 
 *  and FGProgressHUDShapeCircle.
 */
+ (void)show;
+ (void)showWithDuration:(NSTimeInterval)duration;

/**
 *  show method with default value FGProgressHUDShapeCircle.
 */
+ (void)showWithMaskType:(FGProgressHUDMaskType)maskType;
+ (void)showWithMaskType:(FGProgressHUDMaskType)maskType
                duration:(NSTimeInterval)duration;

/**
 *  show method with default value FGProgressHUDMaskTypeNone.
 */
+ (void)showWithShapeType:(FGProgressHUDShapeType)shapeType;
+ (void)showWithShapeType:(FGProgressHUDShapeType)shapeType
                 duration:(NSTimeInterval)duration;

+ (void)showWithMaskType:(FGProgressHUDMaskType)maskType
               shapeType:(FGProgressHUDShapeType)shapeType;
+ (void)showWithMaskType:(FGProgressHUDMaskType)maskType
               shapeType:(FGProgressHUDShapeType)shapeType
                duration:(NSTimeInterval)duration;

+ (void)dismiss;

+ (BOOL)isVisible;

@end
