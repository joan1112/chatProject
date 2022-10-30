//
//  UITabBar+badge.h
//  MCC-AMS
//
//  Created by BOC008 on 2019/1/29.
//  Copyright © 2019年 BOC002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index;
- (void)hideBadgeOnItemIndex:(int)index;

@end
