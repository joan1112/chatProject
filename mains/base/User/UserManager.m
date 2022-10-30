//
//  UserManager.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/24.
//

#import "UserManager.h"
#define userID @"userId"
#define Token @"token"
#define UUID @"uuid"
#define nickName @"nickname"
#define Role @"role"
#define WLTOKEN @"wytoken"
#define HEADIMG @"headImg"

@implementation UserManager
static UserManager* usermager = nil;

+(UserManager *)shraeUserManager
{
    if (usermager==nil) {
        usermager = [[UserManager alloc]init];
    }
    return usermager;
}

-(id)init{
    self = [super init];
    if (self) {
        _user = [[UserModel alloc]init];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

        _user.userId = [ud objectForKey:userID];
        _user.token = [ud  objectForKey:Token];
        _user.uuid = [ud objectForKey:UUID];
        _user.nickname = [ud objectForKey:nickName];
        _user.role = [ud objectForKey:Role];
        _user.wlToken = [ud objectForKey:WLTOKEN];
        _user.headImg = [ud objectForKey:HEADIMG];

    }
    return self;
}

-(void)setUser:(UserModel *)user
{
    _user = user;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:user.userId?user.userId:@"" forKey:userID];
    [ud setObject:user.token forKey:Token];
    [ud setObject:user.uuid?user.uuid:@"" forKey:UUID];
    [ud setObject:user.nickname?user.nickname:@"" forKey:nickName];
    [ud setObject:user.role?user.role:@"" forKey:Role];
    [ud setObject:user.wlToken?user.wlToken:@"" forKey:WLTOKEN];
    [ud setObject:user.headImg?user.headImg:@"" forKey:HEADIMG];

    [ud synchronize];
}
-(void)logout
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    [ud removeObjectForKey:userID];
    [ud removeObjectForKey:Token];
    [ud removeObjectForKey:UUID];
    [ud removeObjectForKey:nickName];
    [ud removeObjectForKey:Role];
    [ud removeObjectForKey:WLTOKEN];
    [ud removeObjectForKey:HEADIMG];

    [ud synchronize];


}
@end
