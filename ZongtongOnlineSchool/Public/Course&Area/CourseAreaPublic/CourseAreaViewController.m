//
//  CourseAreaViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/14.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "CourseAreaViewController.h"
#import "Tools.h"
#import "UserManager.h"
#import "AreaOptionViewController.h"
//#import "CourseOptionViewController.h"
//#import "CourseOptionFirstViewController.h"
#import "CourseOptionMainViewController.h"
#import "TabbarViewController.h"

@interface CourseAreaViewController () <AreaOptionVCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end

@implementation CourseAreaViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![USER_DEFAULTS objectForKey:COURSEID]) {
        self.courseLabel.text = @"请选择考试科目";
    } else {
        self.courseLabel.text = [USER_DEFAULTS objectForKey:COURSEIDNAME];
    }
    if (![USER_DEFAULTS objectForKey:User_province] || ![USER_DEFAULTS objectForKey:User_city]) {
        self.areaLabel.text = @"请选择报考地区";
    } else {
        self.areaLabel.text = [NSString stringWithFormat:@"%@  %@",[USER_DEFAULTS objectForKey:User_province],[USER_DEFAULTS objectForKey:User_city]];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBarWithNaviTitle:@"报考信息" naviFont:18.0 leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    //添加点击手势
    UITapGestureRecognizer *tapCourse = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(courseLabelTapped)];
    [self.courseLabel addGestureRecognizer:tapCourse];
    self.courseLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapArea = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaLabelTapped)];
    [self.areaLabel addGestureRecognizer:tapArea];
    self.areaLabel.userInteractionEnabled = YES;
}
#pragma mark - CourseLabel手势点击
- (void)courseLabelTapped
{
//    CourseOptionFirstViewController *courseOptionVC = [[CourseOptionFirstViewController alloc] init];
//    [self.navigationController pushViewController:courseOptionVC animated:YES];
    CourseOptionMainViewController *courseMainVC = [[CourseOptionMainViewController alloc] init];
    courseMainVC.isUserCenter = NO;
    [USER_DEFAULTS setObject:self.phoneStr forKey:User_phone];
    [USER_DEFAULTS setObject:self.passwordStr forKey:User_Password];
    [USER_DEFAULTS synchronize];
    [self.navigationController pushViewController:courseMainVC animated:YES];
}
#pragma mark - AreaLabel手势点击
- (void)areaLabelTapped
{
    AreaOptionViewController *areaVC = [[AreaOptionViewController alloc] init];
    areaVC.isExamArea = YES;
    areaVC.areaOptionDelegate = self;
    [self.navigationController pushViewController:areaVC animated:YES];
}
- (void)areaOptionPopWithProvinceStr:(NSString *)provinceStr cityStr:(NSString *)cityStr
{
    self.areaLabel.text = [NSString stringWithFormat:@"%@  %@",provinceStr,cityStr];
}
#pragma mark - 点击登录
- (IBAction)loginBtnClicked:(id)sender
{
    if (![USER_DEFAULTS objectForKey:COURSEID]) {
        [XZCustomWaitingView showAutoHidePromptView:@"请选择考试科目" background:nil showTime:1.0f];
        return;
    }
//    else if (![USER_DEFAULTS objectForKey:User_province] || ![USER_DEFAULTS objectForKey:User_city]) {
//        [XZCustomWaitingView showAutoHidePromptView:@"请选择报考地区" background:nil showTime:1.0f];
//        return;
//    }
    if (IsLocalAccount) {
        //清空window上残留的view
        [self.view.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //跳转到主界面并设置为根视图
        TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tabbarVC];
        tabbarVC.navigationController.navigationBar.hidden = YES;
        [UIApplication sharedApplication].delegate.window.rootViewController = navi;
        [XZCustomWaitingView showAutoHidePromptView:@"试用账号\n登录成功" background:nil showTime:1.0f];
    } else {
        [UserManager userLoginWithVC:self phone:self.phoneStr password:self.passwordStr isVerify:NO];
    }
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
