//
//  VideoViewController.h
//  tides-mobile
//
//  Created by junqiang on 2022/4/24.
//

#import <UIKit/UIKit.h>
#import <NERtcCallKit/NERtcCallKit.h>
#import "social/model/NEUser.h"
#import "social/model/NECallStatusRecordModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NECallViewDelegate <NSObject>

/// 只在主叫方会有回调，被叫方请监听 IM 话单 NIMessage 的回调
- (void)didEndCallWithStatusModel:(NECallStatusRecordModel *)model;

@end

@interface VideoViewController : UIViewController
@property(assign,nonatomic)NERtcCallStatus status;
@property(strong,nonatomic)NEUser *remoteUser;
@property(strong,nonatomic)NEUser *localUser;
@property(assign,nonatomic)NERtcCallType callType;
@property (nonatomic, assign) int timerIndex;

@property(nonatomic, weak) id<NECallViewDelegate> delegate;

//主叫
@property(nonatomic, assign) BOOL isCaller;
-(void)reloadTimer:(int)index;
-(void)loadRemoteView;
@end

NS_ASSUME_NONNULL_END
