FGProgressHUD
=============

FGProgressHUD是一个用于iOS平台的等待界面，具有使用简单，横竖屏的时候能够自动调整位置的特点。效果如下图所示：

<img src="/ScreenShort/FGProgressHUDShapeCircle.gif" width="320" height="480"> <img src="/ScreenShort/FGProgressHUDShapeLinear.gif" width="320" height="480" hspace=20> 

实现的过程中或多或少的参考了以下开源项目：

* [MBProgressHUD](https://github.com/jdg/MBProgressHUD)

* [SVProgressHUD](https://github.com/samvermette/SVProgressHUD)


##Requirements

* iOS 4.3 +

* Automatic Reference Counting (ARC)
 

##Usage

* 包含文件

	主文件为`FGProgressHUD.h`和`FGProgressHUD.m`，将上述文件包含到你的工程中即可。
	
* 调用接口

	接口以使用致简为原则，提供了以下对外接口：
```objective-c
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

```	


* 形状种类

	目前有两种形状：
```objective-c
typedef NS_ENUM(NSUInteger, FGProgressHUDShapeType) {
    FGProgressHUDShapeCircle, //circle HUD,it's the default value
    FGProgressHUDShapeLinear, //linear HUD
};
```

其中，

`FGProgressHUDShapeCircle`为原型的无限循环HUD，是`默认值`；

`FGProgressHUDShapeLinear`为水平直线型无限循环HUD；


* 背景种类

	背景共有三种类型：
```objective-c
typedef NS_ENUM(NSUInteger,FGProgressHUDMaskType) {
    FGProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    FGProgressHUDMaskTypeClear, // don't allow user interactions, it's the default value
    FGProgressHUDMaskTypeBlack, // don't allow user interactions and dim the UI in the back of the HUD
};

```
其中，

`FGProgressHUDMaskTypeNone`允许和HUD后面的界面交互，其余两个不允许交互，是`默认值`；
 
`FGProgressHUDMaskTypeBlack`会显示带黑色背景，其余两个背景为透明色；

`FGProgressHUDMaskTypeClear`无背景；


##License

本项目遵守 [MIT license](https://github.com/wangzz/FGProgressHUD/blob/master/LICENSE)

