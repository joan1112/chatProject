//
//  UserViewController.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/26.
//

#import "UserViewController.h"
#import "base/CommonMacros.h"
#import "../ThirdParty/Category/UIView+Frame.h"
#import "../ThirdParty/Masonry/Masonry.h"
#import "view/BaseInfoView.h"
#import "base/User/UserManager.h"
#import "view/AlertChangeNickView.h"
#import "LoginViewController.h"
#import "../ThirdParty/Category/UIView+Alert.h"
#import "base/BaseNetWork/HFNetWorkTool.h"
#import "base/ConstMacros.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <AVKit/AVKit.h>
#import <NIMSDK/NIMSDK.h>
#import <AliyunOSSiOS/OSSService.h>
#import "SDWebImageManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UserViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
{
    UIImageView *_bgView;
    UIButton *btnSelect;
    UIButton *open;
    UIView *modelView;
    UILabel *nameLab;
}
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)BaseInfoView *baseInfo;
@property(nonatomic,strong)AVPlayer *moviePlayer;
@property(nonatomic,strong)AVPlayerLayer *avlay;
@property(nonatomic,strong)OSSClient *client;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
  
}

-(void)initView{
    _bgView = [[UIImageView alloc]init];
    [self.view addSubview:_bgView];
    _bgView.userInteractionEnabled = YES;
    _bgView.image = [UIImage imageNamed:@"user_bg"];
    _bgView.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
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
    
    UIImageView *headImg = [[UIImageView alloc]init];
    [top addSubview:headImg];
    headImg.userInteractionEnabled = YES;
//    headImg.image = [UIImage imageNamed:@"default_headz"];
//tide01.oss-cn-shanghai.aliyuncs.com/user/kashkjaksjahead.png
    [headImg sd_setImageWithURL:[NSURL URLWithString:[UserManager shraeUserManager].user.headImg] placeholderImage:[UIImage imageNamed:@"default_headz"]];
//    headImg.backgroundColor = [UIColor whiteColor];
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
    UIButton *close  = [UIButton buttonWithType:UIButtonTypeCustom];
    [top addSubview:close];
    close.backgroundColor = kUIColorFromRGB(0x2C7EBE);
    [close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(top.mas_bottom).offset(0);
        make.right.equalTo(top.mas_right).offset(-40);
        make.width.equalTo(@30);
        make.height.mas_equalTo(30);
    }];
    [close addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc]init];
    [_bgView addSubview:rightView];
    rightView.layer.zPosition = 20;
    rightView.backgroundColor = kUIColorFromRGB(0x436496);
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(_bgView);
        make.width.mas_equalTo(106);
        make.top.equalTo(_bgView).offset(30);
        
    }];
    
    for (int i =0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addSubview:btn];
        btn.frame = CGRectMake(0, 20+i*60, 106, 40);
        [btn  setBackgroundImage:[UIImage imageNamed:@"bg_normal"] forState:UIControlStateNormal];
        [btn  setBackgroundImage:[UIImage imageNamed:@"bg_select"] forState:UIControlStateSelected];;

        [btn setTitle:@[@"基本信息",@"设置",@"关于TIDE"][i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i==0) {
            btnSelect = btn;
            btn.selected = YES;
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+10;
    }
    [self modelView];
     open = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:open];
    [open setImage:[UIImage imageNamed:@"open_page"] forState:UIControlStateNormal];
    [open addTarget:self action:@selector(openView) forControlEvents:UIControlEventTouchUpInside];
    open.frame = CGRectMake(KScreenWidth-106-30, (KScreenHeight-60)/2 , 30, 60);
    open.layer.zPosition = 30;
    
    [self openView];
//    [open mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(rightView.mas_left);
//        make.centerY.equalTo(rightView.mas_centerY);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(60);
//    }];
    
}

