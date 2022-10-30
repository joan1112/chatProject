//
//  RootNavigationController.m
//  MCC-AMS
//
//  Created by BOC002 on 2018/4/12.
//  Copyright © 2018年 BOC002. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()<UIGestureRecognizerDelegate>
@property (nonatomic , strong)UIPanGestureRecognizer *pan;
@end

@implementation RootNavigationController

-(void)viewDidLoad {
   [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName:[UIColor blackColor],
        };;
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;

    } else {
        self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
    }

//    __weak typeof(self) weakself = self;
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.delegate = self;
        }
}

#pragma mark - UIGestureRecognizerDelegate
//这个方法是在手势将要激活前调用：返回YES允许右滑手势的激活，返回NO不允许右滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        //屏蔽调用rootViewController的滑动返回手势，避免右滑返回手势引起死机问题
        if (self.viewControllers.count < 2 ||
 self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    //这里就是非右滑手势调用的方法啦，统一允许激活
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
   if (self.childViewControllers.count > 0 ){
       // 每次Push时隐藏tabBar
       viewController.hidesBottomBarWhenPushed = YES;

   }
   // 调用系统的push方法  实现控制器的跳转
   [super pushViewController:viewController animated:animated];
   
   //临时解决办法。
//   CGRect frame = self.tabBarController.tabBar.frame;
//   frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
//   [UIView animateWithDuration:0.5 animations:^{
//       self.tabBarController.tabBar.frame = frame;
//   }];
   
}


@end
