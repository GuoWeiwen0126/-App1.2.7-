//
//  LiveViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveViewController.h"
#import "Tools.h"
#import "StudyCourseView.h"
#import "CourseOptionManager.h"
#import "LiveModel.h"
#import "LiveManager.h"
#import "LiveTableView.h"
#import "LiveTopView.h"
#import "LiveCourseListViewController.h"
#import "LiveDownloadViewController.h"
#import "CourseOptionMainViewController.h"

@interface LiveViewController () <StudyCourseViewDelegate>
@property (nonatomic, strong) StudyCourseView *courseView;
@property (nonatomic, strong) UIButton *courseBgButton;
@property (nonatomic, strong) NSArray *courseIdArray;
@property (nonatomic, strong) LiveTopView *liveTopView;
@property (nonatomic, strong) LiveTableView *liveTableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation LiveViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LiveClassAllListOnLineClicked:) name:@"LiveClassAllListOnLineClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LiveVCChangeCourse:) name:@"LiveVCChangeCourse" object:nil];
}
- (void)createUI
{
    [self configNavigationBarWithNaviTitle:[NSString stringWithFormat:@"%@ ▼",[USER_DEFAULTS objectForKey:COURSEIDNAME]] naviFont:16.0f leftBtnTitle:@"" rightBtnTitle:@"videoxiazai.png" bgColor:MAIN_RGB];
    [self.navigationBar.titlebutton addTarget:self action:@selector(baseNaviButtonClickedWithBtnType:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)getData
{
    //获取下条直播
    [LiveManager liveManagerNextBasicInfoWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] ltid:@"0" ltfid:@"0" Completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            if (dic.count > 0) {
                LiveBasicListModel *basicModel = [LiveBasicListModel yy_modelWithDictionary:dic];
                if ([ManagerTools timestampJudgeWithStarttime:basicModel.lvStart endTime:basicModel.lvEnd] == 0) {
                    if (self.liveTopView) {
                        self.liveTopView.frame = CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 60);
                        self.liveTopView.liveBasicModel = basicModel;
                    }
                }
            }
            
            //科目下所有班级
            [LiveManager liveManagerClassAllListWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] Completed:^(id obj) {
                if (obj != nil) {
                    NSArray *array = (NSArray *)obj;
                    [self.listArray removeAllObjects];
                    if (array.count == 0) {
                        [XZCustomWaitingView showAutoHidePromptView:@"暂无直播课程" background:nil showTime:0.8];
                        self.liveTableView.dataArray = self.listArray;
                        [self.liveTableView reloadData];
                        return;
                    }
                    for (NSDictionary *dic in array) {
                        LiveClassListModel *listModel = [LiveClassListModel yy_modelWithJSON:dic];
                        [self.listArray addObject:listModel];
                    }
                    if (self.liveTableView) {
                        self.liveTableView.dataArray = self.listArray;
                        [self.liveTableView reloadData];
                    }
                }
            }];
        }
    }];
}
#pragma mark ========= 通知方法 =========
- (void)LiveClassAllListOnLineClicked:(NSNotification *)noti {
    LiveClassListModel *listModel = (LiveClassListModel *)noti.object;
    LiveCourseListViewController *liveCourseVC = [[LiveCourseListViewController alloc] init];
    liveCourseVC.naviTitle = listModel.ltTitle;
    liveCourseVC.ltid = listModel.ltid;
    [self.navigationController pushViewController:liveCourseVC animated:YES];
}

#pragma mark - 切换科目
- (void)LiveVCChangeCourse:(NSNotification *)noti
{
    [self courseBgButtonClicked];
    
    self.courseIdArray = nil;
    self.courseBgButton = nil;
    self.courseView = nil;
    [self createUI];
    [self getData];
}
#pragma mark - StudyCourseView代理方法
- (void)StudyCourseViewCourseButtonClicked
{
    CourseOptionMainViewController *courseMainVC = [[CourseOptionMainViewController alloc] init];
    courseMainVC.isUserCenter = NO;
    [self.navigationController pushViewController:courseMainVC animated:YES];
}
- (void)courseBgButtonClicked
{
    self.courseBgButton.hidden = YES;
    [UIView animateWithDuration:0.25f animations:^{
        self.courseView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 0);
        self.courseView.isOpen = NO;
    }];
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType {
    if (btnType == LeftBtnType)
    {
        
    }
    else if (btnType == RightBtnType)
    {
        LiveDownloadViewController *liveDownloadVC = [[LiveDownloadViewController alloc] init];
        [self.navigationController pushViewController:liveDownloadVC animated:YES];
    }
    else  //点击导航标题
    {
        self.courseView.isOpen = !self.courseView.isOpen;
        self.courseBgButton.hidden = self.courseView.isOpen == YES ? NO:YES;
        [UIView animateWithDuration:0.25f animations:^{
            self.courseView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, self.courseView.isOpen == NO ? 0:((self.courseIdArray.count > 6 ? 6:self.courseIdArray.count)*44 + 44));
        }];
    }
}
- (NSArray *)courseIdArray {
    if (!_courseIdArray) {
        _courseIdArray = [CourseOptionManager getLocalPlistFileArrayWithTemEiid:[[USER_DEFAULTS objectForKey:EIID] integerValue]];
    }
    return _courseIdArray;
}
- (UIButton *)courseBgButton {
    if (!_courseBgButton) {
        _courseBgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)];
        _courseBgButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.15];
        [_courseBgButton addTarget:self action:@selector(courseBgButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _courseBgButton.hidden = YES;
        [self.view addSubview:_courseBgButton];
    }
    return _courseBgButton;
}
- (StudyCourseView *)courseView {
    if (!_courseView) {
        _courseView = [[StudyCourseView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0) courseIdArray:self.courseIdArray];
        _courseView.isOpen = NO;
        _courseView.courseViewDelegate = self;
        [self.courseBgButton addSubview:_courseView];
    }
    return _courseView;
}
- (LiveTopView *)liveTopView {
    if (!_liveTopView) {
        _liveTopView = [[LiveTopView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 0)];
        [self.view addSubview:_liveTopView];
    }
    return _liveTopView;
}
- (LiveTableView *)liveTableView {
    if (!_liveTableView) {
        _liveTableView = [[LiveTableView alloc] initWithFrame:CGRectMake(0, self.liveTopView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.liveTopView.height) style:UITableViewStyleGrouped];
        _liveTableView.liveType = Live_OnLine;
        [self.view addSubview:_liveTableView];
    }
    return _liveTableView;
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _listArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
