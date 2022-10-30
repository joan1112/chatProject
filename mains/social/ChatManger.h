//
//  ChatManger.h
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/12.
//

#import <Foundation/Foundation.h>
#import "NIMSessionConfigurateProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class ChatView;
@interface ChatManger : NSObject
- (void)setup:(ChatView *)vc;

@end

NS_ASSUME_NONNULL_END
