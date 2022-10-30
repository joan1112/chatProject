//
//  UserModel.h
//  tides-mobile
//
//  Created by junqiang on 2022/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *uuid;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *role;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *chatToken;
@property(nonatomic,strong)NSString *wlToken;
@property(nonatomic,strong)NSString *headImg;


@end

NS_ASSUME_NONNULL_END
