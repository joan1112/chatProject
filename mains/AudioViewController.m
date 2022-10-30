//
//  AudioViewController.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/22.
//

#import "AudioViewController.h"
#import "base/CommonMacros.h"
#import "../ThirdParty/Category/UIView+Frame.h"
#import "../ThirdParty/Masonry/Masonry.h"


//声网key

@interface AudioViewController ()
{
    UILabel *voiceLab;
    UILabel *mircLab;
    UILabel *time;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timerIndex;
@property (nonatomic, assign) BOOL isJoined;
@property (nonatomic, strong) NSMutableArray *viewArr;


@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewArr = [NSMutableArray array];
    [self initview];
    [self initAudio];
    [self initTimer];
    


}
-(void)initTimer{
//    _startTime = [[NSDate date] timeIntervalSince1970];
    
    self.timerIndex = 0;
    // 通话计时
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callTimerAction:) userInfo:nil repeats:YES];

}

- (void)callTimerAction:(NSTimer *)timer {
    self.timerIndex ++;
    NSString *str = [NSString stringWithFormat:@"%.2d:%.2d", self.timerIndex / 60,self.timerIndex % 60];
    time.text = str;
}
-(void)initAudio{

}

-(void)initview{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = kUIColorFromRGB(0x312828);
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    time = [[UILabel alloc]init];
    [bgView addSubview:time];
    time.text = @"00:00";
    time.textColor = [UIColor whiteColor];
    
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(20);
        make.centerX.equalTo(bgView.mas_centerX);
        
    }];
    
    UIImageView *headImg = [[UIImageView alloc]init];
    [bgView addSubview:headImg];
    headImg.backgroundColor = [UIColor greenColor];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(time.mas_bottom).offset(20);
        make.centerX.equalTo(bgView.mas_centerX);
        make.height.width.equalTo(@50);
    }];
    
    UILabel *nickName = [[UILabel alloc]init];
    [bgView addSubview:nickName];
    nickName.text = @"nake";
    nickName.textColor = [UIColor whiteColor];
    nickName.textAlignment = NSTextAlignmentCenter;
    
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImg.mas_bottom).offset(10);
        make.centerX.equalTo(bgView.mas_centerX);
        make.width.equalTo(@150);
    }];
    UIView *bottomView = [[UIView alloc]init];
    [bgView addSubview:bottomView];
    bottomView.userInteractionEnabled = YES;

    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).offset(-30);
        make.centerX.equalTo(bgView.mas_centerX);
        make.width.equalTo(@270);
        make.height.equalTo(@100);
    }];
    
    UIButton *mirc = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:mirc];
    [mirc setImage:[UIImage imageNamed:@"mirc"] forState:UIControlStateNormal];
    [mirc setImage:[UIImage imageNamed:@"audio_c"] forState:UIControlStateSelected];

    [mirc addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    mirc.tag = 10;

    
    mircLab = [[UILabel alloc]init];
    [bottomView addSubview:mircLab];
    mircLab.text = @"麦克风已开";
    mircLab.textColor = [UIColor whiteColor];
    mircLab.font = [UIFont systemFontOfSize:12];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:close];
    [close setImage:[UIImage imageNamed:@"finish_video"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    close.tag = 11;

    UILabel *closeLab = [[UILabel alloc]init];
    [bottomView addSubview:closeLab];
    closeLab.text = @"挂断";
    closeLab.textColor = [UIColor whiteColor];
    closeLab.font = [UIFont systemFontOfSize:12];

    
    UIButton *voice = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:voice];
    [voice setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [voice addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [voice setImage:[UIImage imageNamed:@"voice_o"] forState:UIControlStateSelected];

    voice.tag = 12;
    voiceLab = [[UILabel alloc]init];
    [bottomView addSubview:voiceLab];
    voiceLab.text = @"扬声器已关闭";
    voiceLab.textColor = [UIColor whiteColor];
    voiceLab.font = [UIFont systemFontOfSize:12];

    [@[mirc,close,voice] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
//        make.width.equalTo(@50);
    }];
    [@[mirc,close,voice] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:60 leadSpacing:0 tailSpacing:0];
    [@[mircLab,closeLab,voiceLab] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(50);
//        make.width.equalTo(@50);
    }];
    [mircLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mirc.mas_centerX);
    }];
    [closeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(close.mas_centerX);
    }];
    [voiceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(voice.mas_centerX);
    }];

    
    UIButton *small = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:small];
    [small setImage:[UIImage imageNamed:@"trnase_sml"] forState:UIControlStateNormal];
    [small addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    small.tag = 13;
    [small mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(20);
        make.left.equalTo(bgView.mas_left).offset(20);
        make.width.height.equalTo(@40);
    }];
}
-(void)btnClick:(UIButton*)sender
{
    if (sender.tag==11) {
        [self dismissViewControllerAnimated:NO completion:nil];
//        [ARWindowView loadWindowViewWithTime:@"00:23" status:2 vc:self];

//        [self dismissViewControllerAnimated:NO completion:nil];
    }else if (sender.tag==13){

//        [ARWindowView loadWindowViewWithTime:@"00:23" status:2 vc:self];
    }else{
        sender.selected =!sender.selected;
        if (sender.tag == 10) {
            mircLab.text = sender.selected?@"麦克风已关闭":@"麦克风已开";
        }else{
            voiceLab.text = sender.selected?@"扬声器已开":@"扬声器已关闭";

        }
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.hidden = NO;
  
   
   
    [self.timer invalidate];
    self.timer = nil;

}
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (parent==nil) {
        if (_isJoined) {
            
        }
    }
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
