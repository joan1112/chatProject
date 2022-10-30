//
//  CartView.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/5.
//

#import "CartView.h"
#import "../base/CommonMacros.h"
#import "../../ThirdParty/Category/UIView+Frame.h"
#import "../../ThirdParty/Masonry/Masonry.h"
#import "../view/BaseInfoView.h"
#import "../base/User/UserManager.h"
#import "../../ThirdParty/Category/UIView+Alert.h"
#import "../base/ConstMacros.h"
#import "CartCell.h"
#import "AddAddress.h"
@interface CartView()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,strong)UITableView *listTab;
@end
@implementation CartView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [self initSub];
        
    }
    return self;
}
-(void)initSub{
    
    _listTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height-60)];
    [self addSubview:_listTab];
    _listTab.backgroundColor = [UIColor clearColor];
    _listTab.delegate = self;
    _listTab.dataSource = self;
    _listTab.rowHeight = self.width/4.22;
    _listTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTab registerClass:[CartCell class] forCellReuseIdentifier:@"cart"];
    
    
    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height-60, self.width, 55)];
    [self addSubview:bgImg];
    bgImg.image = [UIImage imageNamed:@"bottom_1"];
    
    UIImageView *addrssIcon = [[UIImageView alloc]init];
    [bgImg addSubview:addrssIcon];
    addrssIcon.image = [UIImage imageNamed:@"address_icon"];
    [addrssIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImg.mas_top).offset(10);
        make.left.equalTo(bgImg.mas_left).offset(15);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(27);
    }];
    
    UILabel *messageLab = [[UILabel alloc]init];
    messageLab.text = @"陈某某 18897372922";
    [bgImg addSubview:messageLab];
    messageLab.font = [UIFont systemFontOfSize:14];
    messageLab.textColor = kUIColorFromRGB(0xB9E9FF);
    [messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImg.mas_top).offset(10);
        make.left.equalTo(addrssIcon.mas_right).offset(15);
       
    }];
    UILabel *adressDetail = [[UILabel alloc]init];
    [bgImg addSubview:adressDetail];
    adressDetail.text = @"合肥市蜀山区合肥市蜀山区合肥市蜀山区合肥市蜀山区";
    adressDetail.lineBreakMode=NSLineBreakByTruncatingTail;
    adressDetail.font = [UIFont systemFontOfSize:12];
    adressDetail.textColor = kUIColorFromRGB(0xB9E9FF);
    [adressDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageLab.mas_bottom).offset(5);
        make.left.equalTo(addrssIcon.mas_right).offset(15);
        make.width.lessThanOrEqualTo(@180);
       
    }];
    UIButton *editeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgImg addSubview:editeBtn];
    [editeBtn setImage:[UIImage imageNamed:@"edite"] forState:UIControlStateNormal];
    
    [editeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageLab.mas_bottom).offset(5);
        make.left.equalTo(adressDetail.mas_right).offset(15);
        make.width.height.mas_equalTo(20);
       
    }];
    
    UIImageView *bgImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height-60, self.width, 60)];
    [self addSubview:bgImg1];
    bgImg1.image = [UIImage imageNamed:@"bottom_2"];
    bgImg1.userInteractionEnabled = YES;
    
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgImg1 addSubview:payBtn];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    [payBtn setTitle:@"支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:kUIColorFromRGB(0x88512D) forState:UIControlStateNormal];
    
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgImg1.mas_right).offset(-15);
        make.centerY.equalTo(bgImg1.mas_centerY);
        make.width.mas_equalTo(154);
        make.height.mas_equalTo(32);

    }];
    
    UILabel *totalPrice = [[UILabel alloc]init];
    [bgImg1 addSubview:totalPrice];
    totalPrice.text = @"合计";
    totalPrice.textColor = kUIColorFromRGB(0xFFF88C);
    totalPrice.font = [UIFont systemFontOfSize:14];
    
 
    UILabel *totalPriceNum = [[UILabel alloc]init];
    [bgImg1 addSubview:totalPriceNum];
    totalPriceNum.text = @"¥0";
    totalPriceNum.textColor = kUIColorFromRGB(0xFFF88C);
    totalPriceNum.font = [UIFont systemFontOfSize:18];
    
    [totalPriceNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(payBtn.mas_left).offset(-15);
        make.centerY.equalTo(bgImg1.mas_centerY).offset(-5);
      

    }];
    [totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(totalPriceNum.mas_left);
        make.centerY.equalTo(bgImg1.mas_centerY).offset(-5);
      

    }];
    
    UILabel *totalNum = [[UILabel alloc]init];
    [bgImg1 addSubview:totalNum];
    totalNum.text = @"共0件商品";
    totalNum.textColor = UIColor.whiteColor;
    totalNum.font = [UIFont systemFontOfSize:12];
    [totalNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(payBtn.mas_left).offset(-15);
        make.centerY.equalTo(bgImg1.mas_centerY).offset(10);


    }];
   

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cart"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor= [UIColor clearColor];
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddAddress *add = [[AddAddress alloc]initWithFrame:self.frame withInfo:@""];
   
    [add showPopView];
}
@end
