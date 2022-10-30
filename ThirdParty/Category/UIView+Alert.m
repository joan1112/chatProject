//
//  UIView+Alert.m
//  MVC
//
//  Created by liushaohua on 2017/3/9.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+Alert.h"
#import "UIView+Toast.h"
#import "../MBProgressHUD/MBProgressHUD.h"
#import "../Masonry/Masonry.h"
#import "../../mains/base/CommonMacros.h"

@implementation UIView (Alert)

#pragma mark - Alert

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandler:(void(^)(UIAlertAction *confirmAction))handler {
    [self showAlertWithTitle:title message:message confirmTitle:@"确定" confirmHandler:handler];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmHandler:(void(^)(UIAlertAction *confirmAction))handler {
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmlAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:handler];
    [self showAlertWithTitle:title message:message cancelAction:cancelAction confirmAction:confirmlAction];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelAction:(UIAlertAction *)cancelAction confirmAction:(UIAlertAction *)confirmAction {
    
    if (cancelAction == nil && confirmAction == nil) return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    cancelAction != nil ? [alertController addAction:cancelAction] : nil;
    confirmAction != nil ? [alertController addAction:confirmAction] : nil;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - HUD

static void *HUDKEY = &HUDKEY;
- (MBProgressHUD *)HUD {
    return objc_getAssociatedObject(self, HUDKEY);
}

- (void)setHUD:(MBProgressHUD *)HUD {
    objc_setAssociatedObject(self, HUDKEY, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHUD {
//    [self showImageHUDWithText:@"数据加载中"];
    [self showHUDWithText:@""];
}

- (void)showHUDWithText:(NSString *)text {
    MBProgressHUD *HUD = [self HUD];
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        HUD.dimBackground = NO;
        HUD.removeFromSuperViewOnHide = YES;
        [self setHUD:HUD];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.label.text = text;
    [HUD showAnimated:YES];
}

- (void)showImageHUDWithText:(NSString *)text {
    MBProgressHUD *HUD = [self HUD];
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        HUD.dimBackground = NO;
        HUD.removeFromSuperViewOnHide = YES;
        [self setHUD:HUD];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.label.text = text;
    HUD.mode = MBProgressHUDModeCustomView;
    UIImageView * animationImag = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 35)];
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i<37; i++) {
        if (i<10) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loding_buffer_0000%d",i]]];
        }else{
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loding_buffer_000%d",i]]];
        }
    }
    animationImag.animationImages = images;
    animationImag.animationDuration = 1;
    animationImag.animationRepeatCount = -1;
    [animationImag startAnimating];
    HUD.customView = animationImag;
    HUD.bezelView.color = [UIColor colorWithWhite:0.f alpha:.4f];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.contentColor = kUIColorFromRGB(0xFFFFFF);
    HUD.animationType = MBProgressHUDAnimationFade;
    HUD.label.font = MYFONT(14);
    HUD.minSize = CGSizeMake(120, 90);
    [HUD showAnimated:YES];
}

- (void)hideHUD {
    [[self HUD] hideAnimated:YES];
}


#pragma mark - Toast

static void *ToastKEY = &ToastKEY;

- (UIView *)toastView {
    return objc_getAssociatedObject(self, ToastKEY);
}

- (void)setToastView:(UIView *)toastView {
    objc_setAssociatedObject(self, ToastKEY, toastView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showToastWithText:(NSString *)toastString {
    [self showToastWithText:toastString positon:CSToastPositionCenter];
}



- (void)showToastWithText:(NSString *)toastString positon:(id)positon {
    
    if (toastString.length > 0) {
        
        if (![self toastView]) {
            [CSToastManager setQueueEnabled:NO];
            [CSToastManager sharedStyle].backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            [CSToastManager sharedStyle].verticalPadding = 20;
            [CSToastManager sharedStyle].horizontalPadding = 18;
        }
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIView *toastView = [keyWindow toastViewForMessage:toastString title:nil image:nil style:nil];
        [UIView animateWithDuration:0.3 animations:^{
            [self toastView].alpha = 0 ;
        } completion:^(BOOL finished) {
            [[self toastView] removeFromSuperview];
            [self setToastView:toastView];
        }];
        [keyWindow showToast:toastView duration:1.5 position:positon completion:nil];
    }
}

- (void)showToastWithText:(NSString *)toastString afterDelay:(NSTimeInterval)timeInterval {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showToastWithText:toastString];
    });
}

-(void)showAlertWithTitle:(NSString*)title withImage:(UIImage*)image{
    
    //遮罩view
    UIView *maskView = [[UIView alloc] init];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:maskView];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    // 背景view
    UIView *bgView = [[UIView alloc] init];
    [maskView addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor] ;
    bgView.layer.cornerRadius = 5;
    
    // 图片
    UIImageView *imageView = [[UIImageView alloc]init];
    if (image) {
        imageView.image = image;
    }else{
        imageView.image = [UIImage imageNamed:@"warm_icom"];
    }
    [bgView addSubview:imageView];
    
    // label
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    [bgView addSubview:label];
    label.textColor = kUIColorFromRGB(0x333333);
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:13];
    
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(maskView.superview);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(KScreenHeight);
    }];
    // 设置背景view的约束
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(bgView.superview);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(130);
    }];
    
    // 设置imageView的约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    // 设置label的约束
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_lessThanOrEqualTo(150);
        make.centerX.mas_equalTo(label.superview);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(10);
        make.bottom.mas_offset(-14);
    }];
    
    // 2秒后移除toast
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [maskView removeFromSuperview];
        }];
    });
}

@end

@implementation UIViewController (Alert)

- (void)showHUD {
    [self.view showHUD];
}

- (void)showHUDWithText:(NSString *)text {
    [self.view showHUDWithText:text];
}

- (void)showImageHUDWithText:(NSString *)text {
    [self.view showImageHUDWithText:text];
}

- (void)hideHUD {
    [self.view hideHUD];
}

- (void)showToastWithText:(NSString *)toastString {
    [self.view showToastWithText:toastString];
}

- (void)showToastWithText:(NSString *)toastString positon:(id)positon {
    [self.view showToastWithText:toastString positon:positon];
}

- (void)showToastWithText:(NSString *)toastString afterDelay:(NSTimeInterval)timeInterval {
    [self.view showToastWithText:toastString afterDelay:timeInterval];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandler:(void(^)(UIAlertAction *confirmAction))handler {
    [self.view showAlertWithTitle:title message:message confirmHandler:handler];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmHandler:(void(^)(UIAlertAction *confirmAction))handler {
    [self.view showAlertWithTitle:title message:message confirmTitle:confirmTitle confirmHandler:handler];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelAction:(UIAlertAction *)cancelAction confirmAction:(UIAlertAction *)confirmAction {
    [self.view showAlertWithTitle:title message:message cancelAction:cancelAction confirmAction:confirmAction];
}

@end
