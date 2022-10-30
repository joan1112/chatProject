//
//  CommonMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/31.
//  Copyright © 2017年 徐阳. All rights reserved.
//


#ifndef CommonMacros_h
#define CommonMacros_h




#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX KScreenWidth >=812.0f && KScreenHeight >=375.0f&& kIs_iphone
 
/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
//#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(40.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)

//释放定时器
#undef YH_INVALIDATE_TIMER
#define YH_INVALIDATE_TIMER(__TIMER) \
{\
[__TIMER invalidate];\
__TIMER = nil;\
}
// 按照效果图适应比例 iphone6尺寸
#define AutoWith(x) (x/375.0*[UIScreen mainScreen].bounds.size.width)
#define AutoHeight(x) (x/667.0*[UIScreen mainScreen].bounds.size.height)
#define ViewMaxX(v) CGRectGetMaxX(v.frame)
#define ViewMaxY(v) CGRectGetMaxY(v.frame)

#define kScaleX [UIScreen mainScreen].bounds.size.width / 375
#define kScaleY [UIScreen mainScreen].bounds.size.height / 667

//判断空字符串
#define NULLString(string) [CCAppHelper emptyString:string]
#define NULLCLASSString(string) ((string == nil) || [string isKindOfClass:[NSNull class]])
#define SafeString(string) [CCAppHelper safeString:string]
// 判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//状态栏的高度
#define Height_StatusBar ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 44.0 : 20.0)
//导航栏的高度
#define Height_NavBar ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 88.0 : 64.0)
//标签蓝的高度
#define Height_TabBar ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 83.0 : 49.0)
#define showIphoneXH (IS_IPHONE_X ? 34: 0)
//调试
#ifdef DEBUG
#define HFLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define HFLog(...)
#endif

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
//当前iOS版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//当前语言
//#define CurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])
//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//获取屏幕宽高
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height-812)?NO:YES)

#define Iphone6ScaleWidth KScreenWidth/375.0
#define Iphone6ScaleHeight KScreenHeight/667.0
//根据ip6的屏幕来拉伸
#define kRealValue(with) ((with)*(KScreenWidth/375.0f))
#define WIDTH6                  375.0
#define XX_6(value)             (1.0 * (value) * KScreenWidth / WIDTH6)
// 常用字体大小
#define Font_XX6(value)         [UIFont systemFontOfSize:ceil(XX_6(value))]

#ifdef __OBJC__
//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define Define_WeakSelf __weak __typeof(self) weakSelf = self;
#define Define_WeakObject(o) __weak typeof(o) weak##o = o;

#endif


//未读消息的数目
#define MessageCount @"setupUnreadMessageCount"
#define HFNotificationPost(postName) [[NSNotificationCenter defaultCenter]postNotificationName:postName object:nil]
//默认间距
#define KNormalSpace 12.0f
#define KLanguageKey @"myLanguage"

#pragma mark -  颜色区

#define RGB_COLOR(_STR_,a) ([UIColor colorWithRed:[[NSString stringWithFormat:@"%lu", strtoul([[_STR_ substringWithRange:NSMakeRange(1, 2)] UTF8String], 0, 16)] intValue] / 255.0 green:[[NSString stringWithFormat:@"%lu", strtoul([[_STR_ substringWithRange:NSMakeRange(3, 2)] UTF8String], 0, 16)] intValue] / 255.0 blue:[[NSString stringWithFormat:@"%lu", strtoul([[_STR_ substringWithRange:NSMakeRange(5, 2)] UTF8String], 0, 16)] intValue] / 255.0 alpha:a])

