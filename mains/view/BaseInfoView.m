//
//  BaseInfoView.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/26.
//

#import "BaseInfoView.h"
#import "../../ThirdParty/Masonry/Masonry.h"
#import "../../ThirdParty/Category/UIView+Frame.h"

#import "../base/CommonMacros.h"
#import "../../ThirdParty/Category/UIView+Alert.h"
#import "../base/User/UserManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BaseInfoView()<UIScrollViewDelegate>
{
    UIImageView *headImg;
    UIButton *mbtnSelect;
    UILabel *lineLab;
    UIScrollView *safeView;
    UIView *voiceView;
    UIScrollView *contents;
    UILabel *nickLab;
}
@end
@implementation BaseInfoView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kUIColorFromRGB(0x264E85);
       
    }
    return self;
}

-(void)creatInfoView
{
    [self initView];
}
-(void)initView{
   headImg = [[UIImageView alloc]init];
    [self addSubview:headImg];
//    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(15);
//        make.top.equalTo(self.mas_top).offset(15);
//        make.width.height.equalTo(@80)
//    }];
//    headImg.backgroundColor = [UIColor whiteColor];
    
    headImg.frame = CGRectMake(10, 10, 50, 50);
    [headImg sd_setImageWithURL:[NSURL URLWithString:[UserManager shraeUserManager].user.headImg] placeholderImage:[UIImage imageNamed:@"default_headz"]];
    headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHead)];
    [headImg addGestureRecognizer:tap];
    
    nickLab = [[UILabel alloc]init];
    [self addSubview:nickLab];
    nickLab.textColor = kUIColorFromRGB(0xDBEBF9);
    nickLab.font = [UIFont systemFontOfSize:12];
    nickLab.text = [UserManager shraeUserManager].user.nickname;
    [nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_right).offset(10);
        make.top.equalTo(headImg.mas_top);
        
        
    }];
    
    UIButton *editeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:editeBtn];
    [editeBtn addTarget:self action:@selector(infoClick:) forControlEvents:UIControlEventTouchUpInside];
    editeBtn.tag = 10;
    [editeBtn setImage:[UIImage imageNamed:@"edites"] forState:UIControlStateNormal];
    [editeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickLab.mas_right).offset(10);
        make.top.equalTo(headImg.mas_top);
        make.width.height.equalTo(@20);
    }];
    
    UILabel *tipLab = [[UILabel alloc]init];
    tipLab.font = [UIFont systemFontOfSize:10];
    [self addSubview:tipLab];
    tipLab.textColor = kUIColorFromRGB(0x91BADD);
    tipLab.text = @"长度在1到10之间";
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_right).offset(10);
        make.top.equalTo(nickLab.mas_bottom);
        
    }];
    
    UILabel *tideNum = [[UILabel alloc]init];
    [self addSubview:tideNum];
    tideNum.textColor = kUIColorFromRGB(0x66BAEB);
    tideNum.font = [UIFont systemFontOfSize:9];
    tideNum.text = @"TIDE号：2341";
    [tideNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_right).offset(10);
        make.bottom.equalTo(headImg.mas_bottom);
        
    }];
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:copyBtn];
    [copyBtn setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
    copyBtn.tag = 11;
    [copyBtn addTarget:self action:@selector(infoClick:) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tideNum.mas_right).offset(5);
        make.centerY.equalTo(tideNum.mas_centerY);
        make.width.height.equalTo(@20);
    }];
    
    
    UIView *attentionV = [[UIView alloc]init];
    [self addSubview:attentionV];
    attentionV.backgroundColor = kUIColorFromRGB(0x5778A4);
    
    UIView *noView = [[UIView alloc]init];
    [self addSubview:noView];
    noView.backgroundColor = kUIColorFromRGB(0x5778A4);
    [self creatViewBlockWith:0];
    [self creatViewBlockWith:1];

    
}
-(void)changeHead
{
    if (self.userInfoAction) {
        self.userInfoAction(1);
    }
}
-(void)infoClick:(UIButton*)sender
{
    if (sender.tag == 10) {//修改昵称
        if (self.userInfoAction) {
            self.userInfoAction(0);
        }
    }else{//
        UIPasteboard *past = [UIPasteboard generalPasteboard];
        past.string = @"2341";
        [self showToastWithText:@"TIDE号复制成功"];
        
        
    }
}
-(UIView*)creatViewBlockWith:(int)i
{
    
    UIView *attentionV = [[UIView alloc]init];
    [self addSubview:attentionV];
    attentionV.backgroundColor = kUIColorFromRGB(0x5778A4);
    
    attentionV.frame = CGRectMake(10, 90+i*100, self.width-20, 80);
    
    UIImageView *img = [[UIImageView alloc]init];
    [attentionV addSubview:img];
    img.image = [UIImage imageNamed:@[@"user_like",@"user_1"][i]];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(attentionV.mas_centerX);
        make.top.equalTo(attentionV.mas_top).offset(20);
        make.width.height.equalTo(@15);
    }];
    
    UILabel *tip = [[UILabel alloc]init];
    [attentionV addSubview:tip];
    tip.text = @[@"关注TIDE给你意想不到的惊喜哦",@"暂未开放 敬请期待"][i];
    tip.font = [UIFont systemFontOfSize:10+i*2];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.textColor = UIColor.whiteColor;
    
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(attentionV.mas_centerX);
        make.top.equalTo(img.mas_bottom).offset(10);
    }];
    return attentionV;
}
//setting
-(void)creatSetingView
{
    UIScrollView *topScroll = [[UIScrollView alloc]init];
    [self addSubview:topScroll];
    topScroll.showsHorizontalScrollIndicator = NO;
    
    [topScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@40);
    }];
    NSArray *data = @[@"安全中心",@"声音"];
    NSMutableArray *btnArr = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [topScroll addSubview:btn];
        [btn setTitle:data[i] forState:UIControlStateNormal];
        [btn setTitleColor:kUIColorFromRGB(0x89B0D1) forState:UIControlStateNormal];
        [btn setTitleColor:kUIColorFromRGB(0xDBEBF9) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnArr addObject:btn];
        if(i==0){
            btn.selected = YES;
            mbtnSelect = btn;
            lineLab = [[UILabel alloc]init];
            [topScroll addSubview:lineLab];
            lineLab.backgroundColor = kUIColorFromRGB(0x8FF3FF);
            btn.backgroundColor = kUIColorFromRGB(0x264C7F);
            
        }
        
    }
    [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topScroll.mas_top).offset(0);
        make.height.mas_equalTo(40);
    }];
    [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    UIButton *b1 = btnArr[0];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(b1.mas_bottom).offset(1);
        make.centerX.equalTo(b1.mas_centerX);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(1);
    }];
    
    contents = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, self.width, self.height-50)];
    [self addSubview:contents];
    contents.pagingEnabled = YES;
    
    contents.contentSize = CGSizeMake(self.width*2, self.height-50);
    contents.delegate = self;
   
