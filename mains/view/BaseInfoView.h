//
//  BaseInfoView.h
//  tides-mobile
//
//  Created by junqiang on 2022/4/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseInfoView : UIView
@property(nonatomic,copy)void(^logoutAction)(void);
@property(nonatomic,copy)void(^userInfoAction)(NSInteger tag);

-(void)creatInfoView;
-(void)creatSetingView;
-(void)creatAboutView;

-(void)reloadSubView;
@end

NS_ASSUME_NONNULL_END
