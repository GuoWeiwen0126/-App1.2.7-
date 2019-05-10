//
//  HandoutViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HandoutViewController.h"
#import "Tools.h"
#import "VideoManager.h"
#import <WebKit/WebKit.h>

@interface HandoutViewController () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation HandoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:14.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.navigationBar.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) configuration:config];
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:self.wkWebView];
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Video/Handouts?examid=%@&vhid=1",HOST,[USER_DEFAULTS objectForKey:EIID]]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Video/Handouts?examid=%@&courseid=%@&vid=%ld",HOST,[USER_DEFAULTS objectForKey:EIID],[USER_DEFAULTS objectForKey:COURSEID],(long)self.vid]];
    NSLog(@"$$$$$$讲义URL：%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
    [self.wkWebView loadRequest:request];
}
#pragma mark - WKWebView代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [XZCustomWaitingView showWaitingMaskView:@"加载讲义" iconName:LoadingImage iconNumber:4];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [XZCustomWaitingView hideWaitingMaskView];
    NSLog(@"讲义加载成功");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [XZCustomWaitingView hideWaitingMaskView];
    [XZCustomWaitingView showAutoHidePromptView:@"讲义加载失败" background:nil showTime:1.0];
    NSLog(@"讲义加载失败!!!!!!!");
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    [self.wkWebView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
