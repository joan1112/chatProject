//
//  ProtolViewController.m
//  TIDE-mobile
//
//  Created by junqiang on 2022/5/27.
//

#import "ProtolViewController.h"
#import <WebKit/WebKit.h>
#import "base/CommonMacros.h"
@interface ProtolViewController ()<WKNavigationDelegate>

@end

@implementation ProtolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私条款";
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
    WKWebView *web = [[WKWebView alloc]initWithFrame:self.view.frame configuration:config];
    web.navigationDelegate = self;
    web.allowsBackForwardNavigationGestures = YES;
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://tide01.oss-cn-shanghai.aliyuncs.com/%E9%9A%90%E7%A7%81%E6%94%BF%E7%AD%96.pdf"]]];
    
    [self.view addSubview:web];
    [self backBtn];

}
-(void)backBtn
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:back];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:12];
    back.backgroundColor = UIColor.grayColor;
    back.frame = CGRectMake(KScreenWidth-80, 20, 50, 50);
    back.layer.cornerRadius = 25;
    back.layer.masksToBounds = YES;
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
 
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