-(void)modelView{
    if(!modelView){
        modelView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, KScreenWidth-106, self.view.height-30)];
        [_bgView addSubview:modelView];
        modelView.layer.zPosition = 20;
        modelView.userInteractionEnabled = YES;
        UIImageView *shadowImg = [[UIImageView alloc]init];
        [modelView addSubview:shadowImg];
//        shadowImg.image = [UIImage imageNamed:@"shdow"];
        [shadowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(modelView.mas_centerX);
            make.bottom.equalTo(modelView.mas_bottom);
            make.width.equalTo(@440);
            make.height.equalTo(@(440/2.8));
            
        }];
        
        UIImageView *modelImg = [[UIImageView alloc]init];
        [modelView addSubview:modelImg];
        modelImg.contentMode = UIViewContentModeScaleAspectFit;
        modelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"model_b%@",[UserManager shraeUserManager].user.role]];
        [modelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(modelView.mas_centerX).offset(-15);
            make.bottom.equalTo(modelView.mas_bottom).offset(-45*SCALE);
            make.width.mas_equalTo(260);
            make.height.lessThanOrEqualTo(@(self.view.height-110));

        }];
    }
    
}
-(void)creatVideo{
    NSString *mps = [[NSBundle mainBundle]pathForResource:@"into_tid" ofType:@"mp4"];
    NSURL *moview = [NSURL fileURLWithPath:mps];
    // load movie
      self.moviePlayer = [AVPlayer playerWithURL:moview];
    _avlay = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    _avlay.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _avlay.position = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    _avlay.frame = CGRectMake(0, 30, _bgView.width-106, _bgView.height-30);
    [_bgView.layer addSublayer:_avlay];
//      [self.view sendSubviewToBack:self.moviePlayer.view];
      [self.moviePlayer play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.moviePlayer.currentItem];
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
-(void)btnClick:(UIButton*)sender
{
    
    if (btnSelect!=sender) {
        btnSelect.selected = !btnSelect.selected;
        sender.selected = YES;
        btnSelect = sender;
    }
    if (sender.tag==12) {
        [self creatVideo];
        if (_isOpen) {
            [self openView];
            modelView.hidden = YES;
            open.hidden = YES;
        }
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        if (self.moviePlayer) {
            [self.moviePlayer pause];
            [_avlay removeFromSuperlayer];
            self.moviePlayer = nil;
        }
        modelView.hidden = NO;
        open.hidden = NO;

        if (self.isOpen) {
            [self creatBaseInfoWithStatus:0];
            [_bgView addSubview:_baseInfo];
           
        }else{
            [self openView];
        }
    }
    
    
    
}
-(void)creatBaseInfoWithStatus:(NSInteger)type
{
    CGFloat x = KScreenWidth;
    if (type==0) {
        x = KScreenWidth-106-10-230;
        if (_baseInfo ) {
            [_baseInfo removeFromSuperview];
            _baseInfo = nil;
        }
    }
   
    _baseInfo = [[BaseInfoView alloc]initWithFrame:CGRectMake(x, 60, 230, KScreenHeight-120)];
    _baseInfo.centerY= KScreenHeight/2;
    _baseInfo.layer.zPosition = 19;
    if (btnSelect.tag==10) {
        [_baseInfo creatInfoView];
//            修改昵称
        kWeakSelf(self);
        _baseInfo.userInfoAction = ^(NSInteger tag) {
            
            if (tag==0) {
                AlertChangeNickView *nickV = [[AlertChangeNickView alloc]initWithFrame:weakself.view.frame];
                [nickV showPopView];
                nickV.verfySuccess = ^(NSString * _Nonnull name) {
                    [weakself changeNickWith:name];
                };
            }else{
                [weakself takePhotoClick];
            }
          
        };

    }else if (btnSelect.tag==11){
        [_baseInfo creatSetingView];
     
//                退出登录
            kWeakSelf(self);
            _baseInfo.logoutAction = ^{
                
                UIAlertAction *ac = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LoginViewController *login = [[LoginViewController alloc]init];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
                    UIWindow *windows = [UIApplication sharedApplication].windows[0];
                    windows.rootViewController = nav;
                    [[UserManager shraeUserManager] logout];
                }];
                [weakself.view showAlertWithTitle:@"提示" message:@"确认退出登录" cancelAction:ac confirmAction:confirm];
                
              
            
            };
    
        

    }else{
        [_baseInfo creatAboutView];
    }

}
-(void)openView
{
    self.isOpen = !self.isOpen;
    if (self.isOpen) {
        [self creatBaseInfoWithStatus:1];
//        [modelView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(KScreenWidth-106-230);
//            }];
        [_bgView addSubview:_baseInfo];
        [UIView animateWithDuration:.5 animations:^{
            _baseInfo.x = KScreenWidth-106-10-230;
            open.x = KScreenWidth-106-10-230-30;
//            [modelView layoutIfNeeded];
            modelView.width = KScreenWidth-106-230;
        }];
    }else{
//        [modelView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(KScreenWidth-106);
//            }];
        [UIView animateWithDuration:.5 animations:^{
                    _baseInfo.x = KScreenWidth;
                    open.x = KScreenWidth-106-30;
//            [modelView.superview layoutIfNeeded];

            modelView.width = KScreenWidth-106;
                } completion:^(BOOL finished) {
                    _baseInfo = nil;
                    [_baseInfo removeFromSuperview];
                }];
       
    }
   
}
-(void)changeNickWith:(NSString*)nick
{
    kWeakSelf(self);
    [self showHUDWithText:@"更新中"];
    [HFNetWorkTool POST:userInfo parameters:@{@"nickname":nick,@"role":[UserManager shraeUserManager].user.role,@"uuid":[UserManager shraeUserManager].user.uuid} currentViewController:self success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        [self hideHUD];

        if ([responseObject[@"code"] intValue]==200) {

            [weakself showToastWithText:@"修改成功"];
            UserModel *user =  [UserManager shraeUserManager].user;
            user.nickname = nick;
            [[UserManager shraeUserManager]setUser:user];
            [self reloadView];
            
        }else{
            [weakself showToastWithText:responseObject[@"msg"]];

        }
        
        } failure:^(NSError *error) {
            [self hideHUD];
        }];
}

