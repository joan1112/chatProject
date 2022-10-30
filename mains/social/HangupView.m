//
//  HangupView.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/10.
//

#import "HangupView.h"
#import "../../ThirdParty/Category/UIView+Frame.h"
#import "../../ThirdParty/Masonry/Masonry.h"
@implementation HangupView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)creatView
{
    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:bgImg];
    bgImg.image = [UIImage imageNamed:@"hang_bg"];
    bgImg.userInteractionEnabled = YES;
    UIImageView *head = [[UIImageView alloc]init];
    [bgImg addSubview:head];
    head.image = [UIImage imageNamed:@"default_headz"];
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImg.mas_left).offset(15);
        make.centerY.equalTo(bgImg.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    
    UILabel *nameLab = [[UILabel alloc]init];
    [bgImg addSubview:nameLab];
    nameLab.textColor = [UIColor whiteColor];
    nameLab.text = _remoteUsr.nickname;
    nameLab.font = [UIFont systemFontOfSize:12];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head.mas_right).offset(5);
        make.top.equalTo(head.mas_top);
    }];
    
    UILabel *typeLab = [[UILabel alloc]init];
    [bgImg addSubview:typeLab];
    typeLab.textColor = [UIColor whiteColor];
  
    typeLab.font = [UIFont systemFontOfSize:10];
    if (self.type == NERtcCallTypeAudio) {
        typeLab.text = @"邀请你语音通话";
    }else{
        typeLab.text = @"邀请你视频通话";

    }
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head.mas_right).offset(5);
        make.bottom.equalTo(head.mas_bottom);
    }];
    UIButton *reject = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgImg addSubview:reject];
    [reject setImage:[UIImage imageNamed:@"reject"] forState:UIControlStateNormal];
    [reject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head.mas_right).offset(90);
        make.centerY.equalTo(bgImg.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    [reject addTarget:self action:@selector(rejectClick:) forControlEvents:UIControlEventTouchUpInside];
    reject.tag = 10;

    UIButton *accept = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgImg addSubview:accept];
    [accept setImage:[UIImage imageNamed:@"receive"] forState:UIControlStateNormal];
    [accept addTarget:self action:@selector(rejectClick:) forControlEvents:UIControlEventTouchUpInside];
    accept.tag = 11;
    [accept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reject.mas_right).offset(10);
        make.centerY.equalTo(bgImg.mas_centerY);
        make.width.height.mas_equalTo(30);

    }];
    
    
}
-(void)rejectClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(hangupAction:)]) {
        [self.delegate hangupAction:sender.tag-10];
    }
}
@end
