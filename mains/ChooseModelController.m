//
//  ChooseModelController.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/26.
//

#import "ChooseModelController.h"
#import "base/CommonMacros.h"
#import "../ThirdParty/Category/UIView+Frame.h"
#import "../ThirdParty/Masonry/Masonry.h"
#import "MapResourceController.h"
#import "base/User/UserManager.h"
#import "../ThirdParty/Category/UIView+Alert.h"
#import "base/BaseNetWork/HFNetWorkTool.h"
#import "base/ConstMacros.h"
#import <AVKit/AVKit.h>

@interface ChooseModelController ()
{
    NSString *nickname;
    UITextField *tf;
    NSInteger selectIndex;
    UIButton *btnSelect;
    UIImageView *modelImg;//选择的模型
    NSArray *titArr;
    NSArray *desArr;
    UILabel *des_tit;
    UILabel *desLab;
}
@property(nonatomic,strong)AVPlayer *moviePlayer;

@end

@implementation ChooseModelController

- (void)viewDidLoad {
    [super viewDidLoad];

    selectIndex = 1;
    [self initData];
    [self initView];
}
-(void)initData{
    titArr = @[@"泰之宇",@"泰之云",@"泰之宙",@"泰之元"];
    desArr = @[@"TIDE元宇宙泰之宇角色，实现了在虚拟世界执行虚拟命令，泰之宇角色在物理世界中的状态也将实时显示在虚拟世界中，未来，元宇宙将开启人类更美好的全新生活方式。",@"TIDE元宇宙泰之云角色，实现了在虚拟世界执行虚拟命令，泰之云角色在物理世界中的状态也将实时显示在虚拟世界中，未来，元宇宙将开启人类更美好的全新生活方式。",@"TIDE元宇宙泰之宙角色，实现了在虚拟世界执行虚拟命令，泰之宙角色在物理世界中的状态也将实时显示在虚拟世界中，未来，元宇宙将开启人类更美好的全新生活方式。",@"TIDE元宇宙泰之元角色，实现了在虚拟世界执行虚拟命令，泰之元角色在物理世界中的状态也将实时显示在虚拟世界中，未来，元宇宙将开启人类更美好的全新生活方式。"];
    
}

-(void)initView{

    UIImageView *bgImg = [[UIImageView alloc]init];
    [self.view addSubview:bgImg];
    bgImg.userInteractionEnabled = YES;
    bgImg.backgroundColor = kUIColorFromRGB(0x01314F);
//    bgImg.image = [UIImage imageNamed:@"choose_bg"];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [bgImg.layer addSublayer:lay];
    
//      [self.view sendSubviewToBack:self.moviePlayer.view];
      [self.moviePlayer play];
    
    UIImageView *chooseModel = [[UIImageView alloc]init];
    [bgImg addSubview:chooseModel];
    chooseModel.image = [UIImage imageNamed:@"choose_icon"];
    [chooseModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImg.mas_top).offset(10);
        make.left.equalTo(bgImg.mas_left).offset(15);
        make.width.equalTo(@(112));
        make.height.equalTo(@(29));
    }];
    
    UIView *modelView = [[UIView alloc]init];
    [bgImg addSubview:modelView];
    
    [modelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgImg.mas_centerY);
        make.left.equalTo(bgImg.mas_left).offset(10+kTopBarSafeHeight);
        make.height.mas_equalTo(55*4+5);
        make.width.mas_equalTo(53/2+64);
        
    }];
    
    for (int i=0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [modelView addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"model_un"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"model_se"] forState:UIControlStateSelected];

        [btn addTarget:self action:@selector(chooseModel:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 20+i;
        CGFloat x = 0;
        CGFloat y=0;
        CGFloat wd =69;
        CGFloat hd = 63;
        if (i==0||i==2) {
            x=0;
        }else{
            x = 69/2;
        }
        y = 55*i;
        if (i==0) {
            btn.selected = YES;
            selectIndex = i+1;
            btnSelect = btn;
        }
        btn.frame = CGRectMake(x,y, wd, hd);
        
        UIImageView *mod = [[UIImageView alloc]initWithFrame:CGRectZero];
        [btn addSubview:mod];
    
        mod.contentMode = UIViewContentModeScaleAspectFit;
        [mod mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX);
            make.centerY.equalTo(btn.mas_centerY);
            make.width.equalTo(@46);
            make.height.equalTo(@46);
        }];

        mod.image = [UIImage imageNamed:[NSString stringWithFormat:@"model_h%d",i+1]];
    }

    UIImageView *tideDes = [[UIImageView alloc]init];
    [bgImg addSubview:tideDes];
    tideDes.userInteractionEnabled = YES;
