//
//  GameManager.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/20.
//

#import "GameManager.h"
#include "platform/ios/View.h"
#include "Game.h"
#include "SDKWrapper.h"
#import "MapResourceController.h"
#import "base/NavigationController/RootNavigationController.h"
static GameManager * _instance = NULL;
Game *      game = nullptr;

@interface GameManager()

@end
@implementation GameManager
+(instancetype)getInstance {

    if (!_instance) {
        _instance = [[GameManager alloc]init];
    }
    
    return _instance;
}

-(void)initGame{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    game = new Game(bounds.size.width, bounds.size.height);
    game->init();

    
}
-(void)didEnterBackground;
{
    if (game) {
        game->onPause();
    }
   
}
-(void)willEnterForeground;
{
    if (game) {
        game->onResume();
    }
  
}
// app返回前台时调用, 通知游戏js层
-(void)willTerminate{
    if (game) {
        UIApplication *application = [UIApplication sharedApplication];
        [[SDKWrapper shared] applicationWillTerminate:application];
        game->onClose();
         delete game;
         game = nullptr;
        [self.gv.view removeFromSuperview];
        self.gv = nil;
       
    }
      
}
-(void)onClose
{
    game->onClose();
//     delete game;
//     game = nullptr;
    self.gv = nil;
    
   
}
-(void)didlanunchWith:(NSDictionary*)dic;
{
    UIApplication *application = [UIApplication sharedApplication];

    [[SDKWrapper shared] application:application didFinishLaunchingWithOptions:dic];


}
-(void)applicationDidEnterBackground;
{
    UIApplication *application = [UIApplication sharedApplication];

    [[SDKWrapper shared] applicationDidEnterBackground:application];
}

@end
