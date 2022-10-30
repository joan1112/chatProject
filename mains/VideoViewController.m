//
//  VideoViewController.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/24.
//

#import "VideoViewController.h"
#import "base/CommonMacros.h"
#import "../ThirdParty/Category/UIView+Frame.h"
#import "view/AudioView.h"
#import "../ThirdParty/Masonry/Masonry.h"
#import "UIView+Toast.h"
#import "social/DragButton.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VideoViewController ()<NERtcCallKitDelegate,NIMChatManagerDelegate>
{
    AudioView *localView;
    AudioView *remoteView;
    BOOL isJoined;
    UILabel *voiceLab;
    UILabel *mircLab;
    UILabel *time;
    UIButton *voice;
    UIButton *mirc;
    UIButton *changeWay;
    UILabel *changeWayLab;
    UIButton *transtAudio;
    UILabel *transLab;
    UIImageView *headImg;
    UILabel *nickName;
}
@property(nonatomic,strong)UIView *container;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self initContainer];
//    self.timerIndex = 0;

    [self initview];
    [self initAudio];
//    [self initTimer];

}
-(void)initAudio
{
    [[NERtcCallKit sharedInstance] addDelegate:self];
    [NERtcCallKit sharedInstance].timeOutSeconds = 30;
    NSError *error;
    [[NERtcCallKit sharedInstance] setLoudSpeakerMode:YES error:&error];
    [[NERtcCallKit sharedInstance] enableLocalVideo:YES];
    [[NERtcEngine sharedEngine] adjustRecordingSignalVolume:200];
    [[NERtcEngine sharedEngine] adjustPlaybackSignalVolume:200];
    if (self.status == NERtcCallStatusCalling) {
        [[NERtcCallKit sharedInstance] call:self.remoteUser.imAccid type:self.callType ? self.callType : NERtcCallTypeVideo completion:^(NSError * _Nullable error) {
            NSLog(@"call error code : %@", error);

            if (self.callType == NERtcCallTypeVideo) {
                [[NERtcCallKit sharedInstance] setupLocalView:localView];
            }
            localView.uid = self.localUser.imAccid;
            if (error) {
                /// 对方离线时 通过APNS推送 UI不弹框提示
                if (error.code == 10202 || error.code == 10201) {
                    return;
                }
                
                if (error.code == 21000 || error.code == 21001) {
                    //[UIApplication.sharedApplication.keyWindow makeToast:error.localizedDescription];
                    [self performSelector:@selector(destroy) withObject:nil afterDelay:3.5];
                }
                [self.view makeToast:error.localizedDescription];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }else{
        time.text = @"";
//        [self initTimer];
    }
    
    
    [self setViewWithType];
}
-(void)reloadTimer:(int)index
{
    self.timerIndex = index;
}
-(void)loadRemoteView;
{
    [self setViewWithType];
    if (self.status == NERtcCallStatusInCall&&!self.timer) {
        [self initTimer];
    }
}
-(void)setViewWithType{
  
        if (self.callType == NERtcCallTypeVideo) {
            [self showVideoView];
        }else{
            [self hideVideoView];
        }
       
  
}
- (void)hideVideoView {
    [[NERtcCallKit sharedInstance] setupLocalView:nil];
    [[NERtcCallKit sharedInstance] setupRemoteView:nil forUser:nil];
   
    NSError *error;
    [[NERtcCallKit sharedInstance] setLoudSpeakerMode:NO error:&error];
    [[NERtcEngine sharedEngine] muteLocalAudio:NO];
    mirc.hidden = NO;
    mircLab.hidden = NO;
    voice.hidden = NO;
    voiceLab.hidden = NO;
    
    changeWay.hidden = YES;
    changeWayLab.hidden = YES;
    transLab.hidden = YES;
    transtAudio.hidden = YES;
    localView.hidden = YES;
    remoteView.hidden = YES;
    headImg.hidden = NO;
    nickName.hidden = NO;
    
}

- (void)showVideoView {
    
    
    if (self.status == NERtcCallStatusCalling) {
        [[NERtcCallKit sharedInstance] setupLocalView:localView];
    }
    if (self.status == NERtcCallStatusInCall) {
        [[NERtcCallKit sharedInstance] setupLocalView:localView];
        NSLog(@"self.status == NERtcCallStatusInCall enableLocalVideo:YES");
        [[NERtcCallKit sharedInstance] setupRemoteView:remoteView forUser:self.remoteUser.imAccid];
    }
    
//    if (self.switchCameraBtn.selected == YES) {
//        [[NERtcCallKit sharedInstance] switchCamera];
//    }
    
    [[NERtcCallKit sharedInstance] muteLocalAudio:NO];
    [[NERtcCallKit sharedInstance] muteLocalVideo:NO];
    NSError *error;
    [[NERtcCallKit sharedInstance] setLoudSpeakerMode:YES error:&error];
    [[NERtcEngine sharedEngine] muteLocalAudio:NO];
   
    mirc.hidden = YES;
    mircLab.hidden = YES;
    voice.hidden = YES;
    voiceLab.hidden = YES;
    nickName.hidden = YES;

    changeWay.hidden = NO;
    changeWayLab.hidden = NO;
    transLab.hidden = NO;
    transtAudio.hidden = NO;
}

-(void)initTimer{
//    _startTime = [[NSDate date] timeIntervalSince1970];
    self.timer = nil;
    [self.timer invalidate];
    // 通话计时
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callTimerAction:) userInfo:nil repeats:YES];

}

- (void)callTimerAction:(NSTimer *)timer {
    self.timerIndex ++;
    NSString *str = [NSString stringWithFormat:@"%.2d:%.2d", self.timerIndex / 60,self.timerIndex % 60];
    time.text = str;
}
-(void)initContainer{
    self.container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:self.container];
    localView = [[AudioView alloc]initWithFrame:CGRectMake(0, 40, 100, 100)];
    [self.container addSubview:localView];
    remoteView = [[AudioView alloc]initWithFrame:CGRectMake(110, 40, 100, 100)];
    [self.container addSubview:remoteView];
}
-(void)initview{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = kUIColorFromRGB(0x312828);
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    time = [[UILabel alloc]init];
    [bgView addSubview:time];
    time.text = @"等待对方接受";
    time.textColor = [UIColor whiteColor];
    time.layer.zPosition = 20;
    
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(20);
        make.centerX.equalTo(bgView.mas_centerX);
        
    }];
    headImg = [[UIImageView alloc]init];
    [bgView addSubview:headImg];
