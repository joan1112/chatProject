//
//  Tools.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/20.
//

#import "Tools.h"

@implementation Tools
+(NSString*)dicToString:(NSDictionary*)dic;
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
