//
//  FriendModel.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/9.
//

#import "FriendModel.h"

@implementation FriendModel

@end


@implementation RequstListModel


@end

@implementation RequstModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"tdayago" : @"3dayago",
                                                                  @"tdayagoRecent" :@"3daysrecent"
                                                                  }];
}

@end

@implementation SearchResultModel



@end
