//
//  UserManager.h
//  tides-mobile
//
//  Created by junqiang on 2022/4/24.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject
@property(nonatomic,strong)UserModel *user;

+(UserManager *)shraeUserManager;

-(void)logout;
@end

NS_ASSUME_NONNULL_END
