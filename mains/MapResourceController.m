//
//  MapResourceController.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/21.
//

#import "MapResourceController.h"
//#include "platform/FileUtils.h"
#import <AVKit/AVKit.h>
#import "base/CommonMacros.h"
#import "../ThirdParty/Category/UIView+Frame.h"
#import "CXProvincesMapView/CXProvincesMapView.h"
#import "../ThirdParty/Masonry/Masonry.h"
#import "AudioViewController.h"
#import "view/AlertConfirmView.h"
#import "base/BaseNetWork/HFNetWorkTool.h"
#import "GViewController.h"
#import "GameManager.h"
#import "view/AreaDetailView.h"
#import "VideoViewController.h"
#import "UserViewController.h"
#import <AliyunOSSiOS/OSSService.h>
#import <SSZipArchive/SSZipArchive.h>
#import "GViewController.h"
#import "GameManager.h"
#import "base/User/UserManager.h"
#import "social/FriendListView.h"
#import "social/FriendDataManager.h"
#import "base/ConstMacros.h"
#import "social/model/FriendModel.h"
#import "UIView+Toast.h"
#import "social/HangupView.h"
#import "VideoViewController.h"
#import "social/NTESSessionViewController.h"
#import "social/ChatView.h"
#import "social/RecentView.h"
#import "social/AlertApplyView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define ChatWD 240
#define ChatWD2 340

@interface MapResourceController ()<CXProvincesMapViewDelegate,FriendListViewDelegate,AddFriendViewDelegate,FriendDetailViewDelegate,NERtcCallKitDelegate, NIMChatManagerDelegate,HangupViewDelegate,NIMSystemNotificationManagerDelegate,ChatViewDelegate,AlertApplyViewDeleagte>
{
    UILabel *nameLab;
    AlertConfirmView *downloading;
    NSString *cityStr;
    UIButton  *openButton;
    HangupView *upView;
    NEUser *remoteUser;
    NERtcCallType callType;
    UIImageView *headImg;
}

#import <SDWebImage/UIImageView+WebCache.h>

@property(nonatomic,strong)AVPlayer *moviePlayer;
@property (nonatomic, strong) CXProvincesMapView *chinaMapView;
@property (nonatomic, strong) UIView *bgView;
@property(nonatomic,strong)NSURLSessionDownloadTask *task;
@property(nonatomic,strong)UILabel *progressLab;
@property(nonatomic,strong)OSSClient *client;
//
@property(nonatomic,strong)FriendListView *friendView;
@property(nonatomic,strong)AddFriendView *addFriend;
@property(nonatomic,strong)FriendDetail *detailFriend;
@property(nonatomic,strong)FriendRequstList *requestFriend;
@property(nonatomic,strong)ChatView *chatView ;
@property(nonatomic,strong)RecentView *recentView;
@property(nonatomic,strong)AlertApplyView *applay;
@end

@implementation MapResourceController

- (void)viewDidLoad {
    [super viewDidLoad];
//        BOOL result =   [SSZipArchive unzipFileAtPath:zipFiles toDestination:unZipTo];

   
//    std::string string = cc::FileUtils::getInstance()->getWritablePath();
    NSLog(@"safe===%f==%f",self.additionalSafeAreaInsets.left,self.additionalSafeAreaInsets.top);
    [self login];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview: _bgView];
//    self.bgView.layer.frame = self.view.frame;
    _bgView.backgroundColor =  [UIColor colorWithRed: 1/255.0 green: 50/255.0 blue: 84/255.0 alpha: 1];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSString *mps = [[NSBundle mainBundle]pathForResource:@"bg_video" ofType:@"mp4"];
    NSURL *moview = [NSURL fileURLWithPath:mps];
    // load movie
      self.moviePlayer = [AVPlayer playerWithURL:moview];
    AVPlayerLayer *lay = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    lay.videoGravity = AVLayerVideoGravityResizeAspectFill;
    lay.position = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    lay.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [_bgView.layer addSublayer:lay];
    
