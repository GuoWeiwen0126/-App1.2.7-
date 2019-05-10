//
//  TalkfunAboutViewController.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/26.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunAboutViewController.h"

@interface TalkfunAboutViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TalkfunAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4];
    [style setParagraphSpacing:15];
    NSMutableAttributedString * mutAttrStr = [[NSMutableAttributedString alloc] initWithString:@"广州欢拓网络科技有限公司一直致力于提供行业领先的互动直播SaaS云服务，在教育领域我们努力还原在线教学场景，实现真实的在线互动教学 。\n从2010年就开始专注于音/视频采样、编码、后处理以及适应国内复杂网络环境的智能高速网络传输协议的研究，并在2014年正式推出针对企业的云直播SaaS服务。\n一直以技术为核心，用户需求为导向，搭建专业技术直播平台，不断革新行业技术水平，引领真实互动通讯的发展。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:style}];
    self.textView.attributedText = mutAttrStr;
}

- (IBAction)backBtnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
