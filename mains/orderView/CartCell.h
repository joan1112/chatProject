//
//  CartCell.h
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CartDelegate <NSObject>
-(void)caculateClick;
-(void)goodSelect;


@end
@interface CartCell : UITableViewCell
@property(nonatomic,weak)id<CartDelegate> delegate;

-(void)loadDataWith:(NSIndexPath*)index;
@end

NS_ASSUME_NONNULL_END
