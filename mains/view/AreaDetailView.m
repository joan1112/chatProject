//
//  AreaDetailView.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/25.
//

#import "AreaDetailView.h"
#import "../../ThirdParty/Masonry/Masonry.h"
#import "../../ThirdParty/Category/UIView+Frame.h"

#import "../base/CommonMacros.h"
#import <AVKit/AVKit.h>
@interface ItemCell : UITableViewCell
@property(nonatomic,strong)UIImageView *iconImg;
@property(nonatomic,strong)UILabel *num;
@property(nonatomic,strong)UILabel *desLab;

@end
@implementation ItemCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        _iconImg = [[UIImageView alloc]init];
        [self.contentView addSubview:_iconImg];
        [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.height.equalTo(@16);
        }];
        
        _num = [[UILabel alloc]init];
        [self.contentView addSubview:_num];
        _num.textColor = kUIColorFromRGB(0x1C4677);
        _num.font = [UIFont systemFontOfSize:8];
        [_num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.iconImg.mas_centerX);
            make.centerY.equalTo(self.iconImg.mas_centerY);
           
        }];
        _desLab = [[UILabel alloc]init];
        [self.contentView addSubview:_desLab];
        _desLab.textColor = kUIColorFromRGB(0xC0E1F1);
        _desLab.font = [UIFont systemFontOfSize:12];
        [_desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImg.mas_right).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
           
        }];
    }
    return self;
}
@end
@interface AreaDetailView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *superView;
@property(nonatomic,strong)AVPlayer *moviePlayer;
@property(nonatomic,strong)UITableView *list;
@property(nonatomic,strong)NSString *city;

@end
@implementation AreaDetailView

-(instancetype)initWithFrame:(CGRect)frame withCity:(nonnull NSString *)city
{
    self = [super initWithFrame:frame];
    if (self) {
        self.city = city;
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
    
    UIImageView *bgView = [[UIImageView alloc]init];
    [self addSubview:bgView];
    bgView.frame = CGRectMake(50, 40,  (KScreenHeight-100)*1.88, KScreenHeight-100);
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    bgView.userInteractionEnabled = YES;
    bgView.image = [UIImage imageNamed:@"detail_bg"];
    bgView.centerX = self.centerX;
    UILabel *ads = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, 150, 20)];
    [bgView addSubview:ads];
    ads.text = self.city;
    ads.textColor = [UIColor whiteColor];
    ads.font = [UIFont systemFontOfSize:15];
   
    
    NSString *mps = [[NSBundle mainBundle]pathForResource:@"F1-02" ofType:@"mp4"];
    NSURL *moview = [NSURL fileURLWithPath:mps];
    // load movie
    self.moviePlayer = [AVPlayer playerWithURL:moview];
    AVPlayerLayer *lay = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    lay.videoGravity = AVLayerVideoGravityResizeAspectFill;
    lay.position = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    lay.frame = CGRectMake(30, 48,(bgView.width-60)*2/3, bgView.height-115);
    [bgView.layer addSublayer:lay];
    [self.moviePlayer play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.moviePlayer.currentItem];

    
    _list = [[UITableView alloc]initWithFrame:CGRectMake((bgView.width-60)*2/3 + 40, 48, (bgView.width-60)/3 - 10, bgView.height-115) style:UITableViewCellStyleDefault];
    [bgView addSubview:_list];
    _list.delegate = self;
    _list.dataSource = self;
    _list.rowHeight = 30;

    _list.backgroundColor = kUIColorFromRGB(0x3B70AE);
    [_list registerClass:[ItemCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(30, bgView.height-65, (bgView.width-60)*2/3, 40)];
    [bgView addSubview:bottomView];
    
    
    NSArray *icons = @[@"shop",@"enjoy",@"food",@"play"];
    for (int i = 0; i<4; i++) {
        UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(65*i, 8, 55, 28)];
        [bottomView addSubview:vv];
        vv.backgroundColor = kUIColorFromRGB(0x2A5EA4);
        
        UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 22, 28)];
        [vv addSubview:leftV];
        leftV.backgroundColor = kUIColorFromRGB(0x254C7D);
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 8, 12, 12)];
        [leftV addSubview:img];
        img.backgroundColor = kUIColorFromRGB(0x254C7D);
        img.image = [UIImage imageNamed:icons[i]];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 30, 14)];
        lab.font = [UIFont systemFontOfSize:9];
        [vv addSubview:lab];
        lab.text = @"购物";
        lab.textColor = kUIColorFromRGB(0xC5E6FF);
        UILabel *labNum = [[UILabel alloc]initWithFrame:CGRectMake(25, 14, 30, 14)];
        labNum.font = [UIFont systemFontOfSize:9];
        [vv addSubview:labNum];
        labNum.text = @"123";
        labNum.textColor = kUIColorFromRGB(0xC5E6FF);
        
    }
//    数字藏品
    UILabel *labNum = [[UILabel alloc]initWithFrame:CGRectMake(bottomView.width-80, 8, 80, 14)];
    labNum.font = [UIFont systemFontOfSize:10];
    [bottomView addSubview:labNum];
    labNum.text = @"数字藏品 20";
    labNum.textColor = kUIColorFromRGB(0xC5E6FF);
    
    UILabel *levelLab = [[UILabel alloc]initWithFrame:CGRectMake(bottomView.width-80, 22, 80, 14)];
    levelLab.font = [UIFont systemFontOfSize:10];
    [bottomView addSubview:levelLab];
    levelLab.text = @"全国第10名";
    levelLab.textColor = kUIColorFromRGB(0xC5E6FF);
    
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
    
    next.frame = CGRectMake((bgView.width-60)*2/3 + 40, bgView.height-58, (bgView.width-60)/3 - 10, 30);
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:close];
    [close setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-5);
        make.top.equalTo(bgView.mas_top).offset(5);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self creatTableHeader];
}

-(void)creatTableHeader{
    UIImageView *vv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _list.width, 25)];
    vv.image = [UIImage imageNamed:@"collect_top"];
    UILabel *tit = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, vv.width, 25)];
    [vv addSubview:tit];
    tit.text = @"数字藏品热度榜";
    tit.textColor = UIColor.whiteColor;
    tit.font = [UIFont systemFontOfSize:14];
    tit.textAlignment = NSTextAlignmentCenter;
    _list.tableHeaderView = vv;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.desLab.text = @[@"DC超级市场",@"质量效应主题公园",@"太阳之冕次元影城",@"太阳之冕次元影城",@"太阳之冕次元影城",@"太阳之冕次元影城"][indexPath.row];
  
    cell.backgroundColor = kUIColorFromRGB(0x1B4575);
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.row<3) {
        cell.iconImg.image = [UIImage imageNamed:@[@"no1",@"no2",@"no3"][indexPath.row]];
        cell.num.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.num.textColor = kUIColorFromRGB(0x1C4677);

    }else{
        cell.iconImg.image = [UIImage imageNamed:@"no4+"];
        cell.num.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.num.textColor = UIColor.whiteColor;
    }
  
    return  cell;
    
}

-(void)closeClick{
    [self hidePopView];
}
-(void)nextClick:(UIButton*)sender
{
    if (self.gogame) {
        self.gogame();
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
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }];
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
- (UIView *)superView
{
    if (!_superView)
    {
        _superView = [[UIView alloc] init];
    }
    return _superView;
}
@end



