//
//  RootViewController.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 VC 基类
 */
@interface RootViewController : UIViewController

/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;

@property (strong, nonatomic) UIImageView *spButton;
@property (nonatomic, assign) BOOL DisableSidePop;//禁止侧滑返回

/**
 *  显示请求超时页面
 */
-(void)showTimeOutView;
/**
 *  隐藏请求超时页面
 */
- (void)hiddenTimeOutView;
/**
 *  为控制器扩展方法，刷新网络时候执行，建议必须实现  //再次刷新
 */
- (void)reloadRequest;

/**
 *  显示没有数据页面
 */




/**
 *  是否显示返回按钮,默认情况是YES
 */
@property (nonatomic, assign) BOOL isShowLeftBack;

/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHidenNaviBar;

/**
 *  默认返回按钮的点击事件，默认是返回，子类可重写
 */
- (void)backBtnClicked;

//取消网络请求
- (void)cancelRequest;
-(BOOL)gardenNetWork;

@end
