
//
//  GViewController.m
//  tide-mobile
//
//  Created by junqiang on 2022/4/15.
//

#import "GViewController.h"
#include "Game.h"
#include "cocos/bindings/event/EventDispatcher.h"
#include "cocos/platform/Device.h"
#include "SDKWrapper.h"
#import "../AppDelegate.h"
#include "cocos/platform/apple/JsbBridge.h"
#include "platform/ios/View.h"
#import "LoginViewController.h"
#import "GameManager.h"
#import "base/User/UserManager.h"
#import "../ThirdParty/Tool/Tools.h"
#import "view/AlertConfirmView.h"
#import "OrderViewController.h"
#import "../ThirdParty/Category/UIView+Frame.h"
#import "base/CommonMacros.h"
#import "social/FriendListView.h"
#import "social/FriendDataManager.h"
#import "base/ConstMacros.h"
#import "social/model/FriendModel.h"
#import "UIView+Toast.h"
#import "social/HangupView.h"
#import "VideoViewController.h"
#import "base/BaseNetWork/HFNetWorkTool.h"
#import "social/ChatView.h"
#import "social/AlertApplyView.h"
#import "social/RecentView.h"
#import "MapResourceController.h"
#import "base/NavigationController/RootNavigationController.h"
#include "bindings/manual/jsb_global.h"
#include "bindings/jswrapper/v8/ScriptEngine.h"

#include <Application.h>

#define ChatWD1 240
#define ChatWD2 340
#define MarginLeft 30
@interface GViewController ()<FriendListViewDelegate,AddFriendViewDelegate,FriendDetailViewDelegate,NERtcCallKitDelegate, NIMChatManagerDelegate,HangupViewDelegate,ChatViewDelegate,AlertApplyViewDeleagte>
{
    UIButton *openButton;
    HangupView *upView;
    NEUser *remoteUser;
    NERtcCallType callType;
}
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)FriendListView *friendView;
@property(nonatomic,strong)AddFriendView *addFriend;
@property(nonatomic,strong)FriendDetail *detailFriend;
@property(nonatomic,strong)FriendRequstList *requestFriend;
@property(nonatomic,strong)ChatView *chatView;
@property(nonatomic,strong)RecentView *recentView;
@property(nonatomic,strong)AlertApplyView *applay;
@end

