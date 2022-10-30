//
//  FriendListView.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/9.
//

#import "FriendListView.h"
#import "../../ThirdParty/Category/UIView+Frame.h"
#import "../base/CommonMacros.h"
#import "FriendListCell.h"
#import "../orderView/PINTextView.h"
#import "model/FriendModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RecentView.h"
@interface FriendListView()<UITableViewDelegate,UITableViewDataSource,RecentDelegate>
{
    UIButton *btnSelect;
}
@property(nonatomic,strong)UIScrollView *listScroll;
@property(nonatomic,strong)UILabel *dotLab;
@property(nonatomic,strong)UITableView *listTab;
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,strong)RecentView *recents;

@end
@implementation FriendListView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *friends =  [[NIMSDK sharedSDK].userManager myFriends];
        NSLog(@"---------好友liebiao===%ld",friends.count);

    }
    return self;
}
-(void)reloadDataWithArr:(NSArray*)arr;
{
    self.datas = arr;
    [self.listTab reloadData];
}
-(void)friendRequestChanged;
{
    _dotLab.hidden = NO;

}
-(void)creatView{
    
    
    UIImageView *content = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    content.image = [UIImage imageNamed:@"friend_c_bg"];
    [self addSubview:content];
    content.userInteractionEnabled = YES;
    
   _listScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, self.width-5, self.height-40)];
    
    [content addSubview:_listScroll];
    _listScroll.contentSize = CGSizeMake((self.width-5)*2, 0);
    _listScroll.pagingEnabled = YES;
    _listScroll.scrollEnabled = NO;
    
    
    
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@[@"好友",@"最近"][i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:kUIColorFromRGB(0x7CADD7) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"select_top"] forState:UIControlStateSelected];
        if (i==0) {
            btn.selected = YES;
            btnSelect = btn;
        }
        btn.frame = CGRectMake(i*(self.width-5)/2, 0, (self.width-5)/2, 40);
        [content addSubview:btn];
        btn.tag = 30+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(topClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _listTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, content.height-80)];
    [_listScroll addSubview:_listTab];
    _listTab.delegate = self;
    _listTab.dataSource = self;
    _listTab.rowHeight = 60;
    _listTab.backgroundColor = [UIColor clearColor];
    [_listTab registerClass:[FriendListCell class] forCellReuseIdentifier:@"cell"];
    _recents = [[RecentView alloc]initWithFrame:CGRectMake(self.width-5, 0, self.width-5, content.height-80)];
    [_listScroll addSubview:_recents];
    _recents.delegate = self;
    
    
    
    UIImageView *top = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height-40, self.width-5,  40)];
    [content addSubview:top];
//    top.image = [UIImage imageNamed:@"friend_top_bg"];
    top.backgroundColor = kUIColorFromRGB(0x5C8CC6);
    top.userInteractionEnabled = YES;
    
    UIButton *aplayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [top addSubview:aplayBtn];
    [aplayBtn setTitle:@"好友申请" forState:UIControlStateNormal];
    [aplayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    aplayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    aplayBtn.frame = CGRectMake(0, 0, (self.width-6)/2, 40);
    [aplayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    aplayBtn.tag = 10;
    
    
    _dotLab = [[UILabel alloc]init];
    [aplayBtn addSubview:_dotLab];
    _dotLab.frame = CGRectMake((self.width-6)/4 +30, 15, 4, 4);
    _dotLab.layer.cornerRadius = 2;
    _dotLab.layer.masksToBounds = YES;
    _dotLab.backgroundColor = kUIColorFromRGB(0xFFBA00);
    _dotLab.hidden = YES;
    NSInteger systemCount = [[[NIMSDK sharedSDK] systemNotificationManager] allUnreadCount];
    NSLog(@"count===%ld",systemCount);
    if (systemCount>0) {
        _dotLab.hidden = NO;
    }
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((self.width-6)/2, 10, .6, 30)];
    line.backgroundColor = kUIColorFromRGB(0x52B4EC);
    [top addSubview:line];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [top addSubview:addBtn];
    [addBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    addBtn.frame = CGRectMake((self.width-6)/2 + 1, 0, (self.width-6)/2, 40);
    [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = 11;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FriendModel *model = _datas[indexPath.row];
    cell.nickName.text = model.nickname;
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.user_icon] placeholderImage:[UIImage imageNamed:@"default_headz"]];
    cell.timeLab.text = model.online==0?@"离线":@"在线";
    [cell.audioBtn addTarget:self action:@selector(audioClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.audioBtn.tag = indexPath.row;
    [cell.videoBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.videoBtn.tag = indexPath.row;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendModel *model = _datas[indexPath.row];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(friendListCellClick:)]) {
        [self.delegate friendListCellClick:model.f_uuid];
    }
}
-(void)audioClick:(UIButton*)sender
{
    FriendModel *model = _datas[sender.tag];

    if ([self.delegate respondsToSelector:@selector(friendListClickWith:withId:)]) {
        [self.delegate friendListClickWith:10 withId:model.f_uuid];
    }
}
-(void)videoClick:(UIButton*)sender
{
    FriendModel *model = _datas[sender.tag];

    if ([self.delegate respondsToSelector:@selector(friendListClickWith:withId:)]) {
        [self.delegate friendListClickWith:11 withId:model.f_uuid];
    }
}
-(void)btnClick:(UIButton*)sender
{
//    10 applay 11 add
    if ([self.delegate respondsToSelector:@selector(friendListClickWith:withId:)]) {
        [self.delegate friendListClickWith:sender.tag-10 withId:@""];
        _dotLab.hidden = YES;
    }
    
}
#pragma mark---recent deleagte
-(void)onSelectedRecent:(NIMRecentSession *)recentSession atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(recentListClik:)]) {
        [self.delegate recentListClik:recentSession.session];
    }
}

