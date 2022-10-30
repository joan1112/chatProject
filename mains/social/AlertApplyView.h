//
//  AlertApplyView.h
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/18.
//

#import <UIKit/UIKit.h>
@class SearchResultModel;
NS_ASSUME_NONNULL_BEGIN
@protocol AlertApplyViewDeleagte <NSObject>

-(void)alertApllySender:(NSString*)userid;

@end
@interface AlertApplyView : UIView
@property(nonatomic,strong)SearchResultModel *model;//
@property(nonatomic,weak)id<AlertApplyViewDeleagte>delegate;
-(void)loadSubView;

-(void)showPopView;
- (void)hidePopView;
@end

NS_ASSUME_NONNULL_END
