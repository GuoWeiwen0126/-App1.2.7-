//
//  CourseOptionFirstViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/5/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionFirstViewController.h"
#import "Tools.h"
#import "CourseOptionModel.h"
#import "CourseOptionManager.h"
#import "CourseOptionFirstTableView.h"
#import "CourseOptionNextViewController.h"

@interface CourseOptionFirstViewController ()
{
    NSInteger _temEiid;
    NSString *_temEiidName;
    NSArray  *_courseArray;
}
@end

@implementation CourseOptionFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _temEiid = [[USER_DEFAULTS objectForKey:EIID] integerValue];
    _temEiidName = [USER_DEFAULTS objectForKey:EIIDNAME];
    
    [self configNavigationBarWithNaviTitle:@"选择考试" naviFont:18.0 leftBtnTitle:@"back.png" rightBtnTitle:@"完成" bgColor:MAIN_RGB];
    
    //所有考试完整详情
    [CourseOptionManager CourseOptionDetailsExamInfoCompleted:^(id obj) {
        if (obj == nil) { return; }
        else
        {
            CourseOptionModel *courseOptionModel = [CourseOptionModel yy_modelWithDictionary:obj];
            for (int i = 0; i < courseOptionModel.Data.count; i ++)
            {
                for (int j = 0; j < courseOptionModel.Data[i].infoList.count; j ++)
                {
                    if (courseOptionModel.Data[i].infoList[j].eiid == [[USER_DEFAULTS objectForKey:EIID] integerValue])
                    {
                        courseOptionModel.Data[i].infoList[j].isSelected = @"1";
                    }
                }
            }
            //获取成功后创建列表
            CourseOptionFirstTableView *tableView = [[CourseOptionFirstTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain dataArray:(NSArray *)courseOptionModel.Data];
            [self.view addSubview:tableView];
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CourseOptionCollectionClicked:) name:@"CourseOptionCollectionClicked" object:nil];
        }
    }];
}

#pragma mark - 科目选择通知方法
- (void)CourseOptionCollectionClicked:(NSNotification *)noti
{
    CourseCellModel *cellModel = (CourseCellModel *)noti.object;
    [USER_DEFAULTS setObject:[NSString stringWithFormat:@"%ld",(long)cellModel.eiid] forKey:EIID];
    [USER_DEFAULTS setObject:[NSString stringWithFormat:@"%@",cellModel.title] forKey:EIIDNAME];
    [USER_DEFAULTS synchronize];
    if (cellModel.isCentCourse == 0)  //0:分科目  1:不分科目
    {
        CourseOptionNextViewController *nextVC = [[CourseOptionNextViewController alloc] init];
        nextVC.isUserCenter = self.isUserCenter;
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else
    {
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"科目已经选择\n是否保存？" cancelButtonTitle:@"取消" otherButtonTitle:@"保存" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            if (buttonIndex == XZAlertViewBtnTagSure) {
                [self saveCourseListInfo];
            }
        }];
    }
}

#pragma mark - 获取科目列表并保存
- (void)saveCourseListInfo
{
    [CourseOptionManager CourseOptionCourseListCompleted:^(id obj) {
         if (obj != nil) {
             _courseArray = (NSArray *)obj;
             //遍历保存 courseId
             [CourseOptionManager CourseOptionSaveCourseIdWithVC:self array:_courseArray isCentCourse:NO isUserCenter:self.isUserCenter];
         }
     }];
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType)
    {
        if (_temEiid != [[USER_DEFAULTS objectForKey:EIID] integerValue])
        {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"科目已经选择\n是否保存？" cancelButtonTitle:@"取消" otherButtonTitle:@"保存" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagCancel) {
                    [USER_DEFAULTS setObject:[NSString stringWithFormat:@"%ld",(long)_temEiid] forKey:EIID];
                    [USER_DEFAULTS setObject:_temEiidName forKey:EIIDNAME];
                    [USER_DEFAULTS synchronize];
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] removeObserver:self];
                }
                else {
                    [self saveCourseListInfo];
                }
            }];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
    }
    else
    {
        if ([[USER_DEFAULTS objectForKey:EIID] integerValue] == 0) {
            [XZCustomWaitingView showAutoHidePromptView:@"请您选择科目" background:nil showTime:1.0];
            return;
        }
        [self saveCourseListInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
