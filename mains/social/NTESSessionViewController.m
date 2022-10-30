//
//  NTESSessionViewController.m
//  DemoApplication
//
//  Created by chris on 15/10/7.
//  Copyright © 2015年 chris. All rights reserved.
//

#import "NTESSessionViewController.h"
//#import "NTESSessionConfig.h"
//#import "NTESAttachment.h"

@interface NTESSessionViewController ()

//@property (nonatomic,strong) NTESSessionConfig *config;

@end

@implementation NTESSessionViewController

- (instancetype)initWithSession:(NIMSession *)session
{
    self = [super initWithSession:session];
    if (self) {
//        _config = [[NTESSessionConfig alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self topView];
}

- (NSString *)sessionTitle{
    return @"聊天";
}

//- (id<NIMSessionConfig>)sessionConfig{
//    return self.config;
//}

-(void)topView{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 20, 60, 60)];
    [self.view addSubview:back];
    back.backgroundColor = [UIColor grayColor];
    [back setTitle:@"back" forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:14];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    back.layer.cornerRadius = 30;
    back.layer.masksToBounds = YES;
    back.layer.zPosition = 20;
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Private
- (void)sendCustomMessage{
   
}

@end
