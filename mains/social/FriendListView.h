//
//  FriendListView.h
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/9.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>

@class RequstModel,SearchResultModel,RequstListModel;
NS_ASSUME_NONNULL_BEGIN
@protocol FriendListViewDelegate <NSObject>
//0 applay 1 add
-(void)friendListClickWith:(NSInteger)tag withId:(NSString*)userId;

-(void)friendListCellClick:(NSString*)userid;

-(void)recentListClik:(NIMSession*)session;
@end
@interface FriendListView : UIView
@property(nonatomic,weak)id<FriendListViewDelegate> delegate;
-(void)creatView;
-(void)reloadDataWithArr:(NSArray*)arr;
-(void)friendRequestChanged;

@end

@protocol AddFriendViewDelegate <NSObject>
//0 applay 1 add
-(void)addFriendClickWith:(NSInteger)tag withId:(NSString*)userId;
-(void)searchText:(NSString*)key;
-(void)didSelectWithModel:(SearchResultModel*)model;
@end
@interface AddFriendView : UIView
@property(nonatomic,weak)id<AddFriendViewDelegate> delegate;

-(void)searchResultData:(NSArray*)data;
-(void)creatView;

@end

@protocol FriendDetailViewDelegate <NSObject>
//0 applay 1 add
-(void)detailFriendClickWith:(NSInteger)tag withId:(NSString*)userId withStaus:(NSInteger)status;

-(void)detailFriendStatus:(BOOL)isAgree WithModelUUID:(NSString*)UUID;
-(void)didSelectRequstWithModel:(RequstListModel*)model;

@end
@interface FriendDetail : UIView
@property(nonatomic,weak)id<FriendDetailViewDelegate> delegate;
@property(nonatomic,assign)NSInteger status;//0 发送 1.等待验证 2.好友申请 3 已同意 4 已过期
@property(nonatomic,strong)SearchResultModel *model;//
@property(nonatomic,strong)RequstListModel *model_re;//

-(void)creatView;

@end

//好友申请
@interface FriendRequstList : UIView
@property(nonatomic,weak)id<FriendDetailViewDelegate> delegate;

-(void)requstDataLoad:(RequstModel*)model;
@end
NS_ASSUME_NONNULL_END
