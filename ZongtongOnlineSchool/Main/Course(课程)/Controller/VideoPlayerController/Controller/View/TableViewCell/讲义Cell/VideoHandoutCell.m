//
//  VideoHandoutCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/28.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "VideoHandoutCell.h"
#import "Tools.h"
#import <WebKit/WebKit.h>

@interface VideoHandoutCell () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation VideoHandoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];

    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - UI_SCREEN_WIDTH*9.0/16.0 - 50) configuration:config];
    self.wkWebView.navigationDelegate = self;
    [self addSubview:self.wkWebView];
}
#pragma mark - setter方法
- (void)setVhid:(NSString *)vhid
{
    if (_vhid != vhid)
    {
        _vhid = vhid;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Video/Handouts?examid=%@&vhid=%@",HOST,[USER_DEFAULTS objectForKey:EIID],vhid]];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Video/Handouts?examid=%@&vhid=1",HOST,[USER_DEFAULTS objectForKey:EIID]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
    [self.wkWebView loadRequest:request];
}
#pragma mark - WKWebView代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
//    [XZCustomWaitingView showWaitingMaskView:@"加载讲义" iconName:LoadingImage iconNumber:4];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    [XZCustomWaitingView hideWaitingMaskView];
    NSLog(@"讲义加载成功");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
//    [XZCustomWaitingView hideWaitingMaskView];
    [XZCustomWaitingView showAutoHidePromptView:@"讲义加载失败" background:nil showTime:0.8];
    NSLog(@"讲义加载失败!!!!!!!");
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
