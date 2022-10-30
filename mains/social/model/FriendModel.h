//
//  FriendModel.h
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/9.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface FriendModel : JSONModel
@property(nonatomic,strong)NSString *f_uuid;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *user_icon;
@property(nonatomic,assign)int online;
@property(nonatomic,strong)NSString *time;

@end
@protocol RequstListModel <NSObject>

@end
@interface RequstListModel : JSONModel
@property(nonatomic,strong)NSString *uuid;
@property(nonatomic,strong)NSString *fuuid;
@property(nonatomic,strong)NSString *f_nick_name;
@property(nonatomic,strong)NSString *f_type;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *created_time;
@property(nonatomic,strong)NSString *updated_time;

@end
@interface RequstModel : JSONModel
@property (nonatomic , strong) NSMutableArray <RequstListModel>* tdayago;
@property (nonatomic , strong) NSMutableArray <RequstListModel>* tdayagoRecent;

@end

@interface SearchResultModel : JSONModel
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *uuid;
@property(nonatomic,strong)NSString *user_icon;
@end

NS_ASSUME_NONNULL_END
