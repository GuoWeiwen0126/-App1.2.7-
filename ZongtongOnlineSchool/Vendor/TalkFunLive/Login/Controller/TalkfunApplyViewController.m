//
//  TalkfunApplyViewController.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/3/13.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import "TalkfunApplyViewController.h"

@interface TalkfunApplyViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TalkfunApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL * url = [NSURL URLWithString:@"http://www.talk-fun.com/static/mobile/mb_apply_try.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.delegate = self;
//    self.title = @"申请试看";
    self.navigationController.navigationBar.barTintColor = DARKBLUECOLOR;
//    self.navigationController.navigationBar.backgroundColor = DARKBLUECOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.navigationController.navigationBar.barTintColor = BLUECOLOR;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.webView.center.x, self.webView.center.y - 50);
    indicator.tag = 91;
    indicator.color = UIColorFromRGBHex(0x333333);
    [self.webView addSubview:indicator];
    [indicator startAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    UIActivityIndicatorView * indicator = (UIActivityIndicatorView *)[self.webView viewWithTag:91];
    [indicator stopAnimation];
    [indicator removeFromSuperview];
    indicator.tag = 91;
    indicator = nil;
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//}

@end
