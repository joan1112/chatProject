//
//  RootViewController.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "RootViewController.h"
//在这里初始化长链接 监听代理 音视频来电
//创建管理类 初始化一次

@interface RootViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView* emptyDataView;

@end

@implementation RootViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return _StatusBarStyle;
}
//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle=StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    //是否显示返回按钮
    self.isShowLeftBack = YES;
    //默认导航栏样式：黑字
    //    self.StatusBarStyle = UIStatusBarStyleLightContent;
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
       self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}


/**
 *  是否显示返回按钮
 */
- (void) setIsShowLeftBack:(BOOL)isShowLeftBack
{
    _isShowLeftBack = isShowLeftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLeftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
//        [self loadBackBtn];
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}
-(void)loadBackBtn
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 22, 22);
    [leftButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}
- (void)backBtnClicked
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}



//取消请求
- (void)cancelRequest
{
    
}

- (void)dealloc
{
    [self cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.DisableSidePop) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark -  屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    return   UIInterfaceOrientationPortrait;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reloadNetworkDataSource:(id)sender
{
    if ([self respondsToSelector:@selector(reloadRequest)]) {
        [self performSelector:@selector(reloadRequest)];
    }
}
-(void)refreshNetworkDataSource:(id)sender{
    if ([self respondsToSelector:@selector(reloadRequest)]) {
        [self performSelector:@selector(reloadRequest)];
    }
}
- (void)reloadRequest
{
  
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)downLoadGift:(NSArray*)dataArr{
    for ( NSDictionary *dic in dataArr) {
        
        NSString *uStr = [dic objectForKey:@"swf"];
        if (uStr.length==0) {
            continue;
        }
        
        NSString *fileStr = [uStr substringWithRange:NSMakeRange(uStr.length-16, 16)];
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileStr];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL result = [fileManager fileExistsAtPath:filePath];
        
        if(!result){
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
            NSURL *url = [NSURL URLWithString:[dic objectForKey:@"swf"]];
            NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    NSLog(@"gif download error:%@", error);
                } else {
                    NSLog(@"gif download success, file path:%@",location.path);
                    //图片下载已完成，处理数据
                    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileStr];
                    
                    //4.2 剪切文件到指定位置
                    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
                    
                    NSLog(@"1---%@",location);
                    NSLog(@"2---%@",fullPath);
                    NSLog(@"3---%@",response.suggestedFilename);
                    NSLog(@"4---%@",url.lastPathComponent);
                    
                }
            }];
            [task resume];
        }
        
    }
}
- (void)setDisableSidePop:(BOOL)DisableSidePop{
    _DisableSidePop = DisableSidePop;
    if (DisableSidePop) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {

            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }else{
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {

            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return !self.DisableSidePop;
}

@end