-(void)closeClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)reloadView{
    nameLab.text = [UserManager shraeUserManager].user.nickname;
    [_baseInfo reloadSubView];

}


//上传头像
-(void)takePhotoClick
{
     UIAlertController *control = [UIAlertController alertControllerWithTitle:@"请选择上传方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
       UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self pickPhoto];
       }];
       UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
           UIImagePickerController *controller = [[UIImagePickerController alloc]init];

           if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
           {
               controller.sourceType = UIImagePickerControllerSourceTypeCamera;
           }
           else
           {
               return;
           }
           controller.allowsEditing = YES;
           controller.delegate = self;
           [self presentViewController:controller animated:YES completion:nil];
           
           
       }];
       UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
       }];
       [control addAction:action1];
       [control addAction:action2];
       [control addAction:action3];

       [self presentViewController:control animated:YES completion:nil];
}

-(void)pickPhoto{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];

    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count>0) {
//            [self uploadImage:photos[0]];
            [self uploadoss:photos[0]];
        }

    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
////点击取消时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//选择图片的时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = [self compressImageWithImage:img];
//    [self uploadImage:img];
    [self uploadoss:img];

 

    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//压缩图片,确保图片小于500KB
-(NSData*)compressImageWithImage:(UIImage*)image
{
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    
    float length = ((float)imageData.length)/1024.00;
    
    if (length>500) {
        
        CGFloat t = 500/length;
        
        imageData = UIImageJPEGRepresentation(image, t);
    }
    
    return imageData;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)uploadoss:(UIImage *)data{
    //
    [self showHUDWithText:@"上传中"];

   // bucketName tide01
//#define access_id @"LTAI5tN2iehHzgE9bYaUoLQp"
//#define access_secret @"86jzC7rRRsrCxFwv1JK4vVa72tiQDT"
//#define end_point @"oss-cn-shanghai.aliyuncs.com"
   
    __weak typeof(self) wself = self;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    //[NSUUID UUID].UUIDString
    NSString *imageFileName = [NSString stringWithFormat:@"user/%@.png",[[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = @"tide01";
    
    put.objectKey = [NSString stringWithFormat:@"%@",imageFileName];
//    put.acl = @"public-read-write";
    put.contentType = @"image/png";

    NSData *imageData = UIImageJPEGRepresentation(data,1.f);
//    put.contentMd5 = [OSSUtil base64Md5ForData:imageData];
    put.uploadingData  =  imageData;
    //tide01.oss-cn-shanghai.aliyuncs.com/user/kashkjaksjahead.png
    id<OSSCredentialProvider> credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        // 按照OSS规定的签名算法加签字符串，并将得到的加签字符串拼接AccessKeyId后返回。
        // 将加签的字符串传给您的服务器，然后返回签名。
        // 如果因某种原因加签失败，服务器描述错误信息后返回nil。
    NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:@"jfUbeUvvqjJdQJn80u5LpXYl1WXr77"]; // 此处为用SDK内的工具函数进行本地加签，建议您通过业务server实现远程加签。
        if (signature != nil) {
            *error = nil;
        } else {
//            *error = [NSError errorWithDomain:@"<your domain>" code:-1001 userInfo:@"error"];
            return nil;
        }
        return [NSString stringWithFormat:@"OSS %@:%@", @"LTAI5tRSL2RuyT7cBFSQRtrM", signature];
    }];
    
    _client = [[OSSClient alloc]initWithEndpoint:end_point credentialProvider:credential];
    OSSTask * putTask = [_client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
            OSSGetObjectResult * getResult = task.result;
            NSLog(@"result===%@",getResult);
            NSString *url = [NSString stringWithFormat:@"http://%@/%@",@"tide01.oss-cn-shanghai.aliyuncs.com",imageFileName];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
             
                [self hideHUD];
                [self updateHeadImgWith:url];
            });
           

        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}