-(void)topClick:(UIButton*)sender
{

    if (sender != btnSelect) {
        sender.selected = !sender.selected;
        btnSelect.selected = NO;
        btnSelect.backgroundColor = [UIColor clearColor];
        btnSelect = sender;
        if (sender.tag == 30) {
            [_listScroll setContentOffset:CGPointMake(0, 0)];
        }else{
            [_listScroll setContentOffset:CGPointMake(self.width-5, 0)];

        }
    }
    
}

@end
@interface AddFriendView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BOOL isSearching;
    NSString *searchText;
}
@property(nonatomic,strong)UITableView *listTab;
@property(nonatomic,strong)UITextField *seachTf;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)NSArray *resultDatas;

@end
@implementation AddFriendView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;

}
-(void)creatView
{
    
    
    UIImageView *content = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.width, self.height)];
    content.image = [UIImage imageNamed:@"friend_c_bg"];
    [self addSubview:content];
    content.userInteractionEnabled = YES;
    
    UIImageView *bgSearch = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, self.width-60, 40)];
    [content addSubview:bgSearch];
    bgSearch.image = [UIImage imageNamed:@"search_bg"];
    bgSearch.userInteractionEnabled = YES;
    
    UIImageView *seach_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 12, 16, 16)];
    [bgSearch addSubview:seach_icon];
    seach_icon.image = [UIImage imageNamed:@"seach_icon"];
    
    _seachTf = [[UITextField alloc]initWithFrame:CGRectMake(25, 0, bgSearch.width-80, 40)];
    [bgSearch addSubview:_seachTf];
    _seachTf.font = [UIFont systemFontOfSize:12];
    _seachTf.placeholder = @"手机号/昵称";
    _seachTf.delegate = self;
    _seachTf.textColor = [UIColor whiteColor];
    
   _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgSearch addSubview:_closeBtn];
    _closeBtn.frame = CGRectMake(bgSearch.width-35, 5,30, 30);
    [_closeBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.hidden = YES;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [content addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(0, 0, 40, 40);
    [cancelBtn setImage:[UIImage imageNamed:@"back_12"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    _listTab = [[UITableView alloc]initWithFrame:CGRectMake(0,40, self.width, content.height)];
    [content addSubview:_listTab];
    _listTab.delegate = self;
    _listTab.dataSource = self;
    _listTab.rowHeight = 40;
    _listTab.backgroundColor = [UIColor clearColor];
    [_listTab registerClass:[SearchCell class] forCellReuseIdentifier:@"search"];
    [_listTab registerClass:[SearchResultCell class] forCellReuseIdentifier:@"searchResult"];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!isSearching) {
        return 1;
    }
    return _resultDatas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!isSearching){
        SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.seachLab.text = searchText;
        return cell;
    }
    SearchResultModel *model = _resultDatas[indexPath.row];
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResult"];
    cell.backgroundColor = [UIColor clearColor];
    [cell.searchImg sd_setImageWithURL:[NSURL URLWithString:model.user_icon] placeholderImage:[UIImage imageNamed:@"default_headz"]];
    cell.seacrhTip.text = model.nickname;
    cell.tideNum.text = model.uuid;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isSearching) {
        [_seachTf resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(searchText:)]) {
            [self.delegate searchText:_seachTf.text];
        }
//        [tableView reloadData];
    }else{
        SearchResultModel *model = _resultDatas[indexPath.row];

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([self.delegate respondsToSelector:@selector(didSelectWithModel:)]) {
            [self.delegate didSelectWithModel:model];
        }
    }
}
#pragma mark---搜索结果
-(void)searchResultData:(NSArray*)data;
{
    _resultDatas = data;
    isSearching = YES;

    [self.listTab reloadData];
}
//取消
-(void)cancelClick{
    if ([self.delegate respondsToSelector:@selector(addFriendClickWith:withId:)]) {
        [self.delegate addFriendClickWith:0 withId:@""];
    }
}
-(void)closeClick{
    _seachTf.text = @"";
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    isSearching = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableString *changeStr = [[NSMutableString alloc]initWithString:textField.text];
    [changeStr replaceCharactersInRange:range withString:string];
    if (changeStr.length>0) {
        _closeBtn.hidden = NO;
    }else{
        _closeBtn.hidden = YES;

    }
    searchText = [NSString stringWithFormat:@"%@",changeStr];
    [self.listTab reloadData];
    return YES;
}
//-(void)btnClick:(UIButton*)sender{
//    if ([self.delegate respondsToSelector:@selector(addFriendClickWith:withId:)]) {
//        [self.delegate addFriendClickWith:0 withId:@""];
//    }
//}
@end
#pragma mark---好友详情
@implementation FriendDetail

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)creatView
{
    UIImageView *top = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width,  50)];
    [self addSubview:top];
    top.image = [UIImage imageNamed:@"friend_top_bg"];
    top.userInteractionEnabled = YES;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [top addSubview:back];
    back.frame = CGRectMake(10, 10, 30, 30);
    [back addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    back.tag = 10;
    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2 - 40, 10, 80, 30)];
    lab.text = @"详情";
    [top addSubview:lab];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = UIColor.whiteColor;
    lab.font = [UIFont systemFontOfSize:14];
    
    UIImageView *content = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(top.frame), self.width, self.height-50)];
    content.image = [UIImage imageNamed:@"friend_c_bg"];
    [self addSubview:content];
    content.userInteractionEnabled = YES;
    
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
    [content addSubview:headImg];
    headImg.image = [UIImage imageNamed:@"default_headz"];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 20)];
    [content addSubview:nameLab];
    if (self.model) {
        nameLab.text = self.model.nickname;
    }else{
        nameLab.text = self.model_re.f_nick_name;

    }
   
    nameLab.font = [UIFont systemFontOfSize:12];
    nameLab.textColor = kUIColorFromRGB(0xDBEBF9);
    
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(15, 65, 200, 20)];
    [content addSubview:tip];
    tip.text = @"发送添加好友申请";
    tip.font = [UIFont systemFontOfSize:10];
    tip.textColor = kUIColorFromRGB(0xDBEBF9);
    UIImageView *helloBg = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(tip.frame), self.width-30, 80)];
    [content addSubview:helloBg];
    helloBg.backgroundColor = kUIColorFromRGB(0x224271);
    helloBg.layer.borderColor = kUIColorFromRGB(0x387AB0).CGColor;
    helloBg.layer.borderWidth = 1;
    PINTextView *helloText = [[PINTextView alloc]initWithFrame:CGRectMake(10, 10, self.width-50, 60)];
    [helloBg addSubview:helloText];
    helloText.textColor = UIColor.whiteColor;
    helloText.backgroundColor = [UIColor clearColor];
    helloText.placeholder = @"请输入";
    helloText.text = [NSString stringWithFormat:@"我是%@",self.model?self.model.nickname:self.model_re.f_nick_name];
    
    if(self.status==0){
        UIButton *senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [content addSubview:senderBtn];
        [senderBtn setBackgroundImage:[UIImage imageNamed:@"button_bg2"] forState:UIControlStateNormal];
        senderBtn.frame = CGRectMake(self.width/2 - 80, content.height-80, 160, 40);
        [senderBtn setTitle:@"发送" forState:UIControlStateNormal];
        [senderBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        senderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [senderBtn addTarget:self action:@selector(senderClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if (self.status==1){
        UIButton *senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [content addSubview:senderBtn];
        [senderBtn setBackgroundImage:[UIImage imageNamed:@"button_bg2"] forState:UIControlStateNormal];
        senderBtn.frame = CGRectMake(self.width/2 - 80, content.height-80, 160, 40);
        [senderBtn setTitle:@"等待对方验证" forState:UIControlStateNormal];
        [senderBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        senderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
//        [senderBtn addTarget:self action:@selector(senderClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if (self.status==2){

        CGFloat per = (self.width-30-10)/2;
        UIButton *refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [content addSubview:refuseBtn];
        [refuseBtn setBackgroundImage:[UIImage imageNamed:@"button_bg2"] forState:UIControlStateNormal];
        refuseBtn.frame = CGRectMake(15, content.height-80,per, 40);
        [refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [refuseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        refuseBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [refuseBtn addTarget:self action:@selector(refuseClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [content addSubview:finishBtn];
        [finishBtn setBackgroundImage:[UIImage imageNamed:@"button_bg2"] forState:UIControlStateNormal];
        finishBtn.frame = CGRectMake(25+per, content.height-80, per, 40);
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [finishBtn addTarget:self action:@selector(FinishClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
   
    
}
-(void)refuseClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(detailFriendStatus:WithModelUUID:)]) {
        [self.delegate detailFriendStatus:NO WithModelUUID:self.model_re.fuuid];
    }
}
-(void)FinishClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(detailFriendStatus:WithModelUUID:)]) {
        [self.delegate detailFriendStatus:YES WithModelUUID:self.model_re.fuuid];
    }
}
-(void)btnClick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(detailFriendClickWith:withId:withStaus:)]) {
        [self.delegate detailFriendClickWith:0 withId:@"" withStaus:0];
    }
}
//发送好友请求
-(void)senderClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(detailFriendClickWith:withId:withStaus:)]) {
        [self.delegate detailFriendClickWith:1 withId:self.model.uuid withStaus:0];
    }
}
@end


