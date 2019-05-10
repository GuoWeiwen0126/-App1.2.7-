//
//  QuestionFeedbackViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/18.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionFeedbackViewController.h"
#import "Tools.h"
#import "FeedbackBgView.h"
#import "HttpRequest+Feedback.h"

@interface QuestionFeedbackViewController ()
{
    NSArray *_titleArray;
    NSArray *_fTypeArray;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTV;
@property (nonatomic, strong) FeedbackBgView *feedbackBgView;

@end

@implementation QuestionFeedbackViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.feedbackBgView = [[FeedbackBgView alloc] initWithFrame:self.bgView.frame titleArray:_titleArray];
    [self.view addSubview:self.feedbackBgView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBarWithNaviTitle:@"问题反馈" naviFont:20.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    _titleArray = @[@"答案错误", @"解析错误", @"题目不严谨", @"选项错误", @"错别字或乱码", @"其他"];
    _fTypeArray = @[@"1", @"2", @"3", @"4", @"5", @"99"];
}
#pragma mark -
#pragma mark - 提交按钮
- (IBAction)submitBtnClicked:(id)sender
{
    if (self.feedbackBgView.fType == FType_NoChoose && self.feedbackTV.text.length == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请选择或输入反馈内容" background:nil showTime:1.0];
        return;
    }
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"正在提交" iconName:LoadingImage iconNumber:4];
    [HttpRequest FeedbackPostAddFeedbackWithCourseid:[USER_DEFAULTS objectForKey:COURSEID]
                                                 sid:[NSString stringWithFormat:@"%ld",(long)self.sid]
                                                 qid:[NSString stringWithFormat:@"%ld",(long)self.qid]
                                                 uid:[USER_DEFAULTS objectForKey:User_uid]
                                               fType:[NSString stringWithFormat:@"%ld",(long)self.feedbackBgView.fType]
                                             content:self.feedbackTV.text
                                           completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic)) { NSLog(@"提交成功"); } else { NSLog(@"提交失败"); }
        [XZCustomWaitingView hideWaitingMaskView];
        [XZCustomWaitingView showAutoHidePromptView:@"感谢您的反馈\n我们将尽快处理" background:nil showTime:1.0];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
