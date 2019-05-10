//
//  TestReportViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/20.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "TestReportViewController.h"
#import "Tools.h"
#import "TestReportTableView.h"
#import "QuestionModel.h"
#import "QuestionManager.h"
#import "QuestionViewController.h"

@interface TestReportViewController () <TestReportAnalyseViewDelegate>

@property (nonatomic, strong) AnalyseView *analyseView;

@end

@implementation TestReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [XZCustomWaitingView showWaitingMaskView:@"正在生成测试报告" iconName:LoadingImage iconNumber:4];
    
    [self createUIAndConfigArray];
    
    [XZCustomWaitingView hideWaitingMaskView];
}
- (void)createUIAndConfigArray
{
    [self configNavigationBarWithNaviTitle:@"测试报告" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.analyseView = [[AnalyseView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 50, UI_SCREEN_WIDTH, 50)];
    self.analyseView.analyseDelegate = self;
    [self.view addSubview:self.analyseView];
    
    NSMutableArray *detailArray = [QuestionManager QuestionManagerGetQCardArrayWithArray:self.dataArray];
    
    TestReportTableView *tableView = [[TestReportTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.analyseView.height) style:UITableViewStylePlain qExerinfoModel:self.qExerinfoModel dataArray:self.dataArray detailArray:detailArray submitTimeStr:self.submitTimeStr];
    [self.view addSubview:tableView];
}

#pragma mark - 查看解析代理方法
- (void)checkAnalyseWithAnalyseType:(TestReportAnalyseType)analyseType
{
    if (analyseType == CheckMistakeAnalyse && self.qExerinfoModel.mistakeNum == 0)
    {
        [XZCustomWaitingView showAutoHidePromptView:@"真棒\n您没有错题" background:nil showTime:0.8];
        return;
    }
    if (self.isHistory == NO) {
        if ([self.testReportDelegate respondsToSelector:@selector(testReportVCPopAndCheckAnalyseWithAnalyseArray:analyseType:)])
        {
            [self.navigationController popViewControllerAnimated:YES];
            [self.testReportDelegate testReportVCPopAndCheckAnalyseWithAnalyseArray:self.dataArray analyseType:analyseType];
        }
    } else {
        QuestionViewController *questionVC = [[QuestionViewController alloc] init];
        questionVC.naviTitle = self.qExerinfoModel.title;
        questionVC.dataArray = self.dataArray;
        questionVC.qExerinfoModel = self.qExerinfoModel;
        questionVC.nowQIndex = self.nowQIndex;
        questionVC.VCType = HistoryTestReportVCType;
        questionVC.analyseType = analyseType;
        [USER_DEFAULTS setBool:YES forKey:Question_IsAnalyse];
        [USER_DEFAULTS synchronize];
        [self.navigationController pushViewController:questionVC animated:YES];
    }
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (self.isHistory) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers indexOfObject:self]-2] animated:YES];
    }
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
