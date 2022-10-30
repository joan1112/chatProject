//
//  FriendDataManager.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/9.
//

#import "FriendDataManager.h"
#import "../base/BaseNetWork/HFNetWorkTool.h"
#import "../base/ConstMacros.h"
#import "../base/CommonMacros.h"
#import "../base/User/UserManager.h"
#import "model/FriendModel.h"
static FriendDataManager *_m = NULL;

@implementation FriendDataManager

+(FriendDataManager*)manager
{
    if (_m) {
        _m = [[FriendDataManager alloc]init];
    }
    return _m;
}
-(NSArray*)requestFriendList;
{
    [HFNetWorkTool POST:friendList parameters:@{} currentViewController:nil success:^(id responseObject) {
        NSLog(@"res===%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
            NSArray *data = responseObject[@"data"];
            NSArray *models = [FriendModel arrayOfModelsFromDictionaries:data error:nil];
         
        }
        
       
        } failure:^(NSError *error) {
            
        }];
   
}
@end