-(void)uploadImage:(UIImage *)data{
    [HFNetWorkTool uploadImagesWithURL:uploadImgae parameters:nil name:@"image" images:@[data] fileNames:@[@"head"] imageScale:1 imageType:@"png" progress:^(NSProgress *progress) {
        NSLog(@"pro");
        } success:^(id responseObject) {
            NSLog(@"res===%@",responseObject);
            NSDictionary *datas = responseObject[@"data"];
            [self updateHeadImgWith:datas[@"url"]];
        } failure:^(NSError *error) {
            NSLog(@"error===%@",error);

        }];
       
}
-(void)updateHeadImgWith:(NSString*)url
{
    kWeakSelf(self);
    NSLog(@"url====%@",url);
    [self showHUDWithText:@"更新中"];
    [HFNetWorkTool POST:userInfo parameters:@{@"nickname":[UserManager shraeUserManager].user.nickname,@"role":[UserManager shraeUserManager].user.role,@"uuid":[UserManager shraeUserManager].user.uuid,@"picture":url} currentViewController:self success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        [self hideHUD];

        if ([responseObject[@"code"] intValue]==200) {

            [weakself showToastWithText:@"修改成功"];
            UserModel *user =  [UserManager shraeUserManager].user;
            user.headImg = url;
            [[UserManager shraeUserManager]setUser:user];
            [self reloadView];
            [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagAvatar):url} completion:^(NSError *error) {
                if (!error) {
//                    [weakself showToastWithText:@"IM修改成功"];

                }else{
                  
                } }];
            
        }else{
            [weakself showToastWithText:responseObject[@"msg"]];

        }
        
        } failure:^(NSError *error) {
            [self hideHUD];
        }];
}

-(void)getDocumentPath:(NSString*)fileName{
    
}
@end
