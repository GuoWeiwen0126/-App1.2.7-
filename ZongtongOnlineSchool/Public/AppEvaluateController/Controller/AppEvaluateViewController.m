//
//  AppEvaluateViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "AppEvaluateViewController.h"
#import "Tools.h"
#import "AppEvalauteManager.h"
#import "AppEvaluateTableView.h"

@interface AppEvaluateViewController () <AppEvaluateTableViewDelegate>
{
    NSString *_optionScore;
    NSString *_option;
    NSString *_feedbackContent;
    NSString *_contact;
}
@end

@implementation AppEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"意见反馈" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"提交" bgColor:MAIN_RGB];
    
    AppEvaluateTableView *tableView = [[AppEvaluateTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
    tableView.tableViewDelegate = self;
    [self.view addSubview:tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateAppEvaluateFeedbackContent:) name:@"UpdateAppEvaluateFeedbackContent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateAppEvaluateContact:) name:@"UpdateAppEvaluateContact" object:nil];
}
#pragma mark ========= 点击选项 =========
- (void)updateAppEvaluateOptionWithScore:(NSString *)score option:(NSString *)option
{
    _optionScore = score;
    _option = option;
}
#pragma mark ========= 通知方法 =========
- (void)UpdateAppEvaluateFeedbackContent:(NSNotification *)noti
{
    _feedbackContent = (NSString *)noti.object;
}
- (void)UpdateAppEvaluateContact:(NSNotification *)noti
{
    _contact = (NSString *)noti.object;
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType {
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (btnType == RightBtnType) {
        [AppEvalauteManager appFeedbackWithVC:self appKey:@"1" appVer:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] sysType:@"1" uid:[USER_DEFAULTS objectForKey:User_uid] grade:_optionScore gradeTitle:_option content:_feedbackContent contact:_contact];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