//颜色转换
#define rgb_color(r,g,b,a)  [UIColor colorWithRed:(float)r/255.f green:(float)g/255.f blue:(float)b/255.f  alpha:a]
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//主题色 导航栏颜色
#define CNavBgColor  kUIColorFromRGB(0x1E2934) 
//导航栏字体颜色
#define CNavBgFontColor  kUIColorFromRGB(0xffffff)
//默认页面背景色
#define CViewBgColor kUIColorFromRGB(0xF3F3F3)
//分割线颜色
#define CLineColor kUIColorFromRGB(0xFFE29E)
//main字色
#define CBTextColor kUIColorFromRGB(0x333333)
//main字色
#define CMTextColor kUIColorFromRGB(0x010101)
//次级字色
#define CTextColor kUIColorFromRGB(0x666666)
//再次级字色
#define CFontColor2 kUIColorFromRGB(0x5c5c5c)
// BLUE
#define CBlueColor kUIColorFromRGB(0x007AFF)
// inputBg
#define CInputBgColor kUIColorFromRGB(0xEEEEEE)
//随机色生成
#define kRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)

#define normalColors [UIColor colorWithRed:255/255.0 green:211/255.0 blue:80/255.0 alpha:1]

#pragma mark   -   字体
#define MYFONT(a)      [UIFont systemFontOfSize:a]
#define MYBOLDFONT(a)  [UIFont boldSystemFontOfSize:a]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

#pragma mark   -   图片
#define MYIMAGE(a)      [UIImage imageNamed:a]
#define ImageWithFile(_pointer) [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]

//数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

//设备尺寸相关
#define FiveInch ([UIScreen mainScreen].bounds.size.height == 568.0)
#define SixInch ([UIScreen mainScreen].bounds.size.height == 667.0)
#define SixPlusInch ([UIScreen mainScreen].bounds.size.height == 736.0)

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kNavBarHeight (kDevice_Is_iPhoneX ? 88.0 : 64.0)
#define kBottomBarHeight (kDevice_Is_iPhoneX ? 34.0 : 0)
#define kContentHeight (kScreenHeight - kNavBarHeight-kBottomBarHeight)
#define BottomSafeH  (KScreenHeight >= 812.0 ? 34 : 0)


//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  HFLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)


#define tokenway @"toekenWay"
#define rpcName @"rpcName"
#define rpcUrlKey @"rpc"
#define MCKEY @"VXWZFH4ZDVYIGDCA8V4ZCMHSCXJKSPHTXMUINWCP"


#pragma mark - ——————— 网络状态相关 ————————

//网络状态变化
#define KNotificationNetWorkStateChange @"KNotificationNetWorkStateChange"

//缓存视频地址
#define CACHE_PATH_LIST  @"CACHE_PATH_LIST"

#define angleValue(angle) ((angle) * M_PI / 180.0)//角度数值转换宏

//118.178.228.192:10001
//118.178.228.192:11000
//http://112.124.29.74:8077
#pragma mark - ——————— 数据请求 ————————
#ifdef DEBUG // 测试
#pragma mark ---测试环境下的地址---
#define mainServerURL @"http://112.124.29.74:8077"

#else// release
#pragma mark ---正试环境下的地址---
#define mainServerURL @"http://112.124.29.74:8077"
#endif

#pragma mark ----微信key
#define WEIXINSECRET            @"bd959360ef66ba5e369b142cabed8a6a"
#define WEIXINAPPID             @"wx3d8626a49fd8ea93"//微信

#define MyUIScreen  858
#define MyUIScreen1  340

#define SCALE                   KScreenWidth/MyUIScreen
#define NUM(s)                  (SCALE * s)
//Tide/ 发布
//Main/ 展示
#define ResourcePath @"Main/"
//#define ResourcePath @"Tide/"

#define bucket_name @"tide-scene"
//LTAI5tN2iehHzgE9bYaUoLQp
#define access_id @"LTAI5tNET4AdNyMYycKimmQd"
#define access_secret @"5qJCJ21aXi1DpxjFiC8jo8hBZbKVsh"
#define end_point @"oss-cn-shanghai.aliyuncs.com"
#endif /* CommonMacros_h */