//    tideDes.backgroundColor = kUIColorFromRGB(0x2866A9);
//    tideDes.image = [UIImage imageNamed:@"tide_des"];
    [tideDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgImg.mas_right).offset(-10);
//        make.centerY.equalTo(bgImg.mas_centerY);
        make.top.equalTo(bgImg.mas_top).offset(50);
        make.bottom.equalTo(bgImg.mas_bottom).offset(-50);
//        make.width.mas_equalTo(160);
        make.width.mas_equalTo(tideDes.mas_height).dividedBy(1.87);

    }];
    
    UIView *vv1 = [[UIView alloc]init];
    [tideDes addSubview:vv1];
    vv1.backgroundColor = kUIColorFromRGB(0x274F86);
//    vv1.layer.anchorPoint = CGPointMake(1, 0.5);
//
//    vv1.layer.transform=CATransform3DMakeRotation(-M_PI/4, 0, 1, 0);
    des_tit = [[UILabel alloc]init];
    [vv1 addSubview:des_tit];
    des_tit.textAlignment = NSTextAlignmentCenter;
    des_tit.font =[UIFont systemFontOfSize:12];
    des_tit.textColor = kUIColorFromRGB(0xC1D5E9);
    des_tit.text = titArr[selectIndex-1];

   desLab = [[UILabel alloc]init];
    [vv1 addSubview:desLab];
    desLab.font =[UIFont systemFontOfSize:10];
    desLab.textColor = kUIColorFromRGB(0x6A92BA);
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.numberOfLines=0;

   


    NSString *str = desArr[selectIndex-1];
    [self attributeStr:str];

    [vv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tideDes.mas_right).offset(0);
        make.top.equalTo(tideDes.mas_top).offset(0);
        make.bottom.equalTo(tideDes.mas_bottom).offset(0);
        make.left.equalTo(tideDes.mas_left).offset(0);

    }];


    [des_tit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(vv1.mas_right).offset(-10);
        make.top.equalTo(vv1.mas_top).offset(10);
        make.left.equalTo(vv1.mas_left).offset(10);

    }];

    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(vv1.mas_right).offset(-10);
        make.top.equalTo(des_tit.mas_bottom).offset(10);
        make.left.equalTo(vv1.mas_left).offset(10);

    }];
    
    UIButton *entry  = [UIButton buttonWithType:UIButtonTypeCustom];
    [tideDes addSubview:entry];
    entry.backgroundColor = kUIColorFromRGB(0xE4C454);
    [entry setTitle:@"进入TIDE世界" forState:UIControlStateNormal];
    [entry setTitleColor:kUIColorFromRGB(0x88512D) forState:UIControlStateNormal];
    entry.titleLabel.font = [UIFont systemFontOfSize:12];
//    [entry setBackgroundImage:[UIImage imageNamed:@"tide_entry"] forState:UIControlStateNormal];
    [entry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tideDes.mas_bottom).offset(-30);
        make.centerX.equalTo(tideDes.mas_centerX);
        make.width.equalTo(@105);
        make.height.mas_equalTo(25);
    }];
    [entry addTarget:self action:@selector(entryClick) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    modelImg = [[UIImageView alloc]init];
    [bgImg addSubview:modelImg];
    modelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"model_b%ld",selectIndex]];
    modelImg.contentMode = UIViewContentModeScaleAspectFit;
    [modelImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImg.mas_centerX).offset(0);
        make.bottom.equalTo(bgImg.mas_bottom).offset(-45*SCALE);
        make.height.mas_equalTo(KScreenHeight-80);
        make.width.mas_equalTo(260);
    }];
    
    UIView *nickView = [[UIView alloc]init];
    [bgImg addSubview:nickView];
    nickView.userInteractionEnabled = YES;
    nickView.backgroundColor = kUIColorFromRGB(0x2966AE);
    nickView.alpha = .8;
    [nickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgImg.mas_bottom).offset(-40*SCALE);
        make.width.mas_equalTo(185*SCALE);
        make.height.mas_equalTo(32);
        make.centerX.equalTo(bgImg.mas_centerX);

    }];
    tf = [[UITextField alloc]init];
    [nickView addSubview:tf];
    tf.font = [UIFont systemFontOfSize:10];
    tf.textColor = UIColor.whiteColor;
    tf.placeholder = @"点击输入昵称";
    NSDictionary *attrs = @{NSForegroundColorAttributeName:kUIColorFromRGB(0xC3DAED)};
    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"点击输入昵称" attributes:attrs];
  
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickView.mas_left).offset(15);
        make.top.equalTo(nickView.mas_top);
        make.bottom.equalTo(nickView.mas_bottom);
        make.right.equalTo(nickView.mas_right).offset(-40);
    }];
    UIButton *randomNick = [UIButton buttonWithType:UIButtonTypeCustom];
    [nickView addSubview:randomNick];
    [randomNick setImage:[UIImage imageNamed:@"random"] forState:UIControlStateNormal];
    [randomNick addTarget:self action:@selector(randomStr) forControlEvents:UIControlEventTouchUpInside];
    [randomNick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nickView.mas_right).offset(-5);
        make.centerY.equalTo(nickView.mas_centerY);
        make.width.height.mas_equalTo(28);
    }];
    UIView *models = [[UIView alloc]init];
    [bgImg addSubview:models];
