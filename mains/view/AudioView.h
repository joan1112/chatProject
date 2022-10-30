//
//  AudioView.h
//  tides-mobile
//
//  Created by junqiang on 2022/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioView : UIView
@property(nonatomic,strong)UIView *videoView;

@property(nonatomic,strong)UILabel *uidLab;
@property(nonatomic,strong)NSString *uid;

@end

NS_ASSUME_NONNULL_END
