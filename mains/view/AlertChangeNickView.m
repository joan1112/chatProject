//
//  AlertChangeNickView.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/28.
//

#import "AlertChangeNickView.h"
#import "../../ThirdParty/Masonry/Masonry.h"
#import "../../ThirdParty/Category/UIView+Frame.h"

#import "../base/CommonMacros.h"
#import "../../ThirdParty/Category/UIView+Alert.h"
#import "../base/User/UserManager.h"
@interface AlertChangeNickView()
{
    UITextField *passtf;

}
@property (nonatomic, strong) UIView *superView;

@end
@implementation AlertChangeNickView


-(instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.superView];
    self.superView.frame = window.frame;
    [self.superView addSubview:self];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = UIColor.whiteColor;

    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    bgView.userInteractionEnabled = YES;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(180);
    }];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:close];
    [close setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.top.equalTo(bgView.mas_top).offset(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    
    UILabel *tipLab = [[UILabel alloc]init];
    [bgView addSubview:tipLab];
    tipLab.textColor = CTextColor;
    tipLab.font = [UIFont systemFontOfSize:14];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.text = @"請輸入昵称";
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    UIView *passView = [[UIView alloc]init];
    passView.backgroundColor = kUIColorFromRGB(0xEEEEEE);
    passView.layer.cornerRadius = 20;
    passView.layer.masksToBounds = YES;
    [bgView addSubview:passView];
    
    passtf = [[UITextField alloc]init];
    [passView addSubview:passtf];
    passtf.placeholder = @"请输入昵称";
    passtf.textColor = CTextColor;

    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLab.mas_bottom).offset(10);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    [passtf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passView.mas_top).offset(0);
        make.left.equalTo(passView.mas_left).offset(15);
        make.right.equalTo(passView.mas_right).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:next];
    next.backgroundColor = kUIColorFromRGB(0x17B0DD);
    [next setTitle:@"确认" forState:UIControlStateNormal];
    next.layer.cornerRadius = 5;
    next.layer.masksToBounds = YES;
    [next addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset(-10);
        make.left.equalTo(bgView.mas_left).offset(25);
        make.right.equalTo(bgView.mas_right).offset(-25);
        make.height.mas_equalTo(40);
    }];
        
}
-(void)closeClick
{
    [self hidePopView];
}
-(void)nextClick
{

    if (passtf.text.length==0) {
        [self showToastWithText:@"请输入昵称"];
        return;
    }
    if (self.verfySuccess) {
        self.verfySuccess(passtf.text);
    }
    [self hidePopView];
    
}
-(void)showPopView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.25 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.superView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    } completion:nil];
}
- (void)hidePopView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.25 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.superView.alpha = 0.0;
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.superView removeFromSuperview];
        strongSelf.superView = nil;
    }];
}
- (UIView *)superView
{
    if (!_superView)
    {
        _superView = [[UIView alloc] init];
    }
    return _superView;
}

@end