@interface FriendRequstList()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *listTab;
@property(nonatomic,strong)RequstModel *requstModel;

@end
@implementation FriendRequstList


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[[NIMSDK sharedSDK] systemNotificationManager] markAllNotificationsAsRead];

        [self creatView];
    }
    return self;
}

-(void)creatView
{

    
    UIImageView *content = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    content.image = [UIImage imageNamed:@"friend_c_bg"];
    [self addSubview:content];
    content.userInteractionEnabled = YES;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [content addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(0, 0, 40, 40);
    [cancelBtn setImage:[UIImage imageNamed:@"back_12"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bgAddImg = [[UIImageView alloc]initWithFrame:CGRectMake(40,0, self.width-50, 40)];
    bgAddImg.image = [UIImage imageNamed:@"search_bg"];
    [content addSubview:bgAddImg];
    bgAddImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoAdd)];
    [bgAddImg addGestureRecognizer:gesture];
    
    
    UIImageView *seach_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 16, 16)];
    [bgAddImg addSubview:seach_icon];
    seach_icon.image = [UIImage imageNamed:@"seach_icon"];
    
    UILabel *placeLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 25)];
    placeLab.text = @"手机号/昵称";
    placeLab.font = [UIFont systemFontOfSize:12];
    placeLab.textColor = kUIColorFromRGB(0x8BA8D2);
    [bgAddImg addSubview:seach_icon];
    
    _listTab = [[UITableView alloc]initWithFrame:CGRectMake(0,30, self.width, content.height-40)];
    [content addSubview:_listTab];
    _listTab.delegate = self;
    _listTab.dataSource = self;
    _listTab.rowHeight = 60;
    _listTab.backgroundColor = [UIColor clearColor];
    [_listTab registerClass:[FriendRequestCell class] forCellReuseIdentifier:@"cell"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return _requstModel.tdayago.count;;
    }
    return _requstModel.tdayagoRecent.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendRequestCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RequstListModel *model;
    if (indexPath.section==1) {
        model = _requstModel.tdayago[indexPath.row];

    }else{
        model = _requstModel.tdayagoRecent[indexPath.row];
    }
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default_headz"]];
    cell.nickName.text = model.f_nick_name;
    if ([model.f_type intValue]==2) {
        cell.statusLab.text = @[@"好友申请",@"已同意",@"已拒绝"][[model.status intValue]-1];
        cell.statusImg.image = [UIImage imageNamed:@[@"status_2",@"status_3",@"status_5"][[model.status intValue]-1]];
        cell.timeLab.text = @"你好";
        if ([model.status intValue]==1) {
            cell.statusImg.hidden = YES;
            cell.statusLab.hidden = YES;
            cell.refuseBtn.hidden = NO;
            cell.agreeBtn.hidden = NO;
            if (indexPath.section==0) {
                [cell.agreeBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.agreeBtn.tag = 10+indexPath.row;
                [cell.refuseBtn addTarget:self action:@selector(refuseClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.refuseBtn.tag = 20+indexPath.row;
            }else{
                [cell.agreeBtn addTarget:self action:@selector(agreeClick1:) forControlEvents:UIControlEventTouchUpInside];
                cell.agreeBtn.tag = 10+indexPath.row;
                [cell.refuseBtn addTarget:self action:@selector(refuseClick1:) forControlEvents:UIControlEventTouchUpInside];
                cell.refuseBtn.tag = 20+indexPath.row;
            }
         
//            cell
        }else{
            cell.statusImg.hidden = NO;
            cell.statusLab.hidden = NO;
            cell.refuseBtn.hidden = YES;
            cell.agreeBtn.hidden = YES;
        }

    }else{
        cell.statusImg.hidden = NO;
        cell.statusLab.hidden = NO;
        cell.refuseBtn.hidden = YES;
        cell.agreeBtn.hidden = YES;
        cell.statusLab.text = @[@"等待验证",@"已同意",@"已拒绝"][[model.status intValue]-1];
        cell.statusImg.image = [UIImage imageNamed:@[@"status_1",@"status_3",@"status_5"][[model.status intValue]-1]];
        cell.timeLab.text = @"我：你好";
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequstListModel *model;
    if (indexPath.section==1) {
        model = _requstModel.tdayago[indexPath.row];

    }else{
        model = _requstModel.tdayagoRecent[indexPath.row];
    }
   
    if ([model.status intValue]==1) {
        if ([self.delegate respondsToSelector:@selector(didSelectRequstWithModel:)]) {
            [self.delegate didSelectRequstWithModel:model];
//            [self.delegate detailFriendClickWith:3 withId:model.fuuid withStaus:status];
        }
    }
   
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(0, 3, self.width-11, 20)];
    vv.backgroundColor = kUIColorFromRGB(0x1F436E);
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
    titLab.font = [UIFont systemFontOfSize:10];
    titLab.textColor = UIColor.whiteColor;
    titLab.text = @[@"近三天",@"三天前"][section];
    [vv addSubview:titLab];
    return vv;
}
//前往添加好友页面
-(void)gotoAdd
{
    if ([self.delegate respondsToSelector:@selector(detailFriendClickWith:withId:withStaus:)]) {
        [self.delegate detailFriendClickWith:2 withId:@"" withStaus:0];
    }
}
-(void)btnClick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(detailFriendClickWith:withId:withStaus:)]) {
        [self.delegate detailFriendClickWith:0 withId:@""withStaus:0];
    }
}
-(void)requstDataLoad:(RequstModel*)model;
{
    self.requstModel = model;
    [self.listTab reloadData];
}
-(void)agreeClick:(UIButton*)sender
{
    //10
   
   
     RequstListModel *model = _requstModel.tdayagoRecent[sender.tag-10];
     
     if ([self.delegate respondsToSelector:@selector(detailFriendStatus:WithModelUUID:)]) {
         [self.delegate detailFriendStatus:YES WithModelUUID:model.fuuid];
     }
 
}
-(void)refuseClick:(UIButton*)sender
{
    //20
  
    RequstListModel *model = _requstModel.tdayagoRecent[sender.tag-20];
    
    if ([self.delegate respondsToSelector:@selector(detailFriendStatus:WithModelUUID:)]) {
        [self.delegate detailFriendStatus:NO WithModelUUID:model.fuuid];
    }
}
-(void)agreeClick1:(UIButton*)sender
{
    //10
   
     RequstListModel *model = _requstModel.tdayago[sender.tag-10];
     
     if ([self.delegate respondsToSelector:@selector(detailFriendStatus:WithModelUUID:)]) {
         [self.delegate detailFriendStatus:YES WithModelUUID:model.fuuid];
     }
 
}
-(void)refuseClick1:(UIButton*)sender
{
    //20

    RequstListModel *model = _requstModel.tdayago[sender.tag-20];
    
    if ([self.delegate respondsToSelector:@selector(detailFriendStatus:WithModelUUID:)]) {
        [self.delegate detailFriendStatus:NO WithModelUUID:model.fuuid];
    }
}
@end