@implementation GViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"initooooooo");
       
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self login];
    self.view.backgroundColor = [UIColor whiteColor];
   
    

}
-(void)back1{
   
      UIButton  *bt = [UIButton buttonWithType:UIButtonTypeCustom];
       [self.view addSubview:bt];
       [bt setImage:[UIImage imageNamed:@"open_page"] forState:UIControlStateNormal];
       [bt addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
 
    bt.frame = CGRectMake(KScreenWidth-80, 30 , 30, 60);

    
}
-(void)willMoveToParentViewController:(UIViewController *)parent
{
  
}
-(void)click1:(UIButton*)sender
{
    
    [self.view removeFromSuperview];
   
//
    [[GameManager getInstance] didEnterBackground];
//    delete  cc::Application::getInstance();
//    [GameManager getInstance].gv = nil;
//    se::ScriptEngine::destroyInstance();
    [[GameManager getInstance] onClose];
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    MapResourceController *resource = [[MapResourceController alloc]init];
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:resource];
   
    window.rootViewController = nav;
    
    

}
-(void)back{
    if(!openButton){
        openButton = [UIButton buttonWithType:UIButtonTypeCustom];
       [self.view addSubview:openButton];
       [openButton setImage:[UIImage imageNamed:@"open_page"] forState:UIControlStateNormal];
       [openButton addTarget:self action:@selector(friendAction:) forControlEvents:UIControlEventTouchUpInside];
        openButton.frame = CGRectMake(-MarginLeft, 30 , 30, 60);
    }
  
    
}
-(void)friendAction:(UIButton*)sender{
    if (self.chatView) {
        [UIView animateWithDuration:.5 animations:^{
            self.chatView.x = -ChatWD2;
                } completion:^(BOOL finished) {
                    [self.chatView removeFromSuperview];
                    [self.chatView destory];
                    self.chatView = nil;
                    openButton.x =openButton.x - ChatWD2;
                }];
       

        
        return;
    }
    sender.selected = !sender.selected;
    if (!_friendView) {
        _friendView = [[FriendListView alloc]initWithFrame:CGRectMake(-ChatWD1, 0, ChatWD1, KScreenHeight)];
        [self.view addSubview:_friendView];
        _friendView.delegate = self;
        [_friendView creatView];
        _friendView.layer.zPosition = 20;
        [self requstFriendList];

    }
    if (sender.selected) {
        [self requstFriendList];

        [UIView animateWithDuration:.5 animations:^{
            _friendView.x = kTopBarDifHeight;
            openButton.x =openButton.x + ChatWD1+kTopBarDifHeight+MarginLeft;
//            [modelView layoutIfNeeded];
        }];
    }else{
        [self removeSubView];
        [UIView animateWithDuration:.5 animations:^{
            _friendView.x = -ChatWD1;
            openButton.x =openButton.x - ChatWD1-kTopBarDifHeight-MarginLeft;
//            [modelView layoutIfNeeded];
        }];
    }

}
-(void)removeSubView{
    if (self.addFriend) {
        [self.addFriend removeFromSuperview];
        self.addFriend = nil;
    }
    if (self.detailFriend) {
        [self.detailFriend removeFromSuperview];
        self.detailFriend = nil;
    }
    if (self.requestFriend) {
        [self.requestFriend removeFromSuperview];
        self.requestFriend = nil;
    }
    if (self.chatView) {
        [self.chatView removeFromSuperview];
        [self.chatView destory];
        self.chatView = nil;
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ( [GameManager getInstance].gv) {
//        self.view = [GameManager getInstance].gv.view;
        [[GameManager getInstance] willEnterForeground];

    }else{
        CGRect bounds = [[UIScreen mainScreen] bounds];

        self.view                      = [[View alloc] initWithFrame:bounds];
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.contentScaleFactor   = UIScreen.mainScreen.scale;
        self.view.multipleTouchEnabled = true;
        [[GameManager getInstance]initGame];
        
        [GameManager getInstance].gv = self;
        JsbBridge* m = [JsbBridge sharedInstance];
//
    static ICallback cb = ^void (NSString* _arg0, NSString* _arg1){
        //open Ad
        NSLog(@"ob===%@==%@",_arg0,_arg1);//ShowChat
        NSDictionary *info = @{@"token":[UserManager shraeUserManager].user.token,@"uuid":[UserManager shraeUserManager].user.uuid,@"scenename":@"main"};
        NSString *str = [Tools dicToString:info];
        NSLog(@"strs===%@",str);

        if ([_arg0 isEqualToString:@"ClientReady"]) {
            [m sendToScript:@"LaunchInfo" arg1:str];
        }else  if ([_arg0 isEqualToString:@"ShowChat"]){
            [self friendAction:openButton];
           
        }
//        else  if([_arg0 isEqualToString:@"BackPlatform"]){
//            UIWindow *window = [UIApplication sharedApplication].windows[0];
//            MapResourceController *resource = [[MapResourceController alloc]init];
//            RootNavigationController *nav = [[RootNavigationController alloc]init];
//            window.rootViewController = nav;
//            [[GameManager getInstance] willTerminate];
//
//        }
        
        
        //BackPlatform

        
    };
    [m setCallback:cb];

    [self back];
//    [self back1];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"viewDidAppear");
    NSLog(@"viewDidAppear===%@",[GameManager getInstance].gv);
   

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];


    NSLog(@"disappera");

}
- (BOOL) shouldAutorotate {
    return YES;
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden {
    return YES;
}

// Controls the application's preferred home indicator auto-hiding when this view controller is shown.
- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {


    cc::Device::Orientation orientation = cc::Device::getDeviceOrientation();
    // reference: https://developer.apple.com/documentation/uikit/uiinterfaceorientation?language=objc
    // UIInterfaceOrientationLandscapeRight = UIDeviceOrientationLandscapeLeft
    // UIInterfaceOrientationLandscapeLeft = UIDeviceOrientationLandscapeRight
    cc::EventDispatcher::dispatchOrientationChangeEvent(static_cast<int>(orientation));

    float    pixelRatio = cc::Device::getDevicePixelRatio();
    cc::EventDispatcher::dispatchResizeEvent(size.width * pixelRatio
                                             , size.height * pixelRatio);
    CAMetalLayer *layer = (CAMetalLayer *)self.view.layer;
    CGSize tsize             = CGSizeMake(static_cast<int>(size.width * pixelRatio),
                                         static_cast<int>(size.height * pixelRatio));
    layer.drawableSize = tsize;
}
#pragma mark---delegate frindlist
-(void)friendListClickWith:(NSInteger)tag withId:(NSString *)userId
{
    if (tag==0) {//好友申请
        [UIView animateWithDuration:.5 animations:^{
            _friendView.x = -ChatWD1;
        } completion:^(BOOL finished) {
            _requestFriend = [[FriendRequstList alloc]initWithFrame:CGRectMake(kTopBarDifHeight, 0, ChatWD1,KScreenHeight)];
            [self.view addSubview:_requestFriend];
            _requestFriend.layer.zPosition = 21;

            _requestFriend.delegate = self;
            [self requstRequestFDList];
//            [_requestFriend creatView];
        }];
    }else if(tag==1){//添加好友
        [UIView animateWithDuration:.5 animations:^{
            _friendView.x = -ChatWD1;
        } completion:^(BOOL finished) {
            _addFriend = [[AddFriendView alloc]initWithFrame:CGRectMake(kTopBarDifHeight, 0, ChatWD1,KScreenHeight)];
            [self.view addSubview:_addFriend];
            _addFriend.layer.zPosition = 21;

            _addFriend.delegate = self;
            [_addFriend creatView];
        }];
    }else if (tag==10){//语音
        [self friendAction:openButton];
        NEUser *user = [[NEUser alloc] init];
        user.imAccid = userId;
        NIMUser *u = [[NIMSDK sharedSDK].userManager  userInfo:userId];
        user.avatar = [u.userInfo.avatarUrl stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
        user.nickname = u.userInfo.nickName;
        NEUser *user1 = [[NEUser alloc] init];
        user1.imAccid =[UserManager shraeUserManager].user.uuid;
        user1.avatar = [UserManager shraeUserManager].user.headImg;
        UIWindow *window = [UIApplication sharedApplication].windows[0];
        VideoViewController *video = [[VideoViewController alloc]init];
        video.remoteUser = user;
        video.localUser = user1;
        video.callType = NERtcCallTypeAudio;
        video.status = NERtcCallStatusCalling;
        [window.rootViewController presentViewController:video animated:YES completion:nil];

    }else if(tag==11){//视频
        [self friendAction:openButton];

        NEUser *user = [[NEUser alloc] init];
        user.imAccid =userId;
        user.avatar = @"";
        NEUser *user1 = [[NEUser alloc] init];
        user1.imAccid =[UserManager shraeUserManager].user.uuid;
        user1.avatar = @"";
        UIWindow *window = [UIApplication sharedApplication].windows[0];
        VideoViewController *video = [[VideoViewController alloc]init];
        video.remoteUser = user;
        video.localUser = user1;
        video.callType = NERtcCallTypeVideo;

        video.status = NERtcCallStatusCalling;
        [window.rootViewController presentViewController:video animated:YES completion:nil];
    }
}

-(void)friendListCellClick:(NSString *)userid
{
    if (_chatView) {
        [_chatView removeFromSuperview];
        [_chatView destory];
        _chatView = nil;
    }
    UIWindow *window = [UIApplication sharedApplication].windows[0];

    NIMSession *session = [NIMSession session:userid type:NIMSessionTypeP2P];
//    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
//    [window.rootViewController presentViewController:vc animated:YES completion:nil];
    [UIView animateWithDuration:.5 animations:^{
//        _friendView.x = -ChatWD;
        _chatView  = [[ChatView alloc]initWithSession:session WithFrame:CGRectMake(kTopBarDifHeight+ChatWD1, 0, ChatWD2,KScreenHeight)];
         [self.view addSubview:_chatView];
        _chatView.layer.zPosition = 16;

         _chatView.delegate = self;
         [_chatView loadView];
    } completion:^(BOOL finished) {
        if(openButton.x<ChatWD1+ChatWD2){
            openButton.x+=ChatWD2;

        }
        
        
    }];
}
#pragma mark-----add list
-(void)recentListClik:(NIMSession *)session
{
    if (_chatView) {
        [_chatView removeFromSuperview];
        [_chatView destory];
        _chatView = nil;
    }
    [UIView animateWithDuration:.5 animations:^{
//        _friendView.x = -ChatWD;
        _chatView  = [[ChatView alloc]initWithSession:session WithFrame:CGRectMake(kTopBarDifHeight+ChatWD1, 0, ChatWD2,KScreenHeight)];
         [self.view addSubview:_chatView];
         _chatView.delegate = self;
        _chatView.layer.zPosition = 16;

         [_chatView loadView];
    } completion:^(BOOL finished) {
      
        if(openButton.x<ChatWD1+ChatWD2){
            openButton.x+=ChatWD2;

        }
        
    }];
}
-(void)dismissChatView
{
    [_chatView removeFromSuperview];
    [_chatView destory];
    _chatView = nil;
    [UIView animateWithDuration:.5 animations:^{
        _friendView.x = kTopBarDifHeight;
      
    } completion:^(BOOL finished) {
        if (openButton.x<100) {
            openButton.x =openButton.x + ChatWD1+kTopBarDifHeight+MarginLeft;
        }
    }];

}
-(void)addFriendClickWith:(NSInteger)tag withId:(NSString *)userId
{
    if (tag==0) {
        if (_addFriend) {
            [_addFriend removeFromSuperview];
            _addFriend = nil;
        }
        [UIView animateWithDuration:.5 animations:^{
            _friendView.x = kTopBarDifHeight;
          
        } completion:^(BOOL finished) {
            if (openButton.x<100) {
                openButton.x =openButton.x + ChatWD1+kTopBarDifHeight + MarginLeft;
            }
        }];
    }
}
//选择列表 跳转到好友详情页
-(void)didSelectWithModel:(SearchResultModel *)model
{
    _applay = [[AlertApplyView alloc]initWithFrame:self.view.frame];
    _applay.model = model;
    [_applay loadSubView];
    [_applay showPopView];
    _applay.delegate = self;
}
#pragma mark---aplay delegte
-(void)alertApllySender:(NSString *)userid
{
    
    [_applay hidePopView];
    [self senderFriendRequstWith:userid];

}
-(void)didSelectRequstWithModel:(RequstListModel *)model
{
    if (_requestFriend) {
        [_requestFriend removeFromSuperview];
        _requestFriend = nil;
    }
    NSInteger status;
    if ([model.f_type intValue]==2) {
        status = 2;
    }else{
        status = 1;

    }
    _detailFriend = [[FriendDetail alloc]initWithFrame:CGRectMake(kTopBarDifHeight, 0, ChatWD1,KScreenHeight)];
    _detailFriend.delegate = self;
    _detailFriend.status = status;
    _detailFriend.model_re = model;
    [self.view addSubview:_detailFriend];
    [_detailFriend creatView];
}
-(void)searchText:(NSString *)key
{
    [self requstSearchResult:key];
}
-(void)detailFriendClickWith:(NSInteger)tag withId:(NSString *)userId withStaus:(NSInteger)status
{
    if (tag==0) {//返回
        [self requstFriendList];

        if (_requestFriend) {//好友申请页返回
            [_requestFriend removeFromSuperview];
            _requestFriend = nil;
            [UIView animateWithDuration:.5 animations:^{
                _friendView.x = kTopBarDifHeight;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [_detailFriend removeFromSuperview];
            _detailFriend = nil;
            if (_addFriend) {
                _addFriend.hidden = NO;
            }else{
                [UIView animateWithDuration:.5 animations:^{
                    _friendView.x = kTopBarDifHeight;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
        
    }else if(tag==1){//已不使用
        //        发送添加好友请求
        if (_detailFriend) {
            [_detailFriend removeFromSuperview];
            _detailFriend = nil;
            [_addFriend removeFromSuperview];
            _addFriend = nil;
        }
        [self senderFriendRequstWith:userId];
        [UIView animateWithDuration:.5 animations:^{
            _friendView.x = kTopBarDifHeight;
        } completion:^(BOOL finished) {
            
        }];
    }else if(tag==2){
        //搜索好友
        if (_requestFriend) {
            [_requestFriend removeFromSuperview];
            _requestFriend = nil;
        }
        
        _addFriend = [[AddFriendView alloc]initWithFrame:CGRectMake(kTopBarDifHeight, 0, ChatWD1,KScreenHeight)];
        [self.view addSubview:_addFriend];
        _addFriend.delegate = self;
        [_addFriend creatView];
        
        
    }else if(tag==3){
        if (_requestFriend) {
            [_requestFriend removeFromSuperview];
            _requestFriend = nil;
        }
        _detailFriend = [[FriendDetail alloc]initWithFrame:CGRectMake(kTopBarDifHeight, 0, ChatWD1,KScreenHeight)];
        _detailFriend.delegate = self;
        _detailFriend.status = status;
        [self.view addSubview:_detailFriend];
        [_detailFriend creatView];
    }
}
-(void)detailFriendStatus:(BOOL)isAgree WithModelUUID:(nonnull NSString *)UUID
{
    NSLog(@"点击了拒绝===%d",isAgree);
    if (_detailFriend) {
        [_detailFriend removeFromSuperview];
        _detailFriend = nil;
    }
    if (_requestFriend) {
        [_requestFriend removeFromSuperview];
        _requestFriend = nil;
    }
    [UIView animateWithDuration:.5 animations:^{
        _friendView.x = kTopBarDifHeight;
    } completion:^(BOOL finished) {
        
    }];
    if (isAgree) {
        [self acceptRequesWithId:UUID];
    }else{
        [self refuseRequestWithId:UUID];

    }
}
-(void)requstFriendList{
    [HFNetWorkTool POST:friendList parameters:@{} currentViewController:nil success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
            NSArray *data = responseObject[@"data"];
            NSArray *models = [FriendModel arrayOfModelsFromDictionaries:data error:nil];
         
            [_friendView reloadDataWithArr:models];
        }
        
       
        } failure:^(NSError *error) {
            
        }];
}
//获取申请的列表
-(void)requstRequestFDList{
    [HFNetWorkTool POST:getRequst parameters:@{} currentViewController:nil success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
            NSDictionary *data = responseObject[@"data"];
            RequstModel *model= [[RequstModel alloc]initWithDictionary:data error:nil];;
         
            [_requestFriend requstDataLoad:model];
        }
        
       
        } failure:^(NSError *error) {
            
        }];
}
//模糊搜索
-(void)requstSearchResult:(NSString*)text{
    [HFNetWorkTool POST:searchUser parameters:@{@"content":text} currentViewController:nil success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
           
            NSArray *data = responseObject[@"data"];
            NSArray *models = [SearchResultModel arrayOfModelsFromDictionaries:data error:nil];
            [_addFriend searchResultData:models];
        }
        
       
        } failure:^(NSError *error) {
            
        }];
}
#pragma mark---发送好友成功
-(void)senderFriendRequstWith:(NSString*)userid
{
    [HFNetWorkTool POST:senderRequst parameters:@{@"invite_uuid":userid} currentViewController:nil success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
            [self.view makeToast:@"发送成功，等待对方验证"];
            [self requstFriendList];
            [self  addFriend:userid];
         }
        } failure:^(NSError *error) {
            
        }];
}
-(void)acceptRequesWithId:(NSString*)userid{
    [HFNetWorkTool POST:acceptRequest parameters:@{@"apply_uuid":userid} currentViewController:nil success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
            [self.view makeToast:@"发送成功"];
            [self requstFriendList];

         }
        } failure:^(NSError *error) {
            
        }];
}
-(void)refuseRequestWithId:(NSString*)userid{
    [HFNetWorkTool POST:refusetRequest parameters:@{@"apply_uuid":userid} currentViewController:nil success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
            [self.view makeToast:@"发送成功"];
         }
        } failure:^(NSError *error) {
            
        }];
}

