//
//  ChatManger.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/12.
//

#import "ChatManger.h"
#import "NIMSessionMsgDatasource.h"
#import "NIMSessionInteractorImpl.h"
#import "NIMCustomLeftBarView.h"
#import "UIView+NIM.h"
#import "NIMMessageModel.h"
#import "NIMGlobalMacro.h"
#import "NIMSessionInteractorImpl.h"
#import "NIMSessionDataSourceImpl.h"
#import "NIMSessionLayoutImpl.h"
#import "NIMSessionTableAdapter.h"
#import "ChatView.h"
@interface ChatManger()
@property (nonatomic,strong) NIMSessionInteractorImpl   *interactor;

@property (nonatomic,strong) NIMSessionTableAdapter     *tableAdapter;
@end
@implementation ChatManger
- (void)setup:(ChatView *)vc
{
    NIMSession *session    = vc.session;
    id<NIMSessionConfig> sessionConfig = vc.sessionConfig;
    UITableView *tableView  = vc.tableView;
    NIMInputView *inputView = vc.sessionInputView;
    
    NIMSessionDataSourceImpl *datasource = [[NIMSessionDataSourceImpl alloc] initWithSession:session config:sessionConfig];
    NIMSessionLayoutImpl *layout         = [[NIMSessionLayoutImpl alloc] initWithSession:session config:sessionConfig];
    layout.tableView = tableView;
    layout.inputView = inputView;
    
    
    _interactor                          = [[NIMSessionInteractorImpl alloc] initWithSession:session config:sessionConfig];
    _interactor.delegate                 = vc;
    _interactor.dataSource               = datasource;
    _interactor.layout                   = layout;
    
    [layout setDelegate:_interactor];
    
    _tableAdapter = [[NIMSessionTableAdapter alloc] init];
    _tableAdapter.interactor = _interactor;
    _tableAdapter.delegate   = vc;
    vc.tableView.delegate = _tableAdapter;
    vc.tableView.dataSource = _tableAdapter;
    
    
    [vc setInteractor:_interactor];
}
@end
