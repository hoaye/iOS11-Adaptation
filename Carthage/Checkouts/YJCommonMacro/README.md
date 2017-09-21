# YJCommonMacro

[![Language](https://img.shields.io/badge/Language-Objective--C-00EE00.svg?style=flat)](https://github.com/YJManager/YJCommonMacro.git)
[![CocoaPods](https://img.shields.io/cocoapods/p/YJCommonMacro.svg?style=flat)](https://github.com/YJManager/YJCommonMacro.git)
[![CocoaPods](https://img.shields.io/cocoapods/v/YJCommonMacro.svg?style=flat)](https://github.com/YJManager/YJCommonMacro.git)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/YJManager/YJCommonMacro.git)
[![GitHub tag](https://img.shields.io/github/tag/YJManager/YJCommonMacro.svg?style=flat)](https://github.com/YJManager/YJCommonMacro.git)
[![license](https://img.shields.io/github/license/YJManager/YJCommonMacro.svg?style=flat)](https://github.com/YJManager/YJCommonMacro.git)

iOS Objective-C 开发常用的宏

## Adding YJCommonMacro to your project (添加 YJCommonMacro 到你的项目)

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add `YJCommonMacro` to your project.

1. Add a pod entry for `YJCommonMacro` to your Podfile </br>
```bash
    pod 'YJCommonMacro'
```
2. Install the pod(s) by running </br>
```bash
    pod install
```
3. Include `YJCommonMacro` wherever you need it with </br>
```bash
    #import <YJCommonMacro.h>
```

### Carthage

1. Add YJCommonMacro to your Cartfile. </br>
```bash
    github "YJManager/YJCommonMacro"
```
2. Run 
```bash
    carthage update
```
3. Follow the rest of the [standard Carthage installation instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to add YJCommonMacro to your project.

```objc
//------------------- 获取设备大小 -------------------------
#define kSCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define kNAVIGATION_BAR_HEIGHT   64.0f
#define kSTATUS_BAR_HEIGHT       20.0f

//////////// 版本 /////////////
#define kSYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
/** APP 版本号 */
#define kAPP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

////////// 方法宏 //////////////
#pragma mark - Funtion Method (宏 方法)

#define kIMAGE_NANMED(imgName) [UIImage imageNamed:imgName]
//读取本地图片 性能更高
#define kLOAD_IMAGE(file, ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
//获取当前语言
#define kCURRENT_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define kSYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define kSYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define kSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kSYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define kSYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/** 日志Log */
#ifdef DEBUG
#   define YJLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define YJLog(...)
#endif

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"Function:%s Line:%d\n Content:%s\n\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define YJAlertLog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define YJAlertLog(...)
#endif

//----------------------内存----------------------------

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

//-------------------- GCD -------------------------
//G－C－D
#define kGCD_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define kGCD_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//------------------- 转换 ---------------
//由角度获取弧度 有弧度获取角度
#define kDEGREES_TO_RADIAN(x) (M_PI * (x) / 180.0)
#define kRADIAN_TO_DEGREES(radian) (radian*180.0)/(M_PI)

//------------------ 单例 -----------------
//单例化一个类
#define kSYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}

//////////////////// 字体 ////////////////////////
/** 方正黑体简体字体定义 */
#define kFONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]
// 正常字体
#define F8  [UIFont systemFontOfSize:8]
#define F9  [UIFont systemFontOfSize:9]
#define F10 [UIFont systemFontOfSize:10]
#define F11 [UIFont systemFontOfSize:11]
#define F12 [UIFont systemFontOfSize:12]
#define F13 [UIFont systemFontOfSize:13]
#define F14 [UIFont systemFontOfSize:14]
#define F15 [UIFont systemFontOfSize:15]
#define F16 [UIFont systemFontOfSize:16]
#define F17 [UIFont systemFontOfSize:17]
#define F18 [UIFont systemFontOfSize:18]
#define F19 [UIFont systemFontOfSize:19]
#define F20 [UIFont systemFontOfSize:20]
#define F21 [UIFont systemFontOfSize:21]
#define F22 [UIFont systemFontOfSize:22]
#define F23 [UIFont systemFontOfSize:23]
#define F24 [UIFont systemFontOfSize:24]
#define F25 [UIFont systemFontOfSize:25]
#define F26 [UIFont systemFontOfSize:26]
#define F27 [UIFont systemFontOfSize:27]
#define F28 [UIFont systemFontOfSize:28]
#define F29 [UIFont systemFontOfSize:29]
#define F30 [UIFont systemFontOfSize:30]

// 粗体
#define FB8  [UIFont boldSystemFontOfSize:8]
#define FB9  [UIFont boldSystemFontOfSize:9]
#define FB10 [UIFont boldSystemFontOfSize:10]
#define FB11 [UIFont boldSystemFontOfSize:11]
#define FB12 [UIFont boldSystemFontOfSize:12]
#define FB13 [UIFont boldSystemFontOfSize:13]
#define FB14 [UIFont boldSystemFontOfSize:14]
#define FB15 [UIFont boldSystemFontOfSize:15]
#define FB16 [UIFont boldSystemFontOfSize:16]
#define FB17 [UIFont boldSystemFontOfSize:17]
#define FB18 [UIFont boldSystemFontOfSize:18]
#define FB19 [UIFont boldSystemFontOfSize:19]
#define FB20 [UIFont boldSystemFontOfSize:20]
#define FB21 [UIFont boldSystemFontOfSize:21]
#define FB22 [UIFont boldSystemFontOfSize:22]
#define FB23 [UIFont boldSystemFontOfSize:23]
#define FB24 [UIFont boldSystemFontOfSize:24]
#define FB25 [UIFont boldSystemFontOfSize:25]
#define FB26 [UIFont boldSystemFontOfSize:26]
#define FB27 [UIFont boldSystemFontOfSize:27]
#define FB28 [UIFont boldSystemFontOfSize:28]
#define FB29 [UIFont boldSystemFontOfSize:29]
#define FB30 [UIFont boldSystemFontOfSize:30]

///////////////// 常用颜色 //////////
#define black_color     [UIColor blackColor]
#define blue_color      [UIColor blueColor]
#define brown_color     [UIColor brownColor]
#define clear_color     [UIColor clearColor]
#define darkGray_color  [UIColor darkGrayColor]
#define darkText_color  [UIColor darkTextColor]
#define white_color     [UIColor whiteColor]
#define yellow_color    [UIColor yellowColor]
#define red_color       [UIColor redColor]
#define orange_color    [UIColor orangeColor]
#define purple_color    [UIColor purpleColor]
#define lightText_color [UIColor lightTextColor]
#define lightGray_color [UIColor lightGrayColor]
#define green_color     [UIColor greenColor]
#define gray_color      [UIColor grayColor]
#define magenta_color   [UIColor magentaColor]

// rgb颜色转换（16进制->10进制）
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 设置颜色RGB
#define kCOLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

/** 随机色 */
#define kRANDOM_COLOR [UIColor colorWithRed:((arc4random() % 255) / 255.0) green:((arc4random() % 255) / 255.0) blue:((arc4random() % 255) / 255.0) alpha:1]

/** 背景色 */
#define kBACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
/** 清除背景色 */
#define kCLEAR_COLOR [UIColor clearColor]
```
