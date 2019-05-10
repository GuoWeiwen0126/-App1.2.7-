//
//  OpenCourseNextViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OpenCourseNextViewController.h"
#import "Tools.h"
#import "HomeManager.h"
#import "HomeModel.h"
#import "OpenCourseNextTableView.h"

#import "QuestionViewController.h"
#import "SectionViewController.h"
#import "MistakeCollectViewController.h"
#import "QHistoryViewController.h"

typedef NS_ENUM(NSUInteger, SectionType)
{
    KDZNLX = 1,
    ZJZNLX = 2,
    ZTLX   = 3,
    GGMK   = 4,
    GPSJ   = 5,
    JCQHLX = 6,
    MKDS   = 7,  //万人模考
    CTLX   = 8,
    SC     = 9,
    LXLS   = 10,
};

@interface OpenCourseNextViewController ()

@end

@implementation OpenCourseNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"已开通课程" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    [HomeManager homeManagerExerciseConfigWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] completed:^(id obj) {
        NSMutableArray *moduleArray = [NSMutableArray arrayWithCapacity:10];
        if (obj == nil) { return; }
        else {
            NSArray *array = (NSArray *)obj;
            for (NSDictionary *dic in array) {
                HomeModuleModel *moduleModel = [HomeModuleModel yy_modelWithJSON:dic];
                [moduleArray addObject:moduleModel];
            }
            
            OpenCourseNextTableView *tableView = [[OpenCourseNextTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
            tableView.dataArray = moduleArray;
            [self.view addSubview:tableView];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OpenCourseNextTableViewCellClicked:) name:@"OpenCourseNextTableViewCellClicked" object:nil];
        }
    }];
}
#pragma mark -
- (void)OpenCourseNextTableViewCellClicked:(NSNotification *)noti
{
    HomeModuleModel *moduleModel = (HomeModuleModel *)noti.object;
    switch (moduleModel.type)
    {
        case KDZNLX:
        {
            [USER_DEFAULTS setBool:NO forKey:Question_IsAnalyse];
            [USER_DEFAULTS synchronize];
            QuestionViewController *questionVC = [[QuestionViewController alloc] init];
            questionVC.naviTitle = moduleModel.title;
            questionVC.VCType = RandomListVCType;
            [self.navigationController pushViewController:questionVC animated:YES];
        }
            break;
        case ZJZNLX:case ZTLX:case MKDS:
        {
            SectionViewController *sectionVC = [[SectionViewController alloc] init];
            sectionVC.naviTitle = moduleModel.title;
            sectionVC.sid = moduleModel.para[@"sid"];
            sectionVC.type = moduleModel.type;
            [self.navigationController pushViewController:sectionVC animated:YES];
        }
            break;
        case CTLX: case SC:
        {
            if (IsLocalAccount) {
                [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"当前您为试用账号。试用账号无法保存您的做题记录和部分信息，请您登录后查看。" cancelButtonTitle:@"确定" otherButtonTitle:@"" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {}];
            } else {
                MistakeCollectViewController *mistakeCollectVC = [[MistakeCollectViewController alloc] init];
                mistakeCollectVC.mistakeCollectType = moduleModel.type == CTLX ? MistakeType:CollectType;
                [self.navigationController pushViewController:mistakeCollectVC animated:YES];
            }
        }
            break;
        case LXLS:
        {
            if (IsLocalAccount) {
                [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"当前您为试用账号。试用账号无法保存您的做题记录和部分信息，请您登录后查看。" cancelButtonTitle:@"确定" otherButtonTitle:@"" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {}];
            } else {
                QHistoryViewController *qHistoryVC = [[QHistoryViewController alloc] init];
                [self.navigationController pushViewController:qHistoryVC animated:YES];
            }
        }
            break;
        case JCQHLX:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
