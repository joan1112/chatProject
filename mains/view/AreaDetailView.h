//
//  AreaDetailView.h
//  tides-mobile
//
//  Created by junqiang on 2022/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AreaDetailView : UIView
@property(nonatomic,copy)void(^gogame)(void);

-(instancetype)initWithFrame:(CGRect)frame withCity:(NSString*)city;
-(void)showPopView;
- (void)hidePopView;
@end

NS_ASSUME_NONNULL_END
