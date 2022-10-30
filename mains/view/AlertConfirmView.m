//
//  AlertConfirmView.m
//  AKATOK
//
//  Created by junqiang on 2022/3/16.
//

#import "AlertConfirmView.h"
#import "../../ThirdParty/Masonry/Masonry.h"
#import "../base/CommonMacros.h"

@interface AlertConfirmView()
{
    UITextField *passtf;
}
@property (nonatomic, strong) UIView *superView;

@end
@implementation AlertConfirmView

-(instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type;
{
    self = [super initWithFrame:frame];
    if (self) {
        if (type==0) {
            [self createUI];
        }else if (type==1){
            [self loadingView];
        }else{
            [self downloadFinish];
        }
        
    }
    return self;
}
-(void)downloadFinish{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.superView];
    self.superView.frame = window.frame;
    [self.superView addSubview:self];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = kUIColorFromRGB(0x244C7F);

    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    bgView.userInteractionEnabled = YES;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(135);
    }];
    
    
    
    _tipLab = [[UILabel alloc]init];
    [bgView addSubview:_tipLab];
    _tipLab.textColor = UIColor.whiteColor;
    _tipLab.font = [UIFont systemFontOfSize:14];
    _tipLab.textAlignment = NSTextAlignmentCenter;
    _tipLab.numberOfLines = 0;
    _tipLab.text = @"[合肥]数据已链接完成";
    
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(25);
        make.left.equalTo(bgView.mas_left).offset(25);
        make.right.equalTo(bgView.mas_right).offset(-25);
//        make.height.mas_equalTo(40);
    }];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:cancel];
    cancel.backgroundColor = kUIColorFromRGB(0x2A77C7);
    [cancel setTitle:@"关闭" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancel.layer.cornerRadius = 5;
    cancel.layer.masksToBounds = YES;
    [cancel addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = 10;
    cancel.titleLabel.font = [UIFont systemFontOfSize:16];

    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:next];
    next.backgroundColor = kUIColorFromRGB(0xEDD466);
    [next setTitle:@"折跃" forState:UIControlStateNormal];
    next.layer.cornerRadius = 5;
    next.layer.masksToBounds = YES;
    [next addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    next.tag = 13;
    [next setTitleColor:kUIColorFromRGB(0x88512D) forState:UIControlStateNormal];
    next.titleLabel.font = [UIFont systemFontOfSize:16];


    [@[cancel,next] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset(-10);
        make.height.equalTo(@35);
    }];
    [@[cancel,next] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    
}
-(void)loadingView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.superView];
    self.superView.frame = window.frame;
    [self.superView addSubview:self];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = kUIColorFromRGB(0x244C7F);

    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    bgView.userInteractionEnabled = YES;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(130);
    }];
    UILabel *tipLab = [[UILabel alloc]init];
    [bgView addSubview:tipLab];
    tipLab.textColor = UIColor.whiteColor;
    tipLab.font = [UIFont systemFontOfSize:14];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.numberOfLines = 0;
    tipLab.text = @"资源下载";
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(15);
        make.left.equalTo(bgView.mas_left).offset(25);
        make.right.equalTo(bgView.mas_right).offset(-25);
//        make.height.mas_equalTo(40);
    }];
    
    _progress = [[UIProgressView alloc]init];
    _progress.progressTintColor = UIColor.whiteColor;
    _progress.progress = 0.0;
    _progress.progressViewStyle = UIProgressViewStyleDefault;
    _progress.layer.cornerRadius=5;
    _progress.layer.masksToBounds = YES;
    [bgView addSubview:_progress];
    
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(55);
        make.left.equalTo(bgView.mas_left).offset(25);
        make.right.equalTo(bgView.mas_right).offset(-25);
        make.height.mas_equalTo(10);
    }];
    
    
    _tipLab1 = [[UILabel alloc]init];
    [bgView addSubview:_tipLab1];
    _tipLab1.textColor = UIColor.whiteColor;
    _tipLab1.font = [UIFont systemFontOfSize:12];
    _tipLab1.textAlignment = NSTextAlignmentCenter;
    _tipLab1.numberOfLines = 0;
    _tipLab1.text = @"下载完成，正在解压缩包，请稍等...";
    _tipLab1.hidden = YES;
    
    [_tipLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progress.mas_bottom).offset(15);
        make.left.equalTo(bgView.mas_left).offset(25);
        make.right.equalTo(bgView.mas_right).offset(-25);
    }];
    
    
//    ic_close
//    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
//    [bgView addSubview:close];
//    [close setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
//    [close addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
//    [close mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(bgView.mas_right).offset(-5);
//        make.top.equalTo(bgView.mas_top).offset(5);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(20);
//    }];
}
-(void)createUI
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.superView];
    self.superView.frame = window.frame;
    [self.superView addSubview:self];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = kUIColorFromRGB(0x244C7F);

    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    bgView.userInteractionEnabled = YES;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(135);
    }];
    
    
    
    _tipLab = [[UILabel alloc]init];
    [bgView addSubview:_tipLab];
    _tipLab.textColor = UIColor.whiteColor;
    _tipLab.font = [UIFont systemFontOfSize:14];
    _tipLab.textAlignment = NSTextAlignmentCenter;
    _tipLab.numberOfLines = 0;
    _tipLab.text = @"即将链接合肥世界数据，消耗359M流量，是否继续";
    
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(25);
        make.left.equalTo(bgView.mas_left).offset(25);
        make.right.equalTo(bgView.mas_right).offset(-25);
//        make.height.mas_equalTo(40);
    }];
    
   
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:cancel];
    cancel.backgroundColor = kUIColorFromRGB(0x2A77C7);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancel.layer.cornerRadius = 5;
    cancel.layer.masksToBounds = YES;
    [cancel addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = 10;
    cancel.titleLabel.font = [UIFont systemFontOfSize:16];
    
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:next];
    next.backgroundColor = kUIColorFromRGB(0xEDD466);
    [next setTitle:@"继续" forState:UIControlStateNormal];
    next.layer.cornerRadius = 5;
    next.layer.masksToBounds = YES;
    [next addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    next.tag = 11;
    [next setTitleColor:kUIColorFromRGB(0x88512D) forState:UIControlStateNormal];

    next.titleLabel.font = [UIFont systemFontOfSize:16];

    [@[cancel,next] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset(-10);
        make.height.equalTo(@35);
    }];
    [@[cancel,next] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
}
-(void)nextClick:(UIButton*)sender
{
    if (sender.tag==10) {
        [self closeClick];
    }else if (sender.tag==13){//to game
        if (self.verfySuccess) {
            self.verfySuccess();
        }
        [self closeClick];
    }else{
        if (self.verfySuccess) {
            self.verfySuccess();
        }
        [self closeClick];
    }
}

-(void)closeClick
{
    [self hidePopView];
}
-(void)nextClick
{
    NSString *pass =  [[NSUserDefaults standardUserDefaults]objectForKey:@"coinPass"];

    if (![passtf.text isEqualToString:pass]) {
        return;
    }
    if (self.verfySuccess) {
        self.verfySuccess();
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
