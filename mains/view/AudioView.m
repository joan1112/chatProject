//
//  AudioView.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/24.
//

#import "AudioView.h"
#import "../../ThirdParty/Masonry/Masonry.h"
@interface AudioView()

@end
@implementation AudioView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}

-(void)initView{
    _videoView = [[UIView alloc]init];
    [self addSubview:_videoView];
    [_videoView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _uidLab = [[UILabel alloc]init];
    _uidLab.textColor = [UIColor whiteColor];
    _uidLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:_uidLab];
    _uidLab.text = @"1456";
    [_uidLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
@end
