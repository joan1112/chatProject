//
//  DragButton.m
//  NERTC1to1Sample
//
//  Created by junqiang on 2022/5/7.
//  Copyright © 2022 丁文超. All rights reserved.
//

#import "DragButton.h"
#import "UIView+Toast.h"
static DragButton* dragView = nil;

@interface DragButton()<NERtcCallKitDelegate>
{
    
    CGPoint startLocation;
    NSString *_action;
    void(^_actionBlock)(void);
    CGRect _frame;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timerIndex;
@property (nonatomic, assign) NSInteger type;

@end
@implementation DragButton


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMe)];
        [self addGestureRecognizer:tap];
        _frame  = frame;
        
        [[NERtcCallKit sharedInstance] addDelegate:self];

        
    }
    return self;
}
-(void)loadView{

    
    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _frame.size.width, _frame.size.height)];
    bgImg.image = [UIImage imageNamed:@"pop_bg"];
    [self addSubview:bgImg];
//        audio_pop video_pop
    UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(35, 20, 30,30 )];
    [bgImg addSubview:iconImg];
    iconImg.image = [UIImage imageNamed:@"audio_pop"];
    iconImg.contentMode = UIViewContentModeScaleAspectFit;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _frame.size.height-40, _frame.size.width, 20)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:12.f];
    _titleLabel.textColor = [UIColor whiteColor];
    [bgImg addSubview:_titleLabel];
    if (self.type==0) {
        _titleLabel.text = @"等待接听";
    }else{
        [self initTimer];
        _titleLabel.text = @"";

    }
}
+(DragButton *)shraeUserManager
{
    if (dragView==nil) {
        CGFloat wd = [UIScreen mainScreen].bounds.size.width;
        dragView = [[DragButton alloc]initWithFrame:CGRectMake(wd-160, 30, 100, 100)];
       
    
    }
    return dragView;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}

-(void)setTitleLabel:(UILabel *)titleLabel{
    
    _titleLabel = titleLabel;
}
-(void)initTimer{
//    _startTime = [[NSDate date] timeIntervalSince1970];
    
//    self.timerIndex = 0;
    // 通话计时
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callTimerAction:) userInfo:nil repeats:YES];

}

- (void)callTimerAction:(NSTimer *)timer {
    self.timerIndex ++;
    NSString *str = [NSString stringWithFormat:@"%.2d:%.2d", self.timerIndex / 60,self.timerIndex % 60];
    _titleLabel.text = str;
}
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - startLocation.x;
    float dy = pt.y - startLocation.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    //
    float halfx = CGRectGetMidX(self.bounds);
    newcenter.x = MAX(halfx, newcenter.x);
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    //
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    //
    self.center = newcenter;
}

+(void)loadViewWithVC:(VideoViewController*)VC WithType:(NSInteger)type withTimer:(int)timer withLocal:(nonnull NEUser *)user withRemote:(nonnull NEUser *)user1;
{
    dragView = [DragButton shraeUserManager];
    dragView.presentVC = VC;
    dragView.type = type;
    dragView.timerIndex = timer;
    dragView.localUser = user;
    dragView.remoteUser = user1;
    [dragView loadView];
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window addSubview:dragView];
    [VC dismissViewControllerAnimated:NO completion:nil];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self changeLocation];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self changeLocation];
}

-(void)changeLocation{
    
    CGPoint point = self.center;
    if (point.x>[self superview].frame.size.width/2.0) {
        [UIView animateWithDuration:0.2 animations:^{
            
//            self.frame.origin.x = ;

            self.frame = CGRectMake([self superview].frame.size.width-self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{

            self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        }];
    }
}

-(void)tapMe {
    
//    debugLog(@"touch float icon ....");
//    if (![NSString IsNullOrWhiteSpace:_action]) {
//        //注：这里我删掉两行跟业务有关的代码
//    }
    
   
    UIWindow *window = [UIApplication sharedApplication].windows[0];
//    [window addSubview:dragView];
    dragView.presentVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    dragView.presentVC.localUser = self.localUser;
//    dragView.presentVC.remoteUser = self.remoteUser;
//    dragView.presentVC.status = NERtcCallStatusInCall;
//    dragView.presentVC.callType = NERtcCallTypeVideo;
    [dragView.presentVC reloadTimer:_timerIndex];
    [dragView.presentVC loadRemoteView];
    [window.rootViewController presentViewController:dragView.presentVC animated:NO completion:^{
        for (UIView *subview in window.subviews) {
            if (subview == dragView) {
                dragView.presentVC = nil;
                [dragView removeFromSuperview];
                dragView = nil;
                [self.timer invalidate];
                self.timer = nil;
                [[NERtcCallKit sharedInstance] removeDelegate:self];

            }
        }
    }];
    if(_actionBlock){ _actionBlock(); }
}

-(void)setAction:(NSString *)action {
    _action = action;
}

-(void)setActionBlock:(void (^)(void))block {
    _actionBlock = block;
}
-(void)destry
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];

    for (UIView *subview in window.subviews) {
        if (subview == dragView) {
            dragView.presentVC = nil;
            [dragView removeFromSuperview];
            dragView = nil;
            [self.timer invalidate];
            self.timer = nil;
            [[NERtcCallKit sharedInstance] removeDelegate:self];

            
        }
    }
}
#pragma mark - NERtcVideoCallDelegate

- (void)onDisconnect:(NSError *)reason {
    [self destry];
}
- (void)onUserEnter:(NSString *)userID {
   
    self.presentVC.status = NERtcCallStatusInCall;
    self.presentVC.remoteUser.imAccid = userID;
//    [self updateUIonStatus:NERtcCallStatusInCall];
    [self initTimer];
}
- (void)onUserAccept:(NSString *)userID;
{
   
}
- (void)onUserCancel:(NSString *)userID {
    [[NERtcCallKit sharedInstance] hangup:^(NSError * _Nullable error) {
    }];
    [self destry];
}
- (void)onCameraAvailable:(BOOL)available userID:(NSString *)userID {

}
- (void)onVideoMuted:(BOOL)muted userID:(NSString *)userID {

}
- (void)onCallTypeChange:(NERtcCallType)callType;
{
    self.presentVC.callType = NERtcCallTypeAudio;
}
- (void)onUserLeave:(NSString *)userID {
    NSLog(@"onUserLeave");
    [self destry];
}
- (void)onUserDisconnect:(NSString *)userID {
    NSLog(@"onUserDiconnect");
    [self destry];
}
- (void)onCallingTimeOut {

    [[NERtcCallKit sharedInstance] cancel:^(NSError * _Nullable error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self destry];
        });
    }];
}
- (void)onUserBusy:(NSString *)userID {
    [UIApplication.sharedApplication.keyWindow makeToast:@"对方占线"];
    [self destry];
}
- (void)onCallEnd {
    [self destry];
}
- (void)onUserReject:(NSString *)userID {
    [UIApplication.sharedApplication.keyWindow makeToast:@"对方已经拒绝"];
    [self destry];
}
@end