//
    safeView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height-50)];
    [contents addSubview:safeView];
    safeView.contentSize = CGSizeMake(0, 250);
    safeView.userInteractionEnabled = YES;
    [self inputContext:0 withType:0 WithSuper:safeView];
    [self inputContext:1 withType:0 WithSuper:safeView];
    [self inputContext:2 withType:0 WithSuper:safeView];
    [self inputContext:3 withType:0 WithSuper:safeView];
    

    //
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    [safeView addSubview:logout];
    logout.backgroundColor = kUIColorFromRGB(0x2C78C6);
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    logout.titleLabel.font = [UIFont systemFontOfSize:12];
    [logout addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    logout.layer.cornerRadius = 15;
    
    [logout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(safeView.mas_centerX);
        make.bottom.equalTo(safeView.mas_top).offset(230);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
    }];
    
    voiceView = [[UIView alloc]initWithFrame:CGRectMake(self.width, 0, self.width, self.height-50)];
    [contents addSubview:voiceView];
    [self inputContext:0 withType:1 WithSuper:voiceView];
    [self inputContext:1 withType:1 WithSuper:voiceView];
    [self inputContext:2 withType:1 WithSuper:voiceView];
    [self inputContext:3 withType:1 WithSuper:voiceView];
    
    
    
}

