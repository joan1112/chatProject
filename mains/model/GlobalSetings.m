//
//  GlobalSetings.m
//  tides-mobile
//
//  Created by junqiang on 2022/4/25.
//

#import "GlobalSetings.h"
static GlobalSetings *_globalSet = NULL;
@interface GlobalSetings()

@end
@implementation GlobalSetings
+(instancetype)Share
{
    if (!_globalSet) {
        _globalSet = [[GlobalSetings alloc]init];
    }
    return _globalSet;
}

-(id)init
{
//    self.area = AgoraAreaCodeGLOB;
//    self.fps = AgoraVideoFrameRateFps30;
   
    
}

@end

@interface SetingItem : NSObject
@property(nonatomic,assign)int selected;
@property(nonatomic,strong)NSArray *options;

@end
@interface SetingItemOPtion : NSObject
//@property(nonatomic,assign)int idx;
//@property(nonatomic,strong)NSString *label;
//@property(nonatomic,assign)AgoraVideoFrameRate fps;

@end