//      [self.view sendSubviewToBack:self.moviePlayer.view];
      [self.moviePlayer play];
    
    [self mapView];
//    [self friendViewCreat];
    [self initTop];
    
}

-(void)initTop{
    UIImageView *top = [[UIImageView alloc]init];
    [_bgView addSubview:top];
    top.userInteractionEnabled = YES;
    top.image = [UIImage imageNamed:@"head_bg"];
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView);
        make.right.equalTo(_bgView);
        make.top.equalTo(_bgView);
        make.height.mas_equalTo(@30);
    }];
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = kUIColorFromRGB(0x5DB5FF);
    [_bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView);
        make.right.equalTo(_bgView);
        make.top.equalTo(top.mas_bottom);
        make.height.mas_equalTo(@.5);
    }];
    
    headImg = [[UIImageView alloc]init];
    [top addSubview:headImg];
    headImg.userInteractionEnabled = YES;


    [headImg sd_setImageWithURL:[NSURL URLWithString:[UserManager shraeUserManager].user.headImg] placeholderImage:[UIImage imageNamed:@"default_headz"]];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(top.mas_left).offset(80);
        make.top.bottom.equalTo(top);
        make.width.equalTo(@30);
    }];
    
    
    nameLab = [[UILabel alloc]init];
    nameLab.text = [UserManager shraeUserManager].user.nickname;
    [top addSubview:nameLab];
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont systemFontOfSize:12];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_right).offset(5);
        make.centerY.equalTo(headImg.mas_centerY);
    }];
    
//
    UIImageView *modelImgBg = [[UIImageView alloc]init];
    [_bgView addSubview:modelImgBg];
    modelImgBg.userInteractionEnabled = YES;
    modelImgBg.image = [UIImage imageNamed:@"role_bg"];
    [modelImgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).offset(40);
        make.right.equalTo(_bgView.mas_right).offset(-20);
        make.width.mas_equalTo(119);
        make.height.mas_equalTo(158);
    }];
    
    UIImageView *modelImg = [[UIImageView alloc]init];
    [modelImgBg addSubview:modelImg];
    modelImg.userInteractionEnabled = YES;
    modelImg.contentMode = UIViewContentModeTop;
    modelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"model_b%@",[UserManager shraeUserManager].user.role]];
    modelImg.layer.masksToBounds = YES;
    [modelImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(modelImgBg.mas_centerX);
        make.centerY.equalTo(modelImgBg.mas_centerY);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(128);
    }];
    
    UIButton *editeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modelImgBg addSubview:editeBtn];
    [editeBtn setImage:[UIImage imageNamed:@"edite"] forState:UIControlStateNormal];
    [editeBtn addTarget:self action:@selector(editeClick) forControlEvents:UIControlEventTouchUpInside];
    [editeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(modelImgBg);
        make.width.height.equalTo(@30);
    }];
//
//    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [orderBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    orderBtn.backgroundColor = [UIColor grayColor];
//    [_bgView addSubview:orderBtn];
//    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(modelImgBg.mas_bottom).offset(20);
//        make.right.equalTo(modelImg.mas_right);
//        make.width.height.equalTo(@30);
//    }];
//
//    [orderBtn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];

    
}
//#pragma mark-----order
//-(void)orderClick{
//    OrderViewController *order = [[OrderViewController alloc]init];
//    [self.navigationController pushViewController:order animated:YES];
//}
-(void)editeClick{
    UserViewController *user =[[UserViewController alloc]init];
    [self.navigationController pushViewController:user animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.moviePlayer) {
        [self.moviePlayer play];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.moviePlayer.currentItem];

    }
    if (nameLab) {
        nameLab.text = [UserManager shraeUserManager].user.nickname;
        [headImg sd_setImageWithURL:[NSURL URLWithString:[UserManager shraeUserManager].user.headImg] placeholderImage:[UIImage imageNamed:@"default_headz"]];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.moviePlayer) {
        [self.moviePlayer pause];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)backClick
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:nil];

    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}
