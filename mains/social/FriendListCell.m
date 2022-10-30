//
//  FriendListCell.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/9.
//

#import "FriendListCell.h"
#import "../../ThirdParty/Masonry/Masonry.h"
#import "../base/CommonMacros.h"
@interface FriendListCell()


@end
@implementation FriendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}
-(void)initView
{
    _headImg = [[UIImageView alloc]init];
    [self.contentView addSubview:_headImg];
    _headImg.image = [UIImage imageNamed:@"default_headz"];
    
    _nickName = [[UILabel alloc]init];
    [self.contentView addSubview:_nickName];
    _nickName.text = @"幽默的";
    _nickName.textColor = [UIColor whiteColor];
    _nickName.font = [UIFont systemFontOfSize:12];
    
    _timeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_timeLab];
    _timeLab.font = [UIFont systemFontOfSize:10];
//    #FFDD1E
    _timeLab.textColor = kUIColorFromRGB(0xFFDD1E);
    _timeLab.text = @"在线";
    
    _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_audioBtn setImage:[UIImage imageNamed:@"audio"] forState:UIControlStateNormal];
    [self.contentView addSubview:_audioBtn];
    
    _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_videoBtn setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [self.contentView addSubview:_videoBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [self.contentView addSubview:_shareBtn];
    
    [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(40);
    }];
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImg.mas_right).offset(5);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImg.mas_right).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [_videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(22);
    }];
    [_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.videoBtn.mas_left).offset(-5);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(22);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation SearchCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *searchImg = [[UIImageView alloc]init];
        [self.contentView addSubview:searchImg];
        searchImg.image = [UIImage imageNamed:@"search"];
        
        UILabel *seacrhTip = [[UILabel alloc]init];
        [self.contentView addSubview:seacrhTip];
        seacrhTip.text = @"搜索";
        seacrhTip.font = [UIFont systemFontOfSize:12];
        seacrhTip.textColor = kUIColorFromRGB(0xDBEBF9);
        
        _seachLab = [[UILabel alloc]init];
        [self.contentView addSubview:_seachLab];
        _seachLab.text = @"";
        _seachLab.font = [UIFont systemFontOfSize:12];
        _seachLab.textColor = kUIColorFromRGB(0xDBEBF9);
        [searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.height.equalTo(@20);
        }];
        [seacrhTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchImg.mas_right).offset(5);
            make.centerY.equalTo(self.contentView.mas_centerY);
           
        }];
        [_seachLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(seacrhTip.mas_right).offset(5);
            make.centerY.equalTo(self.contentView.mas_centerY);
           
        }];
    }
    return self;
}


@end
@interface SearchResultCell()


@end
@implementation SearchResultCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _searchImg = [[UIImageView alloc]init];
        [self.contentView addSubview:_searchImg];
        _searchImg.image = [UIImage imageNamed:@"default_headz"];
        
        _seacrhTip = [[UILabel alloc]init];
        [self.contentView addSubview:_seacrhTip];
        _seacrhTip.text = @"恰年";
        _seacrhTip.font = [UIFont systemFontOfSize:12];
        _seacrhTip.textColor = kUIColorFromRGB(0xDBEBF9);
        
       _tideNum = [[UILabel alloc]init];
        [self.contentView addSubview:_tideNum];
        _tideNum.text = @"TIDE号：123456789";
        _tideNum.font = [UIFont systemFontOfSize:12];
        _tideNum.textColor = kUIColorFromRGB(0xDBEBF9);
        _tideNum.contentMode = UIViewContentModeScaleAspectFit;
        
        
        [_searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.height.equalTo(@20);
        }];
        [_seacrhTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_searchImg.mas_right).offset(5);
            make.centerY.equalTo(self.contentView.mas_centerY);
           
        }];
        [_tideNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(100);
        }];
    }
    return self;
}


@end

@implementation FriendRequestCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    _headImg = [[UIImageView alloc]init];
    [self.contentView addSubview:_headImg];
    _headImg.image = [UIImage imageNamed:@"default_headz"];
    
    _nickName = [[UILabel alloc]init];
    [self.contentView addSubview:_nickName];
    _nickName.text = @"幽默的";
    _nickName.textColor = [UIColor whiteColor];
    _nickName.font = [UIFont systemFontOfSize:12];
    
    _timeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_timeLab];
    _timeLab.font = [UIFont systemFontOfSize:10];
//    #FFDD1E
    _timeLab.textColor = kUIColorFromRGB(0xFFDD1E);
    _timeLab.text = @"我：你好";
    
    _statusImg = [[UIImageView alloc]init];
    _statusImg.image = [UIImage imageNamed:@"status_1"];
    [self.contentView addSubview:_statusImg];
    
    _statusLab = [[UILabel alloc]init];
    _statusLab.text = @"等待验证";
    _statusLab.textColor = [UIColor whiteColor];
    _statusLab.font = [UIFont systemFontOfSize:12];
    _statusImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_statusLab];
    
    UIButton *agreeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setBackgroundImage:[UIImage imageNamed:@"agree_bg"] forState:UIControlStateNormal];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [agreeBtn setTitleColor:kUIColorFromRGB(0x88512D) forState:UIControlStateNormal];
    [self.contentView addSubview:agreeBtn];
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(22);
    }];
    
    UIButton *refuseBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [refuseBtn setBackgroundImage:[UIImage imageNamed:@"refuse_bg1"] forState:UIControlStateNormal];
    [refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [refuseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.contentView addSubview:refuseBtn];
    refuseBtn.titleLabel.font = [UIFont systemFontOfSize:12];

    self.agreeBtn = agreeBtn;
    self.refuseBtn = refuseBtn;
    [refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(22);
    }];
    
    [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImg.mas_right).offset(5);
        make.top.equalTo(self.headImg.mas_top).offset(0);
    }];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImg.mas_right).offset(5);
        make.bottom.equalTo(self.headImg.mas_bottom).offset(0);
    }];
    
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [_statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusLab.mas_left).offset(-5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.equalTo(@15);
    }];
}

@end
