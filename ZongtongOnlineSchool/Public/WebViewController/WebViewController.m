//
//  WebViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/8.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "WebViewController.h"
#import "Tools.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    
    //声明WKScriptMessageHandler 协议
    [config.userContentController addScriptMessageHandler:self name:@"iOSGoToQQ"];  //注入JS对象（跳转QQ）
    [config.userContentController addScriptMessageHandler:self name:@"iOSBack"];  //注入JS对象（返回）
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.navigationBar.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) configuration:config];
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:self.wkWebView];
    
    NSURL *url = [NSURL URLWithString:self.webVCUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
    [self.wkWebView loadRequest:request];
    
    [XZCustomWaitingView showWaitingMaskView:@"正在加载" iconName:LoadingImage iconNumber:4];
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"iOSGoToQQ"])
    {
        NSLog(@"------%@",message.body);
        NSString *qqStr;
        if ([NSString stringWithFormat:@"%@",message.body].length != 0) {
            qqStr = message.body;
        } else {
            qqStr = [USER_DEFAULTS objectForKey:ServiceQQ];
        }
        //联系客服
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:qqStr]]]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:qqStr]]]];
        } else {
            [XZCustomWaitingView showAutoHidePromptView:@"打开失败" background:nil showTime:1.2];
        }
    }
    else if ([message.name isEqualToString:@"iOSBack"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - WKWebView代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [XZCustomWaitingView hideWaitingMaskView];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [XZCustomWaitingView hideWaitingMaskView];
    [XZCustomWaitingView showAutoHidePromptView:@"加载失败" background:nil showTime:1.0];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
