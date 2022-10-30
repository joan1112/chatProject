//
//  LoginViewController.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/20.
//

#import "LoginViewController.h"
#import "../ThirdParty/Masonry/Masonry.h"
#import "../ThirdParty/Category/UIView+Frame.h"
#import "../ThirdParty/Category/UIView+Alert.h"
#import "base/CommonMacros.h"
#import "GViewController.h"
#import "GameManager.h"
#import "MapResourceController.h"
#import "base/BaseNetWork/HFNetWorkTool.h"
#import "base/ConstMacros.h"
#import <UMShare/UMShare.h>
#import "ChooseModelController.h"
#import "base/User/UserManager.h"
#import "ProtolViewController.h"
@interface LoginViewController ()
{
    BOOL isagree;
}
//@property (strong, nonatomic) AgoraRtmKit *signalEngine;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    NSLog(@"URL===%@",mainServerURL);


}
//- (AgoraRtmKit *)signalEngine {
//    if (!_signalEngine) {
//        _signalEngine = [[AgoraRtmKit alloc] initWithAppId:@"" delegate:nil];
//    }
//    return _signalEngine;
//}
-(void)loginChat{
//    __weak typeof(self) weakSelf = self;
//    [self.signalEngine loginByToken:nil user:@"" completion:^(AgoraRtmLoginErrorCode errorCode) {
//        NSLog(@"Login completion code: %ld", (long)errorCode);
//        if (errorCode == AgoraRtmLoginErrorOk) {
//            [weakSelf performSegueWithIdentifier:@"ShowDialView" sender:nil];
//        } else {
//
//        }
//    }];
}
-(void)initView{
    UIImageView *img_bg = [[UIImageView alloc]init];
    [self.view addSubview:img_bg];
    img_bg.image = [UIImage imageNamed:@"login_bg"];
    img_bg.userInteractionEnabled = YES;
    [img_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *logo = [[UIImageView alloc]init];
    [img_bg addSubview:logo];

    logo.image = [UIImage imageNamed:@"login_logo"];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(img_bg.mas_centerX);
        make.top.equalTo(img_bg.mas_top).offset(38);
        make.width.equalTo(@96);
        make.height.equalTo(@38);
    }];
    
    
    UIImageView *login_bg = [[UIImageView alloc]init];
    [img_bg addSubview:login_bg];
    login_bg.image = [UIImage imageNamed:@"login_1"];
    login_bg.userInteractionEnabled = YES;

    [login_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(img_bg.mas_centerX);
        make.centerY.equalTo(img_bg.mas_centerY);
        make.width.equalTo(@(self.view.width/2.7));
        make.height.equalTo(@(self.view.width/2.7/2.13));
    }];
    
    UIButton *wechat = [UIButton buttonWithType:UIButtonTypeCustom];
    [login_bg addSubview:wechat];
    [wechat setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [wechat addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    wechat.tag=10;
    
    UIButton *youke = [UIButton buttonWithType:UIButtonTypeCustom];
    [login_bg addSubview:youke];
    [youke setImage:[UIImage imageNamed:@"youke"] forState:UIControlStateNormal];
    youke.tag=11;
    [youke addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *wechat_lab = [[UILabel alloc]init];
    [login_bg addSubview:wechat_lab];
    wechat_lab.text = @"微信登录";
    wechat_lab.textColor = UIColor.whiteColor;
    wechat_lab.font = [UIFont systemFontOfSize:12];
    wechat_lab.textAlignment = NSTextAlignmentCenter;
    
    UILabel *youke_lab = [[UILabel alloc]init];
    [login_bg addSubview:youke_lab];
    youke_lab.text = @"游客登录";
    youke_lab.textColor = UIColor.whiteColor;
    youke_lab.font = [UIFont systemFontOfSize:12];
    youke_lab.textAlignment = NSTextAlignmentCenter;

    CGFloat wd = (self.view.width/2.7 - 48*2-80)/2;
    [@[wechat,youke] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@48);
        make.top.equalTo(login_bg.mas_top).offset(35);
        
    }];
    [@[wechat,youke] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:48 leadSpacing:wd tailSpacing:wd];
    

    [@[wechat_lab,youke_lab] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@48);
        make.top.equalTo(login_bg.mas_top).offset(110);
        
    }];
    [@[wechat_lab,youke_lab] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:58 leadSpacing:wd-5 tailSpacing:wd-5];
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [img_bg addSubview:agreeBtn];
    [agreeBtn setImage:[UIImage imageNamed:@"login_uns"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"login_se"] forState:UIControlStateSelected];
    [agreeBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    agreeBtn.tag =13;
    UIButton *btnAgreement=[UIButton buttonWithType:UIButtonTypeCustom];
    [img_bg addSubview:btnAgreement];
    btnAgreement.titleLabel.textAlignment = NSTextAlignmentLeft;
    NSString *agrementStr=@"阅读并接收《TIDE用户协议》";
    NSAttributedString *attribute=[self returnStrWithText:agrementStr];
    [btnAgreement setAttributedTitle:attribute forState:UIControlStateNormal];
    btnAgreement.titleLabel.font=[UIFont systemFontOfSize:10];
    [btnAgreement setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [btnAgreement addTarget:self action:@selector(agrementClick) forControlEvents:UIControlEventTouchUpInside];
    btnAgreement.titleLabel.textAlignment=NSTextAlignmentLeft;
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnAgreement.mas_left).offset(0);
        make.centerY.equalTo(btnAgreement.mas_centerY).offset(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(30);
    }];
    [btnAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(img_bg.mas_centerX);
        make.top.equalTo(login_bg.mas_bottom).offset(0);
        make.height.mas_equalTo(50);
    }];
  
    
}
-(void)agrementClick
{
    ProtolViewController *pro = [[ProtolViewController alloc]init];
    [self.navigationController pushViewController:pro animated:YES];
}
-(NSMutableAttributedString*)returnStrWithText:(NSString*)str
{
    
    if (str.length==0) {
        return [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",str]];
    }
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",str]];
    
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0xA0A0A0) range:NSMakeRange(0,7)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0x10ACF9) range:NSMakeRange(5, str.length-5)];
    
    return AttributedStr;
}
-(void)login:(UIButton*)sender
{
    if (sender.tag==13) {
        sender.selected = !sender.selected;
        isagree = sender.selected;
        
        return;
    }
    if (sender.tag ==11) {
        if (isagree) {
                    [self gustLogin];
//                    ChooseModelController *model = [[ChooseModelController alloc]init];
//                    [self.navigationController pushViewController:model animated:YES];
//            MapResourceController *map = [[MapResourceController alloc]init];
//            [self.navigationController pushViewController:map animated:YES];

        }else{
            [self.view showToastWithText:@"请先同意用户协议"];
        }
      

        return;
    }
    if (sender.tag ==10) {
//        [self wechatLogin];

        return;
    }
    if ([GameManager getInstance].gv) {
//        GViewController *vv = [[GViewController alloc]init];
        [self presentViewController:[GameManager getInstance].gv animated:NO completion:nil];
        [[GameManager getInstance]willEnterForeground];
        
        return;
    }
    
    [[GameManager getInstance]didlanunchWith:@{}];
    UIWindow *winwow = [UIApplication sharedApplication].windows[0];
    GViewController *vv = [[GViewController alloc]init];
    [winwow setRootViewController:vv];
    
}
#pragma mark---游客登录
-(void)gustLogin{
    
    [HFNetWorkTool POST:guest_login parameters:@{} currentViewController:self success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
            NSDictionary *dic = responseObject[@"data"];
            NSString *token = dic[@"token"];
            NSString *uuid = dic[@"uuid"];
            NSString *wltoken = dic[@"wyToken"];
            UserModel *model =  [UserManager shraeUserManager].user;
            model.token = token;
            model.uuid =uuid;
            model.wlToken = wltoken;
            [[UserManager shraeUserManager] setUser:model];
            ChooseModelController *modelView = [[ChooseModelController alloc]init];
            [self.navigationController pushViewController:modelView animated:YES];
        }
        
        } failure:^(NSError *error) {
            
        }];
}
-(void)wechatLogin{
    [[UMSocialManager defaultManager]getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"----error===%@",error);
        }else{
            UMSocialUserInfoResponse *resp = result;

        }
    }];
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