-(void)friendViewCreat{
  openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [openButton setImage:[UIImage imageNamed:@"friend_open"] forState:UIControlStateNormal];
    [_bgView addSubview:openButton];
    [openButton addTarget:self action:@selector(friendAction:) forControlEvents:UIControlEventTouchUpInside];
    openButton.layer.zPosition = 30;
    [openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(30);
        make.left.equalTo(self.bgView.mas_left).offset(kTopBarDifHeight);
        make.width.equalTo(@28);
        make.height.equalTo(@54);
    }];
    
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
        _friendView = [[FriendListView alloc]initWithFrame:CGRectMake(-ChatWD, 0, ChatWD, KScreenHeight)];
        [self.view addSubview:_friendView];
        _friendView.delegate = self;
        _friendView.layer.zPosition = 20;
        [_friendView creatView];
        [self requstFriendList];
    }
    if (sender.selected) {
        [self requstFriendList];

        [UIView animateWithDuration:.5 animations:^{
            _friendView.x = kTopBarDifHeight;
            openButton.x =openButton.x + ChatWD;
//            [modelView layoutIfNeeded];
        }];
    }else{
        [self removeSubView];
        [UIView animateWithDuration:.5 animations:^{
            _friendView.x = -ChatWD;
            openButton.x =openButton.x - ChatWD;
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
-(void)mapView
{
    
    self.chinaMapView = [[CXProvincesMapView alloc]initWithFrame:CGRectMake(0, 0, self.bgView.width-100, self.bgView.height-10)];
    _chinaMapView.backgroundColor = [UIColor clearColor];
    _chinaMapView.maximumZoomScale = 1.5;
    _chinaMapView.delegate = self;
    _chinaMapView.centerY = self.bgView.centerY;
    //    _chinaMapView.pinAnimation = NO;
    // 直接设置图片
    //    _chinaMapView.pinImage = [UIImage imageNamed:@"pin"];
    // 添加按钮点击
//    UIButton *pinButton = [[UIButton alloc]initWithFrame:_chinaMapView.pinView.bounds];
//    [pinButton setImage:[UIImage imageNamed:@"pin"] forState:UIControlStateNormal];
//    [pinButton addTarget:self action:@selector(pinTest) forControlEvents:UIControlEventTouchUpInside];
//    [_chinaMapView.pinView addSubview:pinButton];
    
    [_bgView addSubview:_chinaMapView];
}
//循环播放
-(void)playFinished
{
       CGFloat a=0;
       NSInteger dragedSeconds = floorf(a);
       CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.moviePlayer seekToTime:dragedCMTime];
    [self.moviePlayer play];
}

- (void)selectProvinceAtIndex:(NSInteger)index andName:(NSString *)name {
    NSLog(@"Province - %ld - %@", (long)index, name);
    self.title = [NSString stringWithFormat:@"Province - %ld - %@", (long)index, name];

    cityStr = name;
//    根据文件状态显示不同页面 不存在 去下载
    [self fileStatusName:name];
   
    
}

-(void)creatLoadingView{
    downloading = [[AlertConfirmView alloc]initWithFrame:self.view.frame withType:1];
    [downloading showPopView];
    
  
}

-(void)downLoadResource{
//    "bucket_name": "tide-scene",
//            "access_id": "LTAI5tN2iehHzgE9bYaUoLQp",
//            "access_secret": "86jzC7rRRsrCxFwv1JK4vVa72tiQDT",
//            "end_point": "oss-cn-shanghai.aliyuncs.com"
//    demo/bundle2.zip 和 demo/bundle1.zip
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    request.bucketName = bucket_name;
    NSString *keys = [NSString stringWithFormat:@"%@MainScene.zip",ResourcePath];
    request.objectKey = keys;
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        // 当前下载长度、当前已下载总长度、待下载的总长度。
        NSLog(@"progress===%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        dispatch_sync(dispatch_get_main_queue(), ^{
            CGFloat percent =(CGFloat) totalBytesWritten/totalBytesExpectedToWrite;
            NSLog(@"downloading====%.2f",percent);
            downloading.progress.progress = percent;
          
          

        });
       
    };

    id<OSSCredentialProvider> credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        // 按照OSS规定的签名算法加签字符串，并将得到的加签字符串拼接AccessKeyId后返回。
        // 将加签的字符串传给您的服务器，然后返回签名。
        // 如果因某种原因加签失败，服务器描述错误信息后返回nil。
    NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:access_secret]; // 此处为用SDK内的工具函数进行本地加签，建议您通过业务server实现远程加签。
        if (signature != nil) {
            *error = nil;
        } else {
//            *error = [NSError errorWithDomain:@"<your domain>" code:-1001 userInfo:@"error"];
            return nil;
        }
        return [NSString stringWithFormat:@"OSS %@:%@", access_id, signature];
    }];
    
    _client = [[OSSClient alloc]initWithEndpoint:end_point credentialProvider:credential];
    OSSTask * getTask = [_client getObject:request];
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
            [self downLoadSaveTopath:getResult.downloadedData];

        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
        }
        return nil;
    }];

    
