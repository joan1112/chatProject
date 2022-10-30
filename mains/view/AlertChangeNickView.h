//
//  AlertChangeNickView.h
//  tides-mobile
//
//  Created by junqiang on 2022/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertChangeNickView : UIView
@property(nonatomic,copy)void(^verfySuccess)(NSString *name);

-(void)showPopView;
- (void)hidePopView;
@end

NS_ASSUME_NONNULL_END