//    headImg.image = [UIImage imageNamed:@"default_headz"];
    [headImg sd_setImageWithURL:[NSURL URLWithString:self.remoteUser.avatar] placeholderImage: [UIImage imageNamed:@"default_headz"]];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(time.mas_bottom).offset(20);
        make.centerX.equalTo(bgView.mas_centerX);
        make.height.width.equalTo(@50);
    }];
    
    nickName = [[UILabel alloc]init];
    [bgView addSubview:nickName];
    nickName.text = self.remoteUser.nickname;
    nickName.textColor = [UIColor whiteColor];
    nickName.textAlignment = NSTextAlignmentCenter;
    nickName.font = [UIFont systemFontOfSize:14];
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImg.mas_bottom).offset(10);
        make.centerX.equalTo(bgView.mas_centerX);
        make.width.equalTo(@150);
    }];
    if (self.callType == NERtcCallTypeAudio) {
        headImg.hidden = YES;
        
    }else{
        self.container = [[UIView alloc]init];
        
        [bgView addSubview:self.container];
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bgView);
        }];
        localView = [[AudioView alloc]initWithFrame:CGRectMake(20, 10, 100, 100)];
        [self.container addSubview:localView];
        localView.layer.zPosition = 15;
        [localView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.container.mas_top);
            make.right.equalTo(self.container.mas_right);
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(160);
        }];
        remoteView = [[AudioView alloc]initWithFrame:CGRectMake(130, 10, 100, 100)];
        [self.container addSubview:remoteView];
        remoteView.layer.zPosition = 14;
        [remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bgView);
        }];
    }
   
    
    
    

    UIView *bottomView = [[UIView alloc]init];
    [bgView addSubview:bottomView];
    bottomView.userInteractionEnabled = YES;

    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset(-30);
        make.centerX.equalTo(bgView.mas_centerX);
        make.width.equalTo(@270);
        make.height.equalTo(@100);
    }];
    
    mirc = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:mirc];
    [mirc setImage:[UIImage imageNamed:@"mirc"] forState:UIControlStateNormal];
    [mirc setImage:[UIImage imageNamed:@"audio_c"] forState:UIControlStateSelected];

    [mirc addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    mirc.tag = 10;

    
    mircLab = [[UILabel alloc]init];
    [bottomView addSubview:mircLab];
    mircLab.text = @"麦克风已开";
    mircLab.textColor = [UIColor whiteColor];
    mircLab.font = [UIFont systemFontOfSize:12];
    mircLab.textAlignment = NSTextAlignmentCenter;

    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:close];
    [close setImage:[UIImage imageNamed:@"finish_video"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    close.tag = 11;

    UILabel *closeLab = [[UILabel alloc]init];
    [bottomView addSubview:closeLab];
    closeLab.text = @"挂断";
    closeLab.textColor = [UIColor whiteColor];
    closeLab.font = [UIFont systemFontOfSize:12];

    
    voice = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:voice];
    [voice setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [voice addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [voice setImage:[UIImage imageNamed:@"voice_o"] forState:UIControlStateSelected];

    voice.tag = 12;
    voiceLab = [[UILabel alloc]init];
    [bottomView addSubview:voiceLab];
    voiceLab.text = @"扬声器已关闭";
    voiceLab.textAlignment = NSTextAlignmentCenter;

    voiceLab.textColor = [UIColor whiteColor];
    voiceLab.font = [UIFont systemFontOfSize:12];

    [@[mirc,close,voice] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
//        make.width.equalTo(@50);
    }];
    [@[mirc,close,voice] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:60 leadSpacing:0 tailSpacing:0];
    [@[mircLab,closeLab,voiceLab] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(50);
//        make.width.equalTo(@50);
    }];
    [mircLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mirc.mas_centerX);
    }];
    [closeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(close.mas_centerX);
    }];
    [voiceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(voice.mas_centerX);
    }];
