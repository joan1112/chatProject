//
//  OrderViewController.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/5.
//

#import "OrderViewController.h"
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
#import "orderView/CartView.h"
@interface OrderViewController ()
{
    UIImageView *_bgView;
    UIButton *btnSelect;
    UIButton *open;
    UIView *modelView;
    UILabel *nameLab;
}
@property(nonatomic,assign)BOOL isOpen;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

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
    
    UIView *top = [[UIView alloc]init];
    [_bgView addSubview:top];
    top.userInteractionEnabled = YES;
    top.backgroundColor = [UIColor colorWithRed:1/255.0 green:38/255.0 blue:57/255.0 alpha:.5];
    
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
    headImg.image = [UIImage imageNamed:@"default_headz"];

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

        [btn setTitle:@[@"购物车",@"我的订单",@"我的地址"][i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i==0) {
            btnSelect = btn;
            btn.selected = YES;
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+10;
    }
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, KScreenWidth-106, KScreenHeight-30)];
    [_bgView addSubview:scrollV];
    scrollV.contentSize = CGSizeMake(KScreenWidth-106, (KScreenHeight-30)*3);
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.scrollEnabled = NO;
    CartView *cart = [[CartView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-106, KScreenHeight-30)];
    [scrollV addSubview:cart];
    
    
   
    
}

-(void)closeClick
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)btnClick:(UIButton*)sender
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
