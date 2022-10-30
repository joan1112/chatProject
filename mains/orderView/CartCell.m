//
//  CartCell.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/5.
//

#import "CartCell.h"
#import "../base/CommonMacros.h"
#import "../../ThirdParty/Category/UIView+Frame.h"
#import "../../ThirdParty/Masonry/Masonry.h"
#import "../view/BaseInfoView.h"
#import "../base/User/UserManager.h"
#import "../../ThirdParty/Category/UIView+Alert.h"
#import "../base/ConstMacros.h"
@interface CartCell()
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIImageView *goodsImg;
@property(nonatomic,strong)UILabel *titLab;
@property(nonatomic,strong)UILabel *styleLab;
@property(nonatomic,strong)UILabel *priceLab;

@property(nonatomic,strong)NSIndexPath *indexpath;

@end
@implementation CartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        
    }
    
    return self;
}
-(void)initView{
    UIImageView *bgView = [[UIImageView alloc]init];
    [self.contentView addSubview:bgView];
    //cart_bg_se
    bgView.image = [UIImage imageNamed:@"cart_bg_uns"];
    bgView.userInteractionEnabled = YES;

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);

    }];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:_selectBtn];
    [_selectBtn setImage:[UIImage imageNamed:@"list_unselect"] forState:UIControlStateNormal];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(20);
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.height.mas_equalTo(30);

    }];
    
    _goodsImg = [[UIImageView alloc]init];
    [bgView addSubview:_goodsImg];
    _goodsImg.backgroundColor = [UIColor grayColor];
    [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_selectBtn.mas_right).offset(20);
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.height.mas_equalTo(80);

    }];
    
    UIView *desView = [[UIView alloc]init];
    [bgView addSubview:desView];
//    desView.backgroundColor = kUIColorFromRGB(0x3E6EA5);
    [desView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_goodsImg.mas_right).offset(10);
        make.width.equalTo(bgView.mas_width).dividedBy(1.61);
        make.top.equalTo(bgView);
        make.right.equalTo(bgView);
        make.bottom.equalTo(bgView);
    }];
    _titLab = [[UILabel alloc]init];
    [desView addSubview:_titLab];
    _titLab.font = [UIFont systemFontOfSize:14];
    _titLab.textColor = UIColor.whiteColor;
    _titLab.text = @"商品名称";
    [_titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(desView.mas_left).offset(10);
        make.top.equalTo(desView.mas_top).offset(10);

    }];
    
    _styleLab = [[UILabel alloc]init];
    [desView addSubview:_styleLab];
    _styleLab.font = [UIFont systemFontOfSize:12];
    _styleLab.textColor = UIColor.whiteColor;
    _styleLab.text = @"商品名称";
    [_styleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(desView.mas_left).offset(10);
        make.top.equalTo(_titLab.mas_bottom).offset(10);

    }];
    _priceLab = [[UILabel alloc]init];
    [desView addSubview:_priceLab];
    _priceLab.textColor = kUIColorFromRGB(0x80F5FF);
    _priceLab.text = @"¥200.00";
    _priceLab.font = [UIFont systemFontOfSize:18];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(desView.mas_left).offset(10);
        make.bottom.equalTo(desView.mas_bottom).offset(-30);

    }];
    
    UIButton *remove = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:remove];
    [remove setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    [remove mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-18);
        make.top.equalTo(bgView.mas_top);
        make.width.height.equalTo(@30);
        
    }];
    
    UIImageView *caculateTool = [[UIImageView alloc]init];
    [bgView addSubview:caculateTool];
    caculateTool.image = [UIImage imageNamed:@"ca_bg"];
    caculateTool.userInteractionEnabled = YES;
    [caculateTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-40);
        make.bottom.equalTo(bgView.mas_bottom).offset(-30);
//        make.width.equalTo(@142);
        make.height.equalTo(@25);

    }];
    
    UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [caculateTool addSubview:reduceBtn];
    [reduceBtn setImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
    
    [reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(caculateTool.mas_left);
        make.centerY.equalTo(caculateTool.mas_centerY);

        make.height.mas_equalTo(25);
//        make.width.equalTo(@53.6);
       

    }];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [caculateTool addSubview:addBtn];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(caculateTool.mas_right);
        make.centerY.equalTo(caculateTool.mas_centerY);
        make.height.mas_equalTo(25);

 

    }];
    
    UILabel *numLab = [[UILabel alloc]init];
    [caculateTool addSubview:numLab];
    numLab.textColor = UIColor.blackColor;
    numLab.text = @"5";
    numLab.font = [UIFont systemFontOfSize:16];
    [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(caculateTool.mas_centerX);
        make.centerY.equalTo(caculateTool.mas_centerY);

    }];
    
    
}
-(void)loadDataWith:(NSIndexPath*)index;
{
    _indexpath = index;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
