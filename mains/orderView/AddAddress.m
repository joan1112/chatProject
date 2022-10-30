//
//  AddAddress.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/6.
//

#import "AddAddress.h"
#import "../base/CommonMacros.h"
#import "../../ThirdParty/Category/UIView+Frame.h"
#import "../../ThirdParty/Masonry/Masonry.h"
#import "../view/BaseInfoView.h"
#import "../base/User/UserManager.h"
#import "../../ThirdParty/Category/UIView+Alert.h"
#import "../base/ConstMacros.h"
#import "PINTextView.h"
#import "IQUIScrollView+Additions.h"
#import "AddressPickerView/AddressPickerView.h"
@interface AddAddress()<UITextFieldDelegate,AddressPickerViewDelegate>
{
    UIImageView *bgView;
    BOOL isDefault;
}
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) UIScrollView *contentScroll;
@property (nonatomic ,strong) AddressPickerView * pickerView;

@end
@implementation AddAddress
-(instancetype)initWithFrame:(CGRect)frame withInfo:(NSString*)info;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        
    }
    return self;
}
-(void)createUI
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self.superView];
    self.superView.frame = window.frame;
    [self.superView addSubview:self];
    
    bgView = [[UIImageView alloc]init];
    [self addSubview:bgView];
    bgView.frame = CGRectMake((KScreenWidth-(KScreenHeight-80)*1.76)/2, 40,  (KScreenHeight-80)*1.76, KScreenHeight-80);
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    bgView.userInteractionEnabled = YES;
    bgView.image = [UIImage imageNamed:@"alert_bg"];

    _contentScroll  = [[UIScrollView alloc]init];
    [bgView addSubview:_contentScroll];
    _contentScroll.shouldIgnoreScrollingAdjustment = YES;
    _contentScroll.shouldRestoreScrollViewContentOffset = YES;
    [_contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(40);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
        make.bottom.equalTo(bgView.mas_bottom).offset(-15);
        
        
    }];
    
    
    UIImageView *titleBg = [[UIImageView alloc]init];
    [bgView addSubview:titleBg];
    titleBg.image = [UIImage imageNamed:@"tit_bg"];
    
    UILabel *titLab = [[UILabel alloc]init];
    [titleBg addSubview:titLab];
    titLab.textColor = kUIColorFromRGB(0xBBEDFF);
    titLab.font = [UIFont systemFontOfSize:12];
    titLab.text = @"添加地址";
    [titleBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(bgView.mas_top).offset(15);
        make.height.mas_equalTo(23);
        
    }];
    
    [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleBg.mas_centerX);
        make.top.equalTo(titleBg.mas_top);
        make.height.mas_equalTo(23);
        
    }];