//video
    changeWay = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:changeWay];
    [changeWay setImage:[UIImage imageNamed:@"changeWay"] forState:UIControlStateNormal];

    [changeWay addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    changeWay.tag = 15;
    [changeWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mirc);
    }];
    
  changeWayLab = [[UILabel alloc]init];
    [bottomView addSubview:changeWayLab];
    changeWayLab.text = @"切换摄像头";
    changeWayLab.textColor = [UIColor whiteColor];
    changeWayLab.font = [UIFont systemFontOfSize:12];
    changeWayLab.textAlignment = NSTextAlignmentCenter;
    [changeWayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mircLab);
    }];
    
    transtAudio = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:transtAudio];
    [transtAudio setImage:[UIImage imageNamed:@"transeAudio"] forState:UIControlStateNormal];
    [transtAudio addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    transtAudio.tag = 16;
    [transtAudio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(voice);
    }];
   transLab = [[UILabel alloc]init];
    [bottomView addSubview:transLab];
    transLab.text = @"切到语音通话";
    transLab.textAlignment = NSTextAlignmentCenter;

    transLab.textColor = [UIColor whiteColor];
    transLab.font = [UIFont systemFontOfSize:12];
    [transLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(voiceLab);
    }];
   
    
    
   
    
    
    UIButton *small = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:small];
    [small setImage:[UIImage imageNamed:@"trnase_sml"] forState:UIControlStateNormal];
    [small addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    small.tag = 13;
    [small mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(20);
        make.left.equalTo(bgView.mas_left).offset(20);
        make.width.height.equalTo(@40);
    }];
}

