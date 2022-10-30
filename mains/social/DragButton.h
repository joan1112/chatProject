//
//  DragButton.h
//  NERTC1to1Sample
//
//  Created by junqiang on 2022/5/7.
//  Copyright © 2022 丁文超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/NEUser.h"
#import "../VideoViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface DragButton : UIView
@property(nonatomic,strong,nullable)VideoViewController *presentVC;
@property(nonatomic,strong)UILabel *titleLabel;
@property(strong,nonatomic)NEUser *remoteUser;
@property(strong,nonatomic)NEUser *localUser;
//type 接听等待 音频 视频
+(void)loadViewWithVC:(VideoViewController*)VC WithType:(NSInteger)type withTimer:(int)timer withLocal:(NEUser*)user withRemote:(NEUser*)user1;
-(void)setAction:(NSString*)action;

-(void)setActionBlock:(void(^)(void))block; 
@end

NS_ASSUME_NONNULL_END