//    联系人 手机号
    CGFloat wd = (bgView.width-50)/2;
    CGFloat top = 0;
    CGFloat perH = 35;
    CGFloat y=top;
    [self creatMsgWith:@"联系人" WithTag:0 WithFrame:CGRectMake(25, top, wd-10, perH)];
  
    [self creatMsgWith:@"手机号" WithTag:1 WithFrame:CGRectMake(25+wd, top, wd, perH)];
    y = y+perH+10;
    [self creatMsgWith:@"选择地区" WithTag:2 WithFrame:CGRectMake(25, y, bgView.width-50, perH)];
    y = y+perH+10;
    [self creatMsgWith:@"详细地址" WithTag:3 WithFrame:CGRectMake(25, y, bgView.width-50, perH+45)];
    y = y+perH+10+45;
    [self creatMsgWith:@"邮政编码" WithTag:4 WithFrame:CGRectMake(25, y, bgView.width-50, perH)];
    y = y+perH+10;
    
    UIView *copyFrom = [[UIView alloc]init];
    copyFrom.backgroundColor = kUIColorFromRGB(0xE9ECF1);
    [_contentScroll addSubview:copyFrom];
    copyFrom.frame = CGRectMake(100, y, bgView.width-125, 80);
    copyFrom.layer.borderColor = kUIColorFromRGB(0x5ED4FF).CGColor;
    copyFrom.layer.borderWidth = .5;
   
    
    UILabel *desLab = [[UILabel alloc]init];
    desLab.text = @"地址信息包含手机号码和地址等。";
    desLab.font = [UIFont systemFontOfSize:12];
    desLab.textColor = kUIColorFromRGB(0x898FA5);
    [copyFrom addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(copyFrom.mas_left).offset(20);
        make.top.equalTo(copyFrom.mas_top).offset(10);
       

    }];
    UILabel *tipLab = [[UILabel alloc]init];
    tipLab.text = @"粘贴并识别地址。";
    tipLab.font = [UIFont systemFontOfSize:12];
    tipLab.textColor = kUIColorFromRGB(0x2A91D8);
    [copyFrom addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(copyFrom.mas_right).offset(-10);
        make.bottom.equalTo(copyFrom.mas_bottom).offset(-10);
       

    }];
    y=y+90;
    
    
    UIButton *isDefault = [UIButton buttonWithType:UIButtonTypeCustom];
    [isDefault setImage:[UIImage imageNamed:@"default_unselect"] forState:UIControlStateNormal];
    [isDefault setImage:[UIImage imageNamed:@"default-select"] forState:UIControlStateSelected];
    [_contentScroll addSubview:isDefault];
    [isDefault setTitle:@" 默认" forState:UIControlStateNormal];
    isDefault.titleLabel.font = [UIFont systemFontOfSize:12];
    [isDefault setTitleColor:kUIColorFromRGB(0xE9ECF1) forState:UIControlStateNormal];
    [isDefault addTarget:self action:@selector(setDefaultClick:) forControlEvents:UIControlEventTouchUpInside];
    [isDefault mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentScroll.mas_left).offset(25);
        make.top.equalTo(_contentScroll.mas_top).offset(y+10);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    

    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contentScroll addSubview:saveBtn];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"button_bg2"] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(_contentScroll.mas_top).offset(y);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.bottom.equalTo(_contentScroll.mas_bottom).offset(-20);

    }];

    _contentScroll.contentSize = CGSizeMake(0, y+60);
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"close_1"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-25);
        make.top.equalTo(bgView.mas_top).offset(15);
        make.width.height.equalTo(@20);
    }];
    
//    [self.superview addSubview:self.pickerView];

}
-(void)creatMsgWith:(NSString*)tip WithTag:(NSInteger)tag WithFrame:(CGRect)frame{
    UIView *msgView = [[UIView alloc]init];
    [_contentScroll addSubview:msgView];
    msgView.frame =frame;
    
    UILabel *dotLab = [[UILabel alloc]init];
    [msgView addSubview:dotLab];
    dotLab.text = @"*";
    dotLab.textColor = kUIColorFromRGB(0xEF5F5F);
    dotLab.frame = CGRectMake(0, 5, 10, msgView.height);
    
    UILabel *lab = [[UILabel alloc]init];
    [msgView addSubview:lab];
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:13];
    lab.text = tip;
    lab.frame = CGRectMake(15, 0,60, msgView.height);
    UIView *tfBg = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame),0, msgView.width-75, msgView.height)];
    [msgView addSubview:tfBg];
    tfBg.userInteractionEnabled = YES;
    tfBg.backgroundColor = kUIColorFromRGB(0xE9ECF1);


    if (tag==3) {
        
        PINTextView *detailText = [[PINTextView alloc]initWithFrame:CGRectMake(10, 0, tfBg.width-10, msgView.height)];
        [tfBg addSubview:detailText];
        detailText.placeholder = @"街道门牌信息";
        

    }else{
       
        
        UITextField *tf = [[UITextField alloc]init];
        tf.tag = tag;
        tf.delegate = self;
        tf.placeholder = tip;
        tf.font = [UIFont systemFontOfSize:13];
        tf.frame = CGRectMake(10,0, tfBg.width-10, msgView.height);
        [tfBg addSubview:tf];
    }


    
    
}
- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:50 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
//        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}
-(void)setDefaultClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    isDefault = sender.selected ;
}
#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    NSLog(@"-=====%@-%@",province,city);
    [self.pickerView hide];

}


-(void)closeClick
{
    [self hidePopView];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==2) {
        [self.pickerView show];
        return NO;
    }
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

- (UIView *)superView
{
    if (!_superView)
    {
        _superView = [[UIView alloc] init];
    }
    return _superView;
}
@end