-(void)btnClick:(UIButton*)sender
{
    if (sender.tag==11) {
        if (self.status == NERtcCallStatusCalling ) {
            kWeakSelf(self);
            [[NERtcCallKit sharedInstance] cancel:^(NSError * _Nullable error) {
                NSLog(@"cancel error %@",error);
                if (error.code == 20016) {
                    // 邀请已接受 取消失败 不销毁VC
                    NSLog(@"邀请已接受 取消失败 不销毁VC");
                }else {
                    [weakself destroy];
                }
            }];
        }else{
            [[NERtcCallKit sharedInstance] hangup:^(NSError * _Nullable error) {
            }];
            [self destroy];
        }
       
    }else if (sender.tag==13){//scale

        NSInteger type = 2;
        if (self.status == NERtcCallStatusCalling) {
            type=0;
        }else if (self.callType == NERtcCallTypeAudio){
            type=1;
        }else if(self.callType == NERtcCallTypeVideo){
            type=2;
        }
        [DragButton loadViewWithVC:self WithType:type withTimer:self.timerIndex withLocal:self.localUser withRemote:self.remoteUser];

    }else if(sender.tag==10){
        sender.selected =!sender.selected;
    
            [[NERtcCallKit sharedInstance] muteLocalAudio:sender.selected];

            mircLab.text = sender.selected?@"麦克风已关闭":@"麦克风已开";
       
    }else if(sender.tag==12){
        sender.selected =!sender.selected;
        NSError *error = nil;

        [[NERtcCallKit sharedInstance] setLoudSpeakerMode:sender.selected error:&error];
        if (error == nil) {
        }else{
            
        }
        
        voiceLab.text = sender.selected?@"扬声器已开":@"扬声器已关闭";
    }else if(sender.tag==15){//切换摄像头
        sender.selected =!sender.selected;
        [[NERtcCallKit sharedInstance] switchCamera];

    }else if(sender.tag==16){
        sender.enabled = NO;
        sender.selected =!sender.selected;
        kWeakSelf(self);
        [[NERtcCallKit sharedInstance] switchCallType: NERtcCallTypeAudio  completion:^(NSError * _Nullable error) {
            //weakSelf.mediaSwitchBtn.enabled = YES;
            sender.enabled = YES;
            if (error == nil) {
                NSLog(@"切换成功 ");
                [self hideVideoView];
            }else {
                [weakself.view makeToast:[NSString stringWithFormat:@"切换失败:%@", error]];
            }
        }];
    }
}
- (void)willMoveToParentViewController:(UIViewController *)parent
{
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NERtcCallKit sharedInstance] removeDelegate:self];
//    if (self.timer != nil) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
  
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NERtcCallKit sharedInstance] addDelegate:self];
}
#pragma mark - destroy
- (void)destroy
{
    if (self && [self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [[NERtcCallKit sharedInstance] removeDelegate:self];
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
  
}
#pragma mark - NERtcVideoCallDelegate

- (void)onDisconnect:(NSError *)reason {
    [self.view makeToast:@"超时"];
    [self destroy];
}
- (void)onUserEnter:(NSString *)userID {
    [[NERtcCallKit sharedInstance] setupLocalView:localView];
    localView.uid = self.localUser.imAccid;
    [[NERtcCallKit sharedInstance] setupRemoteView:remoteView forUser:userID];
    remoteView.uid = userID;
    self.status = NERtcCallStatusInCall;
//    [self updateUIonStatus:NERtcCallStatusInCall];
    [self initTimer];
}
- (void)onUserAccept:(NSString *)userID;
{
   
}
- (void)onUserCancel:(NSString *)userID {
    [[NERtcCallKit sharedInstance] hangup:^(NSError * _Nullable error) {
    }];
    [self destroy];
}
- (void)onCameraAvailable:(BOOL)available userID:(NSString *)userID {
    [self cameraAvailble:available userId:userID];
}
- (void)onVideoMuted:(BOOL)muted userID:(NSString *)userID {
    [self cameraAvailble:!muted userId:userID];
}
- (void)onCallTypeChange:(NERtcCallType)callType;
{
    [self hideVideoView];
}
- (void)onUserLeave:(NSString *)userID {
    NSLog(@"onUserLeave");
    [self destroy];
}
- (void)onUserDisconnect:(NSString *)userID {
    NSLog(@"onUserDiconnect");
    [self destroy];
}
- (void)onCallingTimeOut {
//    if ([[NetManager shareInstance] isClose] == YES) {
//        //[self.view makeToast:@"网络连接异常，请稍后再试"];
//        [self destroy];
//        return;
//    }
    [self.view makeToast:@"对方无响应"];
    [[NERtcCallKit sharedInstance] cancel:^(NSError * _Nullable error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self destroy];
        });
    }];
}
- (void)onUserBusy:(NSString *)userID {
    [UIApplication.sharedApplication.keyWindow makeToast:@"对方占线"];
    [self destroy];
}
- (void)onCallEnd {
    [self destroy];
}
- (void)onUserReject:(NSString *)userID {
    [UIApplication.sharedApplication.keyWindow makeToast:@"对方已经拒绝"];
    [self destroy];
}
#pragma mark--private
- (void)cameraAvailble:(BOOL)available userId:(NSString *)userId {
//    if ([self.bigVideoView.userID isEqualToString:userId]) {
//        self.bigVideoView.maskView.hidden = available;
//    }
//    if ([self.smallVideoView.userID isEqualToString:userId]) {
//        self.smallVideoView.maskView.hidden = available;
//    }
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
