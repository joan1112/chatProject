//
//  AlertApplyView.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/18.
//

#import "AlertApplyView.h"
#import "../../ThirdParty/Category/UIView+Frame.h"
#import "../base/CommonMacros.h"
#import "model/FriendModel.h"
#import "../orderView/PINTextView.h"

@interface AlertApplyView()
{
    UIImageView *bgView;
}
@property (nonatomic, strong) UIView *superView;

@end
@implementation AlertApplyView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)creatUI{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self.superView];
    self.superView.frame = window.frame;
    [self.superView addSubview:self];
    
    bgView = [[UIImageView alloc]init];
    [self addSubview:bgView];
    bgView.frame = CGRectMake((KScreenWidth-(KScreenHeight-120)*1.76)/2, 40,  (KScreenHeight-120)*1.76, KScreenHeight-120);
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    bgView.userInteractionEnabled = YES;
    bgView.image = [UIImage imageNamed:@"alert_bg"];
    bgView.userInteractionEnabled = YES;
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:close];
    close.frame = CGRectMake(bgView.width-45,15, 30, 30);
    [close setImage:[UIImage imageNamed:@"close_1"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(35, 25, 40, 40)];
    [bgView addSubview:headImg];
    headImg.image = [UIImage imageNamed:@"default_headz"];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 25, 100, 20)];
    [bgView addSubview:nameLab];
    nameLab.text = self.model.nickname;
    
   
    nameLab.font = [UIFont systemFontOfSize:12];
    nameLab.textColor = kUIColorFromRGB(0xDBEBF9);
   
    UIImageView *helloBg = [[UIImageView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(headImg.frame)+10, self.width-50, 100)];
    [bgView addSubview:helloBg];
    helloBg.userInteractionEnabled = YES;
    PINTextView *helloText = [[PINTextView alloc]initWithFrame:CGRectMake(10, 10, bgView.width-70, 80)];
    [helloBg addSubview:helloText];
    helloText.textColor =CBTextColor;
    helloText.backgroundColor = [UIColor whiteColor];
    helloText.placeholder = @"请输入";
    helloText.text = [NSString stringWithFormat:@"我是%@",self.model?self.model.nickname:self.model.nickname];
    
    UIButton *senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:senderBtn];
    [senderBtn setBackgroundImage:[UIImage imageNamed:@"agree_bg"] forState:UIControlStateNormal];
    senderBtn.frame = CGRectMake(bgView.width/2 - 80, bgView.height-80, 160, 40);
    [senderBtn setTitle:@"发送申请" forState:UIControlStateNormal];
    [senderBtn setTitleColor:kUIColorFromRGB(0x88512D) forState:UIControlStateNormal];
    senderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [senderBtn addTarget:self action:@selector(senderClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)senderClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(alertApllySender:)]) {
        [self.delegate alertApllySender:self.model.uuid];
    }
}

-(void)loadSubView
{
    [self creatUI];
}
-(void)closeClick
{
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
