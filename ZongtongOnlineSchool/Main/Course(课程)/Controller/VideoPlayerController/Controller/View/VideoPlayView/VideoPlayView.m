//
//  VideoPlayView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/17.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "VideoPlayView.h"
#import "Tools.h"
#import <WebKit/WebKit.h>

@implementation VideoPlayView
{
    UIWebView *_webView;
}

- (id)initWithFrame:(CGRect)frame videoUrl:(NSString *)videoUrl isHtml:(BOOL)isHtml
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (isHtml)
        {
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            _webView.scrollView.scrollEnabled = NO;
            [self addSubview:_webView];
            //加载Html
            [self refreshVideoWithVideoUrl:videoUrl];
        }
    }
    
    return self;
}
//刷新视频URL
- (void)refreshVideoWithVideoUrl:(NSString *)videoUrl
{
    NSURL *url = [NSURL URLWithString:videoUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.f];
    [_webView loadRequest:request];
}

@end
