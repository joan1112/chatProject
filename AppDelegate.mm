/****************************************************************************
 Copyright (c) 2010-2013 cocos2d-x.org
 Copyright (c) 2013-2016 Chukong Technologies Inc.
 Copyright (c) 2017-2018 Xiamen Yaji Software Co., Ltd.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
#include "AppDelegate.h"
#import "ViewController.h"
#include "platform/ios/View.h"

#include "Game.h"
#include "SDKWrapper.h"
#import "mains/LoginViewController.h"
#import <UMShare/UMShare.h>
#import "mains/GameManager.h"
#import "mains/base/CommonMacros.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "mains/MapResourceController.h"
#import "mains/base/User/UserManager.h"
#import "mains/ChooseModelController.h"
#import "ThirdParty/Category/UIView+Alert.h"
#import "mains/pages/LoginNewViewController.h"
#define AppKey @"66ae4ac4a5f3c7adcd22599cde18454e"
#import <NERtcCallKit/NERtcCallKit.h>

@implementation AppDelegate

//Game *      game = nullptr;
@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [[SDKWrapper shared] application:application didFinishLaunchingWithOptions:launchOptions];
    // Add the view controller's view to the window and display.
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window   = [[UIWindow alloc] initWithFrame:bounds];
//    if ([UserManager shraeUserManager].user.token&&[UserManager shraeUserManager].user.token.length>0&&[UserManager shraeUserManager].user.role&&[UserManager shraeUserManager].user.role.length>0) {
//        MapResourceController *map = [[MapResourceController alloc]init];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:map];
//        [self.window setRootViewController:nav];
//    }else if ([UserManager shraeUserManager].user.token&&[UserManager shraeUserManager].user.token.length>0){
//        ChooseModelController *map = [[ChooseModelController alloc]init];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:map];
//        [self.window setRootViewController:nav];
//
//    }else{
    LoginNewViewController *root = [[LoginNewViewController alloc]init];
//        LoginViewController *root = [[LoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
        [self.window setRootViewController:nav];
//    }
 

    [self.window makeKeyAndVisible];
    [self setKeyboardHiden];
    [self setupSDK];
//    [self login];

    return YES;
}

-(void)login
{
  
   

    [[NERtcCallKit sharedInstance] login:[UserManager shraeUserManager].user.uuid token:[UserManager shraeUserManager].user.wlToken completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"error=%@",[NSString stringWithFormat:@"IM登录失败%@",error.localizedDescription]);
//            [self.view makeToast:@"IM登录失败"];
        }else{
            NSLog(@"success");
         
            // 首次登录成功之后上传deviceToken
//            NSData *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:deviceTokenKey];
//            [[NERtcCallKit sharedInstance] updateApnsToken:deviceToken];
            
//            [self updateUserInfo:[NEAccount shared].userModel];
        }
    }];
}
- (void)setupSDK {
    NERtcCallOptions *option = [NERtcCallOptions new];
//    option.APNSCerName = kAPNSCerName;
//    option.supportAutoJoinWhenCalled = YES;
    NERtcCallKit *callkit = [NERtcCallKit sharedInstance];
    [callkit setupAppKey:AppKey options:option];
    
    /*
    callkit.tokenHandler = ^(uint64_t uid, void (^complete)(NSString *token, NSError *error)) {
        
        // 获取自己的安全token 传给SDK，体验情况没有自己业务服务器，无法获取token，请在管理后台关闭安全模式
        // complete("your token",nil);
        
    }; */
}
-(void)setKeyboardHiden
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    // 控制点击背景是否收起键盘
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES;
    // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:16];
    // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
    
    
}
-(void)versionCheck{
    
    
    
}
//6264eea830a4f67780b441ec
- (void)configUSharePlatforms
{
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WEIXINAPPID appSecret:WEIXINSECRET redirectURL:@"http://mobile.umeng.com/social"];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[SDKWrapper shared] applicationWillResignActive:application];
//    game->onPause();
    [[GameManager getInstance]didEnterBackground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [[SDKWrapper shared] applicationDidBecomeActive:application];
//    game->onResume();
    [[GameManager getInstance]willEnterForeground];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [[SDKWrapper shared] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    [[SDKWrapper shared] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {

    [[SDKWrapper shared] applicationWillTerminate:application];
    [[GameManager getInstance]willTerminate];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDKWrapper shared] applicationDidReceiveMemoryWarning:application];
    cc::EventDispatcher::dispatchMemoryWarningEvent();
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
         // 其他如支付等SDK的回调
    }
    return result;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler
{
    if (![[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil]) {
        // 其他SDK的回调
    }
    return YES;
}
@end
//source 'https://mirrors.bfsu.edu.cn/git/CocoaPods/Specs.git'
//#source 'http://git.dev.rooidea.com/saasapp-ios-component/coinbull.git'
//platform :ios, '12.0'
//#消除Pods警告
//inhibit_all_warnings!
//use_frameworks!
//#use_modular_headers!
//
//targets = ['TIDE-mobile']
//
//targets.each do |t|
//  target t do
//use_frameworks!
//
//pod 'Floaty', '~> 4.2.0'
//pod 'AGEVideoLayout', '~> 1.0.4'
//pod 'UMCCommon'
//pod 'UMCShare/UI'
//pod 'UMCShare/Social/WeChat'
//pod 'SVProgressHUD', '~> 2.2.5'
//pod 'SnapKit'
//pod 'AttributedString'
//pod 'AFNetworking'
//pod 'FMDB'
//pod 'IQKeyboardManager'
//pod 'AliyunOSSiOS'
//pod 'SSZipArchive'
//pod 'TZImagePickerController','~> 3.8.1'
//pod 'JSONModel'
//#pod 'NIMSDK_FULL', '8.5.5'
//pod 'NERtcCallKit', '~> 1.5.0'
//pod 'NERtcSDK', '4.2.115'
//pod 'NIMKit/Lite', :path => '../'
//
//  end
//end
