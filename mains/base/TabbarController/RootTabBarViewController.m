//
//  RootTabBarViewController.m
//  AllStars
//
//  Created by Mac on 2021/10/9.
//

#import "RootTabBarViewController.h"
#import "../CommonMacros.h"
#import "../NavigationController/RootNavigationController.h"

@interface RootTabBarViewController ()<UINavigationControllerDelegate,UITabBarControllerDelegate,UITabBarDelegate>
@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setTranslucent:NO];
    self.delegate = self;
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.backgroundColor = kUIColorFromRGB(0xEEEEEE);
        self.tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        } else {
            // Fallback on earlier versions
        }
    } else {
        [[UITabBar appearance] setBackgroundColor:kUIColorFromRGB(0xEEEEEE)];
    }


    [self setUpAllChildViewController];

}
- (void)setUpAllChildViewController{
    
//    [self setUpOneChileViewController:[HomeViewController new] title:@"首页" image:[UIImage imageNamed:@"tabbar_w"] selectedImage:[UIImage imageNamed:@"tabbar_w_s"]];
//
//    [self setUpOneChileViewController:[PersonViewController new] title:@"个人中心" image:[UIImage imageNamed:@"tabbar_d"] selectedImage:[UIImage imageNamed:@"tabbar_d_s"]];

    
}

// 添加一个控制器
- (void)setUpOneChileViewController:(UIViewController *)vc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    vc.tabBarItem.title = title;
    //    // 设图片 并防止图片被渲染
    vc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
        if (@available(iOS 13.0, *)) {
                // iOS13 及以上
               //选中颜色
            self.tabBar.tintColor = kUIColorFromRGB(0x17B0DD);
               //默认颜色
            self.tabBar.unselectedItemTintColor = kUIColorFromRGB(0x666666);
         }
        else {
               // iOS13 以下
               UITabBarItem *item = [UITabBarItem appearance];
               [item setTitleTextAttributes:@{ NSForegroundColorAttributeName:kUIColorFromRGB(0x666666)} forState:UIControlStateNormal];
               [item setTitleTextAttributes:@{ NSForegroundColorAttributeName:kUIColorFromRGB(0x17B0DD)} forState:UIControlStateSelected];
         }
    
    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
}

#pragma mark - UITabBarDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    UINavigationController *navigationController = (UINavigationController *)viewController;
//    UIViewController *mainViewController = navigationController.viewControllers.firstObject;
    UIViewController *selected = [tabBarController selectedViewController];
//防止点击底部tabbar会自动pop
 
       if ([selected isEqual:viewController])
       {
           return NO;

       }
 
    
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
//    UINavigationController *navigationController = (UINavigationController *)viewController;
//    UIViewController *mainViewController = navigationController.viewControllers.firstObject;


}
-(void)setPushTask:(NSString *)pushTask{
    _pushTask = pushTask;
//    if (pushTask && ![pushTask isEqualToString:@""]) {
//        UINavigationController * selectedNav = self.viewControllers[self.selectedIndex];
//        UIViewController *topViewController = [selectedNav.viewControllers lastObject];
//        [CSRouteManager protocolAnalysisURL:pushTask withRootViewController:topViewController];
//    }
}

@end