-(void)inputContext:(int)index withType:(int)type WithSuper:(UIView*)superView{
    UIButton *bg = [UIButton buttonWithType:UIButtonTypeCustom];
    [bg setBackgroundImage:[UIImage imageNamed:@"set_bg"] forState:UIControlStateNormal];
    bg.frame = CGRectMake(15, index*(10+40), self.width-30, 40);
    [superView addSubview:bg];
    UILabel *tip = [[UILabel alloc]init];
    [bg addSubview:tip];
    tip.textColor = UIColor.whiteColor;
    tip.font = [UIFont systemFontOfSize:12];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bg.mas_centerY);
        make.left.equalTo(bg.mas_left).offset(10);
    }];
    if (type==0) {//设置
        tip.text = @[@"TIDE号",@"手机号",@"第三方绑定",@"添加地址"][index];

        if (index==3) {
            UIImageView *row = [[UIImageView alloc]init];
            [bg addSubview:row];
            row.image = [UIImage imageNamed:@"row_right"];
            [row mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bg.mas_centerY);
                make.right.equalTo(bg.mas_right).offset(-10);
            }];
        }else{
            UILabel *content = [[UILabel alloc]init];
            [bg addSubview:content];
            content.text = @[@"2341",@"无",@"无",@""][index];
            content.textColor = UIColor.whiteColor;
            content.font = [UIFont systemFontOfSize:12];
            
            [content mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bg.mas_centerY);
                make.right.equalTo(bg.mas_right).offset(-10);
            }];
        }
    }else{
        tip.text = @[@"页面功能声",@"角色声",@"环境声",@"道具声"][index];
        
        UISwitch *switchs = [[UISwitch alloc]init];
        [bg addSubview:switchs];
        switchs.on = YES;
        switchs.transform = CGAffineTransformMakeScale(.6, .6);
        
        UILabel *status = [[UILabel alloc]init];
        [bg addSubview:status];
        status.text = @"已开启";
        status.font = [UIFont systemFontOfSize:12];
        status.textColor = kUIColorFromRGB(0xDBEBF9);
        
        [status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bg.mas_centerY);
            make.right.equalTo(bg.mas_right).offset(-10);
        }];
        [switchs mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bg.mas_centerY);
            make.right.equalTo(status.mas_left).offset(-10);
        }];
        

    }
    

  
    
}
-(void)btnClick:(UIButton*)sender
{
    mbtnSelect.backgroundColor = [UIColor clearColor];

    sender.selected = YES;
    mbtnSelect.selected = NO;
    mbtnSelect = sender;
    mbtnSelect.backgroundColor = kUIColorFromRGB(0x264C7F);

    [lineLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sender.mas_bottom).offset(1);
        make.centerX.equalTo(sender.mas_centerX);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(1);
    }];
    if (sender.tag==100) {
        contents.contentOffset= CGPointMake(0, 0);
    }else{
        contents.contentOffset= CGPointMake(self.width, 0);

    }
    
}
#pragma mark-----退出登录
-(void)logoutClick
{
    if (self.logoutAction) {
        self.logoutAction();
    }
}
-(void)reloadSubView;
{
    nickLab.text = [UserManager shraeUserManager].user.nickname;
    [headImg sd_setImageWithURL:[NSURL URLWithString:[UserManager shraeUserManager].user.headImg] placeholderImage:[UIImage imageNamed:@"default_headz"]];

}
//关于
-(void)creatAboutView
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
@end
