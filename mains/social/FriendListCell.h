//
//  FriendListCell.h
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendListCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headImg;
@property(nonatomic,strong)UILabel *nickName;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UIButton *audioBtn;
@property(nonatomic,strong)UIButton *videoBtn;
@property(nonatomic,strong)UIButton *shareBtn;
@end

@interface SearchCell : UITableViewCell
@property(nonatomic,strong)UILabel *seachLab;
@end
@interface SearchResultCell : UITableViewCell
@property(nonatomic,strong)UIImageView *searchImg;
@property(nonatomic,strong)UILabel *seacrhTip ;
@property(nonatomic,strong)UILabel *tideNum;
@end
@interface FriendRequestCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headImg;
@property(nonatomic,strong)UILabel *nickName;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UIImageView *statusImg;
@property(nonatomic,strong)UILabel *statusLab;
@property(nonatomic,strong)UIButton *agreeBtn;
@property(nonatomic,strong)UIButton *refuseBtn;

@end
NS_ASSUME_NONNULL_END