//    models.backgroundColor = [UIColor grayColor];
    [models mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nickView.mas_top);
        make.centerX.equalTo(bgImg.mas_centerX);
        make.width.equalTo(@162);
        make.height.mas_equalTo(297);
    }];
    
}
-(void)attributeStr:(NSString*)str{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.0; // 设置行间距
    paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];

    desLab.attributedText = attributedStr;
    [desLab sizeToFit];

}
-(void)chooseModel:(UIButton*)sender
{
    if (btnSelect!=sender) {
        selectIndex = sender.tag-20+1;
        btnSelect.selected = !btnSelect.selected;
        sender.selected = !sender.selected;
        btnSelect = sender;
        modelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"model_b%ld",selectIndex]];
        des_tit.text = titArr[selectIndex-1];
        [self attributeStr:desArr[selectIndex-1]];

    }
    
}
-(void)randomStr
{
   NSString *nick = [self getRandomNickName];
    tf.text = nick;
    nickname = nick;
    
}
-(NSString*)getRandomNickName{
    NSArray *name1= @[@"美丽的",
                      @"优雅的",
                      @"清秀的",
                      @"妩媚的",
                      @"可爱的",
                      @"温柔的",
                      @"帅气的",
                      @"阳光的",
                      @"潇洒的",
                      @"干练的",
                      @"精明的",
                      @"霸气的",
                      @"勤劳的",
                      @"勇敢的",
                      @"自信的",
                      @"懒惰的",
                      @"倔强的",
                      @"豪放的",
                      @"豁达的",
                      @"幽默的"];
    NSString *name2 = @"颜慕云妘代宫唐关巫江温单鹿古谷舒邵明简柯";
    NSString *name3 = @"栀夏,路途,已笙,巷陌,迎天,花颜,嫑离,奈何,暖阳,雨水,早早,天空,海洋,暖心,知雪,陌语,浅绿,流走,旧颜,拾柒";
    int x = arc4random()%20;
    int x1 = arc4random()%20;
    int x2 = arc4random()%20;
    NSString *result = [NSString stringWithFormat:@"%@%@%@",name1[x],[name2 substringWithRange:NSMakeRange(x1, 1)],[name3 componentsSeparatedByString:@","][x2]];
    return result;
}
-(void)entryClick
{
    if (tf.text.length>0) {
        nickname = tf.text;
    }
    if (nickname.length==0) {
        [self.view showToastWithText:@"请输入昵称"];
        return;
    }
    [self updateUserInfo:nickname];
    
   
}

-(void)updateUserInfo:(NSString*)nick
{
    kWeakSelf(self);
    [self showHUDWithText:@"加载中"];
    [HFNetWorkTool POST:userInfo parameters:@{@"nickname":nick,@"role":@(selectIndex),@"uuid":[UserManager shraeUserManager].user.uuid} currentViewController:self success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        [self hideHUD];

        if ([responseObject[@"code"] intValue]==200) {

            UserModel *model = [UserManager shraeUserManager].user;
            model.nickname = nickname;
            model.role = [NSString stringWithFormat:@"%ld",selectIndex];
            [[UserManager shraeUserManager]setUser:model];
            MapResourceController *resource = [[MapResourceController alloc]init];
            
            [self.navigationController pushViewController:resource animated:YES];
        }else{
            [weakself showToastWithText:responseObject[@"msg"]];

        }
        
        } failure:^(NSError *error) {
            [self hideHUD];
        }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (self.moviePlayer) {
        [self.moviePlayer play];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.moviePlayer.currentItem];

    }
  
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.moviePlayer) {
        [self.moviePlayer pause];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
