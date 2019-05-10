//
//  CourseViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "CourseViewController.h"
#import "Tools.h"
#import "StudyCourseView.h"
#import "CourseOptionManager.h"
#import "VideoManager.h"
#import "HomeManager.h"
#import "HomeModel.h"
#import "VideoTypeModel.h"
#import "CourseAdView.h"
#import "CourseTableView.h"
#import "VideoSectionViewController.h"
#import "VideoDownloadViewController.h"
#import "WebViewController.h"
#import "CourseOptionMainViewController.h"

@interface CourseViewController () <CourseTableViewDelegate, StudyCourseViewDelegate>
@property (nonatomic, strong) StudyCourseView *courseView;
@property (nonatomic, strong) UIButton *courseBgButton;
@property (nonatomic, strong) NSArray *courseIdArray;
@property (nonatomic, strong) CourseAdView *adView;
@property (nonatomic, strong) NSMutableArray *adArray;
@property (nonatomic, strong) CourseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *vTypeArray;
@end

@implementation CourseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    self.vTypeArray = [NSMutableArray arrayWithCapacity:10];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CourseAdverClicked:) name:@"CourseAdverClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CourseVCChangeCourse:) name:@"CourseVCChangeCourse" object:nil];
}
- (void)createUI
{
    [self configNavigationBarWithNaviTitle:[NSString stringWithFormat:@"%@ ▼",[USER_DEFAULTS objectForKey:COURSEIDNAME]] naviFont:16.0f leftBtnTitle:self.isOpenCourse ? @"back.png":@"" rightBtnTitle:@"videoxiazai.png" bgColor:MAIN_RGB];
    [self.navigationBar.titlebutton addTarget:self action:@selector(baseNaviButtonClickedWithBtnType:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)getData
{
    if (self.tableView) {
        //广告列表
        [HomeManager homeManagerAdInfoServeBasicListWithPlace:@"5" system:@"1" completed:^(id obj) {
            self.adArray = [NSMutableArray arrayWithCapacity:10];
            if (obj != nil) {
                NSArray *temArray = (NSArray *)obj;
                if (self.adView) {
                    if (temArray.count == 0) {
                        self.adView.frame = CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 0);
                        self.tableView.frame = CGRectMake(0, self.adView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.adView.height);
                    } else {
                        self.adView.frame = CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*3.0/8);
                        self.tableView.frame = CGRectMake(0, self.adView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.adView.height);
                        for (NSDictionary *adDic in temArray) {
                            AdInfoModel *adInfoModel = [AdInfoModel yy_modelWithDictionary:adDic];
                            [self.adArray addObject:adInfoModel];
                        }
                        [self.adView refreshWithAdArray:self.adArray];
                    }
                }
                [self getList];
            } else {
                self.adView.frame = CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 0);
                self.tableView.frame = CGRectMake(0, self.adView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.adView.height);
                [self getList];
            }
        }];
    }
}
- (void)getList
{
    //章节类别
    [VideoManager VideoManagerBasicListWithYear:@"0" courseid:[USER_DEFAULTS objectForKey:COURSEID] Completed:^(id obj) {
        if (obj != nil) {
            NSArray *dataArray = [NSArray arrayWithArray:(NSArray *)obj];
            if (dataArray.count == 0) {
                [XZCustomWaitingView showAutoHidePromptView:@"暂无课程" background:nil showTime:0.8];
            }
            NSInteger temYear = 0;
            NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:10];
            [self.vTypeArray removeAllObjects];
            for (int i = 0; i < dataArray.count; i ++) {
                NSDictionary *dic = dataArray[i];
                VideoTypeModel *videoTypeModel = [VideoTypeModel yy_modelWithDictionary:dic];
                if (i == 0) {
                    temYear = videoTypeModel.vtYear;
                }
                
                if (temYear == videoTypeModel.vtYear) {
                    [temArray addObject:videoTypeModel];
                } else {
                    temYear = videoTypeModel.vtYear;
                    [self.vTypeArray addObject:[temArray mutableCopy]];
                    [temArray removeAllObjects];
                    [temArray addObject:videoTypeModel];
                }
                
                if (i == dataArray.count - 1) {
                    [self.vTypeArray addObject:[temArray mutableCopy]];
                }
            }
            if (self.tableView) {
                self.tableView.dataArray = self.vTypeArray;
                [self.tableView reloadData];
            }
        }
    }];
}
#pragma mark - tableView 代理方法
- (void)courseTableViewCellClickedWithVTypeModel:(VideoTypeModel *)vTypeModel
{
    if (vTypeModel.isUsing != 0) {
        [XZCustomWaitingView showAutoHidePromptView:vTypeModel.errMsg background:nil showTime:1.0];
        return;
    }
    VideoSectionViewController *videoSectionVC = [[VideoSectionViewController alloc] init];
//    videoSectionVC.vTypeModel = vTypeModel;
    videoSectionVC.naviTitle = vTypeModel.vtTitle;
    videoSectionVC.courseId = [USER_DEFAULTS objectForKey:COURSEID];
    videoSectionVC.vtfid = vTypeModel.vtfid;
    [self.navigationController pushViewController:videoSectionVC animated:YES];
}
#pragma mark - 广告点击方法
- (void)CourseAdverClicked:(NSNotification *)noti
{
    AdInfoModel *adModel = (AdInfoModel *)noti.object;
    if ([adModel.operateType isEqualToString:@"link"]) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.naviTitle = adModel.title;
        webVC.webVCUrl = adModel.operateValue;
        [self.navigationController pushViewController:webVC animated:YES];
    } else if ([adModel.operateType isEqualToString:@"keywords"]) {
        if ([adModel.operateValue isEqualToString:@"contactus"]) {
            //联系客服
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:[USER_DEFAULTS objectForKey:ServiceQQ]]]]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:[USER_DEFAULTS objectForKey:ServiceQQ]]]]];
            } else {
                [XZCustomWaitingView showAutoHidePromptView:@"打开失败" background:nil showTime:1.2];
            }
        } else if ([adModel.operateValue isEqualToString:@"livevideolist"]) {
            self.tabBarController.selectedIndex = 2;
        }
    }
}
#pragma mark - 切换科目
- (void)CourseVCChangeCourse:(NSNotification *)noti
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

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType && self.isOpenCourse)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btnType == RightBtnType)
    {
        VideoDownloadViewController *videoDownloadVC = [[VideoDownloadViewController alloc] init];
        [self.navigationController pushViewController:videoDownloadVC animated:YES];
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
- (CourseAdView *)adView {
    if (!_adView) {
        _adView = [[CourseAdView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*3.0/8)];
        [self.view addSubview:_adView];
    }
    return _adView;
}
- (CourseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[CourseTableView alloc] initWithFrame:CGRectMake(0, self.adView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.adView.height) style:UITableViewStylePlain];
        _tableView.dataArray = _vTypeArray;
        _tableView.tableViewDelegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