-(void)creatHangup{
    upView = [[HangupView alloc]initWithFrame:CGRectMake(KScreenWidth-280, 35, 240, 80)];
    [self.view addSubview:upView];
    upView.type = callType;
    upView.layer.zPosition = 30;
    upView.delegate = self;
    upView.remoteUsr = remoteUser;
    [upView creatView];
}
#pragma mark---hang delegae
-(void)hangupAction:(NSInteger)tag
{
    [upView removeFromSuperview];
    upView = nil;
    if (tag==0) {
        [[NERtcCallKit sharedInstance] reject:^(NSError * _Nullable error) {
           
        }];
    }else{
        [[NERtcCallKit sharedInstance] accept:^(NSError * _Nullable error) {
      
        if (error) {
            NSLog(@"accept error : %@", error);
            if (error.code == 21000 || error.code == 21001) {
                [UIApplication.sharedApplication.keyWindow makeToast:[NSString stringWithFormat:@"接听失败%@", error.localizedDescription]];
            }else {
                [UIApplication.sharedApplication.keyWindow makeToast:@"接听失败"];
            }
            
        }else {//成功
          
            UIWindow *window =    UIApplication.sharedApplication.windows[0];
            NEUser *user = [[NEUser alloc] init];
            user.imAccid =[UserManager shraeUserManager].user.uuid;
            user.avatar = [UserManager shraeUserManager].user.headImg;
            VideoViewController *callVC = [[VideoViewController alloc] init];
            callVC.localUser = user;
            callVC.remoteUser = remoteUser;
            callVC.status = NERtcCallStatusInCall;
            callVC.callType = callType;
            callVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [window.rootViewController presentViewController:callVC animated:YES completion:nil];
           
        }
    }];

        
    }
}
-(void)initObserver{
    [[NERtcCallKit sharedInstance] addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    
}
#pragma mark - NERtcVideoCallDelegate
- (void)onInvited:(NSString *)invitor
          userIDs:(NSArray<NSString *> *)userIDs
      isFromGroup:(BOOL)isFromGroup
          groupID:(nullable NSString *)groupID
             type:(NERtcCallType)type
       attachment:(nullable NSString *)attachment {
    NSLog(@"menu controoler onInvited");
    [NIMSDK.sharedSDK.userManager fetchUserInfos:@[invitor] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        if (error) {
            [self.view makeToast:error.description];
            return;
        }else {
            NIMUser *imUser = users.firstObject;
            remoteUser = [[NEUser alloc] init];
            remoteUser.imAccid = imUser.userId;
            remoteUser.mobile = imUser.userInfo.mobile;
            remoteUser.avatar = imUser.userInfo.avatarUrl;
            remoteUser.avatar = [remoteUser.avatar stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
            remoteUser.nickname = imUser.userInfo.nickName;
            NEUser *user = [[NEUser alloc] init];
            user.imAccid = [UserManager shraeUserManager].user.uuid;
            user.avatar = @"";
            callType = type;
            [self creatHangup];
            
//            VideoViewController *callVC = [[VideoViewController alloc] init];
//            callVC.localUser = user;
//            callVC.remoteUser = remoteUser;
//            callVC.status = NERtcCallStatusCalled;
//            callVC.callType = type;
//            callVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//            [self.navigationController presentViewController:callVC animated:YES completion:nil];
            
        }
    }];
    
}
- (void)onDisconnect:(NSError *)reason {
  
}
#pragma mark - IM delegate

- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
    
    for (NIMMessage *message in messages) {
        if (message.messageType == NIMMessageTypeRtcCallRecord) {
            NECallStatusRecordModel *record = [[NECallStatusRecordModel alloc] init];
            [upView removeFromSuperview];
            upView = nil;
        }
    }
}
-(void)addFriend:(NSString*)userid{
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = userid;
    request.operation = NIMUserOperationAdd;
//    __weak typeof(self) wself = self;

    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
        if (!error) {
//            [self.view makeToast:@"success"
//                         duration:2.0f
//                         position:CSToastPositionCenter];
//            [wself refresh];
        }else{
//            [self.view makeToast:@"fail"
//                         duration:2.0f
//                         position:CSToastPositionCenter];
        }
    }];
}
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    NSLog(@"---------接收到通知===%ld",unreadCount);
    NSArray *friends =  [[NIMSDK sharedSDK].userManager myFriends];
    NSLog(@"---------好友liebiao===%ld",friends.count);
    [_friendView friendRequestChanged];

}
- (void)removeObserver {
    [[NERtcCallKit sharedInstance] removeDelegate:self];
//    [NEAccount removeObserverForObject:self];
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
