//
//  AddAddress.h
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddAddress : UIView
-(instancetype)initWithFrame:(CGRect)frame withInfo:(NSString*)info;
-(void)showPopView;
- (void)hidePopView;
@end

NS_ASSUME_NONNULL_END
