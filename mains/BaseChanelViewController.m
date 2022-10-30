//
//  BaseChanelViewController.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/10.
//

#import "BaseChanelViewController.h"
#import <NERtcCallKit/NERtcCallKit.h>
#import "UIView+Toast.h"
#import "base/User/UserManager.h"
@interface BaseChanelViewController ()<NERtcCallKitDelegate, NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate,NIMLoginManagerDelegate,NIMUserManagerDelegate,NIMEventSubscribeManagerDelegate>

@end

@implementation BaseChanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
-(void)login
{
    
//    "2" 6900f605e7cb004e14b0def3eddb16fb
   // "3" bfe44afd5a16f14cd1398810dc02830d
   
//    NIMUser *user = [[NIMUser alloc]init];
    
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
    [[NERtcCallKit sharedInstance] addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[[NIMSDK sharedSDK] loginManager]addDelegate:self];
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    [[NIMSDK sharedSDK].subscribeManager addDelegate:self];
    
}
-(void)callSmWith:(NSString*)userid withType:(NSInteger)typea{
    [[NERtcCallKit sharedInstance] call:@"3" type:typea==0?NERtcCallTypeAudio:NERtcCallTypeVideo completion:^(NSError * _Nullable error) {
        
       
    }];
}

#pragma mark - NERtcVideoCallDelegate 被邀请监听
- (void)onInvited:(NSString *)invitor
          userIDs:(NSArray<NSString *> *)userIDs
      isFromGroup:(BOOL)isFromGroup
          groupID:(nullable NSString *)groupID
             type:(NERtcCallType)type
       attachment:(nullable NSString *)attachment {
    NSLog(@"menu controoler onInvited");
    [NIMSDK.sharedSDK.userManager fetchUserInfos:@[invitor] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
     
    }];
    
}

-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    
}
-(void)onLogin:(NIMLoginStep)step
{
    
}

#pragma mark---NIMEventSunscirbr
-(void)onRecvSubscribeEvents:(NSArray *)events
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
