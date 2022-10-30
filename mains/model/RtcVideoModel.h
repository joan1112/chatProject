//
//  RtcVideoModel.h
//  tides-mobile
//
//  Created by junqiang on 2022/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RtcVideoModel : NSObject
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *volume;
@property(nonatomic,strong)NSString *pitch;

@end

NS_ASSUME_NONNULL_END
