//
//  GameManager.h
//  tides-mobile
//
//  Created by junqiang on 2022/4/20.
//

#import <Foundation/Foundation.h>
#import "GViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface GameManager : NSObject

@property(nonatomic,strong)GViewController *gv;
+(instancetype)getInstance;
-(void)initGame;
-(void)didEnterBackground;
-(void)willEnterForeground; // app返回前台时调用, 通知游戏js层
-(void)willTerminate;
-(void)didlanunchWith:(NSDictionary*)dic;
-(void)applicationDidEnterBackground;
-(void)onClose;
@end

NS_ASSUME_NONNULL_END
