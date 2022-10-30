//
//  HangupView.h
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/10.
//

#import <UIKit/UIKit.h>
#import <NERtcCallKit/NERtcCallKit.h>
#import "model/NEUser.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HangupViewDelegate <NSObject>
-(void)hangupAction:(NSInteger)tag;
@end
@interface HangupView : UIView
@property(nonatomic,strong)UIImageView *head;
@property(nonatomic,assign)NERtcCallType type;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NEUser *remoteUsr;
@property(nonatomic,strong)NEUser *loacalUsr;

@property(nonatomic,weak)id<HangupViewDelegate>delegate;
-(void)creatView;
@end

NS_ASSUME_NONNULL_END