//    __weak typeof(self) weakself = self;//ARC
//    _task = [HFNetWorkTool downloadWithURL:@"http://47.95.33.204/bundle/bundle1.zip" fileDir:@"pathToBundle" progress:^(NSProgress *progress) {
//        weakself.progressLab.text = [NSString stringWithFormat:@"%f",progress.fractionCompleted];
//    } success:^(NSString *filePath) {
//        AlertConfirmView *confirm = [[AlertConfirmView alloc]initWithFrame:self.view.frame withType:3];
//        [confirm showPopView];
//        kWeakSelf(self);
//        confirm.verfySuccess = ^{
////            exit(0);
//            [[GameManager getInstance]didlanunchWith:@{}];
//            UIWindow *winwow = [UIApplication sharedApplication].windows[0];
//            GViewController *vv = [[GViewController alloc]init];
//            [winwow setRootViewController:vv];
//        };
//    } failure:^(NSError *error) {
//        NSLog(@"pro===%@",error);
//
//    }];
}
-(void)fileStatusName:(NSString*)name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"pathToBundle"];
     BOOL directory = NO;
    if ([fileManager fileExistsAtPath:downloadDir] ) {//存在 显示数据页面
            AreaDetailView *detail = [[AreaDetailView alloc]initWithFrame:self.view.frame withCity:name];
            [detail showPopView];
        detail.gogame = ^{
            [[GameManager getInstance]didlanunchWith:@{}];
            UIWindow *winwow = [UIApplication sharedApplication].windows[0];
            if ( [GameManager getInstance].gv) {
        //        self.view = [GameManager getInstance].gv.view;
                [winwow setRootViewController:[GameManager getInstance].gv];

            }else{
                GViewController *vv = [[GViewController alloc]init];
                [winwow setRootViewController:vv];
            }
        
        };


    }else{
        AlertConfirmView *confirm = [[AlertConfirmView alloc]initWithFrame:self.view.frame withType:0];
        [confirm showPopView];
       confirm.tipLab.text = [NSString stringWithFormat:@"即将链接【%@】世界数据，消耗528M流量，是否继续",name];
        kWeakSelf(self);
        confirm.verfySuccess = ^{
            [weakself creatLoadingView];

            [weakself downLoadResource];
        };
    }
}
//下载成功保存
-(void)downLoadSaveTopath:(NSData*)resData{
    dispatch_sync(dispatch_get_main_queue(), ^{
        downloading.tipLab1.hidden = NO;
    });
    NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"pathToBundle"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建Download目录
    [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
    //拼接文件路径
    NSString *filePath = [downloadDir stringByAppendingPathComponent:@"MainScene.zip"];
    
//            BOOL isSuccess =  [getResult.downloadedData writeToFile:downloadDir options:0 error:nil];

    BOOL isSuccess1 =   [resData writeToURL:[NSURL fileURLWithPath:filePath] atomically:YES];
    NSLog(@"down==%@",downloadDir);
//
    NSLog(@"su==%d",isSuccess1);
  BOOL depres =  [self decompressionFileToPath:@"" filePath:@""];
    if (depres) {//删除zip
        BOOL isDelete =  [fileManager removeItemAtPath:filePath error:nil];
        NSLog(@"delet===%d",isDelete);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [downloading hidePopView];
            AlertConfirmView *confirm = [[AlertConfirmView alloc]initWithFrame:self.view.frame withType:2];
            confirm.tipLab.text = [NSString stringWithFormat:@"【%@】数据已链接完成",cityStr];
            [confirm showPopView];
            confirm.verfySuccess = ^{
                [[GameManager getInstance]didlanunchWith:@{}];
                UIWindow *winwow = [UIApplication sharedApplication].windows[0];
                GViewController *vv = [[GViewController alloc]init];
                [winwow setRootViewController:vv];
            };
        
        });
    
    }
}
- (BOOL)decompressionFileToPath:(NSString *)targetDir filePath:(NSString *)filePath

