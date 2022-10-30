//
//  AlertConfirmView.h
//  AKATOK
//
//  Created by junqiang on 2022/3/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface AlertConfirmView : UIView
@property(nonatomic,strong)UIProgressView *progress;
@property(nonatomic,strong)UILabel *tipLab;
@property(nonatomic,strong)UILabel *tipLab1;

@property(nonatomic,copy)void(^verfySuccess)(void);
@property(nonatomic,copy)void(^cancelAction)(void);
//0 提示下载 1 下载进度条 2 下载完成提示
-(instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type;

-(void)showPopView;
- (void)hidePopView;
@end

NS_ASSUME_NONNULL_END
