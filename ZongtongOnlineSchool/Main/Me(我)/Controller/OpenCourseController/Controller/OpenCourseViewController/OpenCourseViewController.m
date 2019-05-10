//
//  OpenCourseViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/7/4.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OpenCourseViewController.h"
#import "Tools.h"
#import "OpenCourseModel.h"
#import "CourseOptionModel.h"
#import "CourseOptionManager.h"
#import "OpenCourseTableView.h"
#import "OpenAppTypeTableView.h"
#import "VideoSectionViewController.h"
#import "SectionViewController.h"
#import "OpenCourseNextViewController.h"
#import "CourseViewController.h"

@interface OpenCourseViewController () <OpenCourseTableViewDelegate, OpenAppTypeTableViewDelegate>
{
    NSString *_eiidStr;
    NSMutableArray *_examArray;
    NSMutableArray *_appTypeArray;  //会员所有权限
    
    NSInteger _section;
    NSInteger _index;
    BOOL _isBack;
}
@property (nonatomic, strong) OpenCourseTableView *tableView;
@property (nonatomic, strong) OpenAppTypeTableView *appTypeTableView;
@property (nonatomic, strong) UIButton *bgButton;
@end

@implementation OpenCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"已开通课程" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    _eiidStr = [USER_DEFAULTS objectForKey:EIID];
    _examArray = [NSMutableArray arrayWithCapacity:10];
    _appTypeArray = [NSMutableArray arrayWithCapacity:10];
    
    //所有考试完整详情
    [CourseOptionManager CourseOptionDetailsExamInfoCompleted:^(id obj) {
        if (obj == nil) { return; }
        else
        {
            OpenOptionModel *openOptionModel = [OpenOptionModel yy_modelWithDictionary:obj];
            NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:10];
            for (OpenExamModel *examModel in openOptionModel.Data) {
                for (OpenCourseModel *openCourseModel in examModel.infoList) {
                    [cellArray addObject:openCourseModel];
                }
            }
            //会员所有权限
            [AppTypeManager appTypeManagerUserAllListWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
                if (obj != nil) {
                    for (NSDictionary *dic in (NSArray *)obj) {
                        UserAppModel *appModel = [UserAppModel yy_modelWithDictionary:dic];
                        [_appTypeArray addObject:appModel];
                    }
                    BOOL isHas = NO;
                    for (OpenCourseModel *openCourseModel in cellArray) {
                        for (UserAppModel *appModel in _appTypeArray) {
                            
                            if (openCourseModel.eiid == appModel.examid) {
                                isHas = YES;
                            }
                        }
                        if (isHas ==YES) {
                            [_examArray addObject:openCourseModel];
                        }
                        isHas = NO;
                    }
                    if (_examArray.count == 0) {
                        [XZCustomWaitingView showAutoHidePromptView:@"暂无开通课程" background:nil showTime:1.0];
                        return;
                    }
                    
                    //获取成功后创建列表
                    self.tableView = [[OpenCourseTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain dataArray:_examArray];
                    self.tableView.courseDelegate = self;
                    [self.view addSubview:self.tableView];
                    //注册通知
//                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OpenCourseHeaderViewTapped:) name:@"OpenCourseHeaderViewTapped" object:nil];
//                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OpenCourseListCellClicked:) name:@"OpenCourseListCellClicked" object:nil];
                }
            }];
        }
    }];
}
#pragma mark - 点击 CourseHeaderView
- (void)openCourseHeaderViewTappedWithCourseModel:(OpenCourseModel *)courseModel section:(NSInteger)section
{
    _section = section;
    [USER_DEFAULTS setObject:[NSString stringWithFormat:@"%ld",(long)courseModel.eiid] forKey:EIID];
    [USER_DEFAULTS synchronize];
    //科目列表
    [CourseOptionManager CourseOptionCourseListCompleted:^(id obj) {
        if (obj != nil) {
            [XZCustomWaitingView hideWaitingMaskView];
            courseModel.courseList = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dic in (NSArray *)obj) {
                OpenCourseListModel *listModel = [OpenCourseListModel yy_modelWithDictionary:dic];
                BOOL isHas = NO;
                for (UserAppModel *appModel in _appTypeArray) {
                    if (courseModel.eiid == appModel.examid && listModel.courseId == appModel.courseid) {
                        isHas = YES;
                    }
                }
                if (isHas == YES) {
                    [courseModel.courseList addObject:listModel];
                }
                isHas = NO;
            }
            for (int i = 0; i < _examArray.count; i++) {
                OpenCourseModel *temModel = _examArray[i];
                temModel.isSelected = @"0";
                if (temModel.eiid == courseModel.eiid) {
                    courseModel.isSelected = @"1";
                    [_examArray replaceObjectAtIndex:i withObject:courseModel];
                }
            }
            self.tableView.dataArray = _examArray;
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - 点击科目
- (void)openCourseTableViewCellClickedWithCourseModel:(OpenCourseModel *)courseModel listModel:(OpenCourseListModel *)listModel index:(NSInteger)index
{
    _index = index;
    NSMutableArray *userAppArray = [NSMutableArray arrayWithCapacity:10];
    for (UserAppModel *userAppModel in _appTypeArray) {
        if (userAppModel.examid == courseModel.eiid && userAppModel.courseid == listModel.courseId) {
            [userAppArray addObject:userAppModel];
        }
    }
    self.appTypeTableView = [[OpenAppTypeTableView alloc] initWithFrame:CGRectMake(0, userAppArray.count > 10 ? (self.bgButton.height - 10*44.0f):(self.bgButton.height - userAppArray.count*44.0f), UI_SCREEN_WIDTH, userAppArray.count > 10 ? (10*44.0f):(userAppArray.count*44.0f)) style:UITableViewStylePlain dataArray:userAppArray];
    self.appTypeTableView.appTypeDelegate = self;
    [self.bgButton addSubview:self.appTypeTableView];
    self.bgButton.hidden = NO;
}
#pragma mark - 点击已开通权限
- (void)openAppTypeTableViewCellClickedWithOpenAppTypeModel:(UserAppModel *)model
{
    //权限详情列表
    [AppTypeManager appTypeManagerAppConfigConfigListWithExamidList:[NSString stringWithFormat:@"%ld",(long)model.examid] completed:^(id obj) {
        if (obj != nil) {
            [XZCustomWaitingView hideWaitingMaskView];
            for (NSDictionary *dic in (NSArray *)obj) {
                OpenDetailModel *detailModel = [OpenDetailModel yy_modelWithDictionary:dic];
                if (detailModel.examid == model.examid && detailModel.appType == model.appType) {
                    NSLog(@"***%@***",detailModel.handleExplain);
                    _isBack = YES;
                    if (detailModel.showType == 1) {  //题库
                        if (detailModel.handleExplain.length == 0) {
                            OpenCourseNextViewController *openCourseNextVC = [[OpenCourseNextViewController alloc] init];
                            [self.navigationController pushViewController:openCourseNextVC animated:YES];
                        } else {
                            NSArray *temArray = [detailModel.handleExplain queryNameWithQIssueStr:[detailModel.handleExplain mutableCopy] fromStr:@"{" toStr:@"}"];
                            NSDictionary *temDic = [ManagerTools jsonToDictionaryWithJsonStr:temArray[0]];
                            NSLog(@"---%@---",temDic);
                            SectionViewController *secVC = [[SectionViewController alloc] init];
                            secVC.naviTitle = temDic[@"title"];
                            secVC.sid = temDic[@"sid"];
                            secVC.type = [temDic[@"type"] integerValue];
                            [self.navigationController pushViewController:secVC animated:YES];
                        }
                    } else {  //视频
                        if (detailModel.handleExplain.length == 0) {
                            CourseViewController *courseVC = [[CourseViewController alloc] init];
                            courseVC.isOpenCourse = YES;
                            [self.navigationController pushViewController:courseVC animated:YES];
                        } else {
                            NSRange range = [detailModel.handleExplain rangeOfString:@"vtid="];
                            NSString *temResult = [detailModel.handleExplain substringFromIndex:range.location];
                            NSString *result = [temResult componentsSeparatedByString:@"<"][0];
                            NSLog(@"***%@***",result);
                            VideoSectionViewController *videoSecVC = [[VideoSectionViewController alloc] init];
                            videoSecVC.naviTitle = model.typeName;
                            videoSecVC.courseId = [USER_DEFAULTS objectForKey:COURSEID];
                            videoSecVC.vtfid = [[result substringFromIndex:result.length - 1] integerValue];
                            [self.navigationController pushViewController:videoSecVC animated:YES];
                        }
                    }
                    break;
                }
            }
        }
    }];
}

- (void)bgButtonClicked
{
    [self.appTypeTableView removeFromSuperview];
    self.bgButton.hidden = YES;
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (_isBack == NO) {
        [USER_DEFAULTS setObject:_eiidStr forKey:EIID];
        [USER_DEFAULTS synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        OpenCourseModel *courseModel = _examArray[_section];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
        for (OpenCourseListModel *listModel in courseModel.courseList) {
            NSDictionary *temDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)listModel.courseId],@"courseId", listModel.title,@"title", nil];
            [array addObject:temDic];
        }
        NSFileManager *fileManager = FileDefaultManager;
        NSString *filePath = GetFileFullPath(CourseIdPlist);
        if (![fileManager fileExistsAtPath:filePath])
        {
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }
        
        //保存当前选中的 courseId
        NSDictionary *temDic = (NSDictionary *)array[_index];
        [USER_DEFAULTS setObject:temDic[@"courseId"] forKey:COURSEID];
        [USER_DEFAULTS setObject:temDic[@"title"] forKey:COURSEIDNAME];
        [USER_DEFAULTS synchronize];
        //以 eiid:array 字典形式保存（方便分科目的界面显示和科目调整）
        NSDictionary *dic = @{[USER_DEFAULTS objectForKey:EIID]:array};
        if ([dic writeToFile:filePath atomically:YES])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteAllViewAndReloadData" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [XZCustomWaitingView showAutoHidePromptView:@"保存失败" background:nil showTime:1.0f];
        }
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height)];
        _bgButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [_bgButton addTarget:self action:@selector(bgButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.hidden = YES;
        [self.view addSubview:_bgButton];
    }
    return _bgButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