{

//    ZipArchive* zipFile = [[ZipArchive alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        NSString* zipFiles = [documentPath stringByAppendingString:@"/pathToBundle/MainScene.zip"] ;
        NSString* unZipTo = [documentPath stringByAppendingString:@"/pathToBundle"] ;

    BOOL result =   [SSZipArchive unzipFileAtPath:zipFiles toDestination:unZipTo];
    

    return result;

}

#pragma mark---delegate frindlist
-(void)friendListClickWith:(NSInteger)tag withId:(NSString *)userId
{
    if (tag==0) {//好友申请
        [UIView animateWithDuration:.5 animations:^{
            _friendView.x = -ChatWD;
        } completion:^(BOOL finished) {
            _requestFriend = [[FriendRequstList alloc]initWithFrame:CGRectMake(kTopBarDifHeight, 0, ChatWD,KScreenHeight)];
            [self.view addSubview:_requestFriend];
            _requestFriend.delegate = self;
            [self requstRequestFDList];
//            [_requestFriend creatView];
        }];
    }else if(tag==1){//添加好友
        [UIView animateWithDuration:.5 animations:^{
            _friendView.x = -ChatWD;
        } completion:^(BOOL finished) {
            _addFriend = [[AddFriendView alloc]initWithFrame:CGRectMake(kTopBarDifHeight, 0, ChatWD,KScreenHeight)];
            [self.view addSubview:_addFriend];
            _addFriend.delegate = self;
            [_addFriend creatView];
        }];
    }else if (tag==10){//语音
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
        video.callType = NERtcCallTypeAudio;
        video.status = NERtcCallStatusCalling;
        [window.rootViewController presentViewController:video animated:YES completion:nil];

    }else if(tag==11){//视频
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
        _chatView  = [[ChatView alloc]initWithSession:session WithFrame:CGRectMake(kTopBarDifHeight+ChatWD, 0, ChatWD2,KScreenHeight)];
         [self.view addSubview:_chatView];
        _chatView.layer.zPosition = 16;

         _chatView.delegate = self;
         [_chatView loadView];
    } completion:^(BOOL finished) {
        if(openButton.x<ChatWD+ChatWD2){
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
        _chatView  = [[ChatView alloc]initWithSession:session WithFrame:CGRectMake(kTopBarDifHeight+ChatWD, 0, ChatWD2,KScreenHeight)];
         [self.view addSubview:_chatView];
         _chatView.delegate = self;
        _chatView.layer.zPosition = 16;

         [_chatView loadView];
    } completion:^(BOOL finished) {
      
        if(openButton.x<ChatWD+ChatWD2){
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
            openButton.x =openButton.x + ChatWD;
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
                openButton.x =openButton.x + ChatWD;
            }
        }];
    }
}
//选择列表 跳转到好友详情页
-(void)didSelectWithModel:(SearchResultModel *)model
{
//    _addFriend.hidden = YES;
//    _detailFriend = [[FriendDetail alloc]initWithFrame:CGRectMake(kTopBarDifHeight, 30, ChatWD,KScreenHeight-40)];
//    _detailFriend.delegate = self;
//    _detailFriend.status = 0;
//    _detailFriend.model = model;
//    [self.view addSubview:_detailFriend];
//    [_detailFriend creatView];
    
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
    _detailFriend = [[FriendDetail alloc]initWithFrame:CGRectMake(kTopBarDifHeight, 30, ChatWD,KScreenHeight-40)];
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
        
    }else if(tag==1){
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
        
        _addFriend = [[AddFriendView alloc]initWithFrame:CGRectMake(kTopBarDifHeight, 0, ChatWD,KScreenHeight)];
        [self.view addSubview:_addFriend];
        _addFriend.delegate = self;
        [_addFriend creatView];
        
        
    }else if(tag==3){
        if (_requestFriend) {
            [_requestFriend removeFromSuperview];
            _requestFriend = nil;
        }
        _detailFriend = [[FriendDetail alloc]initWithFrame:CGRectMake(kTopBarDifHeight, 30, ChatWD,KScreenHeight-40)];
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
            [self.view makeToast:@"发送成功"];
            [self addFriend:userid];
         }else{
             [self.view makeToast:responseObject[@"msg"]];

         }
        } failure:^(NSError *error) {
            
        }];
}
-(void)acceptRequesWithId:(NSString*)userid{
    [HFNetWorkTool POST:acceptRequest parameters:@{@"apply_uuid":userid} currentViewController:nil success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
            [self.view makeToast:@"发送成功"];
        }else{
            [self.view makeToast:responseObject[@"msg"]];

        }
        } failure:^(NSError *error) {
            
        }];
}
-(void)refuseRequestWithId:(NSString*)userid{
    [HFNetWorkTool POST:refusetRequest parameters:@{@"apply_uuid":userid} currentViewController:nil success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
            [self.view makeToast:@"发送成功"];
         }else{
             [self.view makeToast:responseObject[@"msg"]];

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
          
            NEUser *user = [[NEUser alloc] init];
            user.imAccid =@"2";
            user.avatar = @"";
            VideoViewController *callVC = [[VideoViewController alloc] init];
            callVC.localUser = user;
            callVC.remoteUser = remoteUser;
            callVC.status = NERtcCallStatusInCall;
            callVC.callType = callType;
            callVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self.navigationController presentViewController:callVC animated:YES completion:nil];
           
        }
    }];

        
    }
}

-(void)initObserver{
    [[NERtcCallKit sharedInstance] addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];

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
            remoteUser.nickname = imUser.userInfo.nickName;
            NEUser *user = [[NEUser alloc] init];
            user.imAccid =[UserManager shraeUserManager].user.uuid;
            user.avatar = [UserManager shraeUserManager].user.headImg;
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
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    NSLog(@"---------接收到通知===%ld",unreadCount);
  NSArray *friends =  [[NIMSDK sharedSDK].userManager myFriends];
    NSLog(@"---------好友liebiao===%ld",friends.count);
    [_friendView friendRequestChanged];

}


#pragma mark-------11111
-(void)addFriend:(NSString*)userid{
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = userid;
    request.operation = NIMUserOperationAdd;
    __weak typeof(self) wself = self;

    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
        if (!error) {
            [self.view makeToast:@"success"
                         duration:2.0f
                         position:CSToastPositionCenter];
//            [wself refresh];
        }else{
            [wself.view makeToast:@"fail"
                         duration:2.0f
                         position:CSToastPositionCenter];
        }
    }];
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
