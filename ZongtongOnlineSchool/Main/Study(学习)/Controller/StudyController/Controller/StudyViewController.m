//
//  StudyViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "StudyViewController.h"
#import "Tools.h"
#import "HomeModel.h"
#import "HomeManager.h"
#import "UserManager.h"
#import "SectionManager.h"
#import "CourseOptionManager.h"
#import "StudyTableView.h"
#import "NewStudyTableView.h"
#import "QuestionViewController.h"
#import "SectionViewController.h"
#import "StudyCourseView.h"
//#import "CourseOptionViewController.h"
#import "CourseOptionFirstViewController.h"
#import "CourseOptionMainViewController.h"
#import "MistakeCollectViewController.h"
#import "QHistoryViewController.h"
#import "VideoManager.h"
#import "VideoSectionModel.h"
#import "VideoDetailModel.h"
#import "ALiVideoPlayViewController.h"
#import "HandoutViewController.h"
#import "WebViewController.h"
#import "AppEvaluateViewController.h"
#import "DataDownloadViewController.h"
#import "CourseViewController.h"
#import "SectionTypeViewController.h"
#import "MKSignUpViewController.h"
#import <StoreKit/StoreKit.h>

@interface StudyViewController () <StudyCourseViewDelegate,SDCycleScrollViewDelegate,OptionButtonViewDelegate>

@property (nonatomic, strong) StudyTableView *studyTableView;
@property (nonatomic, strong) UIButton *courseBgButton;
@property (nonatomic, strong) StudyCourseView *courseView;
@property (nonatomic, strong) NSArray *courseIdArray;
@property (nonatomic, strong) NSMutableArray *videoCourseArray;

@property (nonatomic, strong) NewStudyTableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *adArray;
@property (nonatomic, strong) OptionButtonView *optionView;

@end

@implementation StudyViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self userVerifyToken];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    [self appUpdateInfo];
    [self getMainConfig];
    [self registerNotification];
    // 进入首页事件,统计用户进入首页的次数
    [MTA trackCustomKeyValueEvent:@"HomePage" props:nil];
}
#pragma mark - 创建UI
- (void)createUI
{
    //导航
    [self configNavigationBarWithNaviTitle:[NSString stringWithFormat:@"%@ ▼",[USER_DEFAULTS objectForKey:COURSEIDNAME]] naviFont:16.0f leftBtnTitle:@"dianzan.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    [self.navigationBar.titlebutton addTarget:self action:@selector(baseNaviButtonClickedWithBtnType:) forControlEvents:UIControlEventTouchUpInside];
    //获取保存题分类
    [SectionManager sectionManagerQtypeBasicListWithCompleted:^(id obj_Qtype) {
        if (obj_Qtype != nil) {
            //本地存储 题分类 信息
            [SectionManager saveQtypeListInfoWithArray:(NSArray *)obj_Qtype];
        }
        [XZCustomWaitingView showAdaptiveWaitingMaskView:@"正在获取信息" iconName:LoadingImage iconNumber:4];
        //完整缓存列表
        [HomeManager homeManagerBufferVerVerinfoCompleted:^(id obj) {
            //首页做题配置
            [HomeManager homeManagerExerciseConfigWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] completed:^(id obj) {
                NSMutableArray *moduleArray = [NSMutableArray arrayWithCapacity:10];
                if (obj == nil) { return; }
                else {
                    NSArray *array = (NSArray *)obj;
                    for (NSDictionary *dic in array) {
                        HomeModuleModel *moduleModel = [HomeModuleModel yy_modelWithJSON:dic];
                        moduleModel.imgUrl = [ManagerTools deleteSpaceAndNewLineWithString:moduleModel.imgUrl];
                        [moduleArray addObject:moduleModel];
                    }
                }
                //广告列表
                [HomeManager homeManagerAdInfoServeBasicListWithPlace:@"4" system:@"1" completed:^(id obj) {
                    self.adArray = [NSMutableArray arrayWithCapacity:10];
                    if (obj != nil) {
                        for (NSDictionary *adDic in (NSArray *)obj) {
                            AdInfoModel *adInfoModel = [AdInfoModel yy_modelWithDictionary:adDic];
                            [self.adArray addObject:adInfoModel];
                        }
                        if (self.adArray.count > 0) {
                            AdInfoModel *firstAdModel = self.adArray[0];
                            if (firstAdModel.compelShow == 1) {
                                [self showCompelAdverAlertWithAdModel:firstAdModel];
                            }
                        }
                    }
                    //获取会员权限列表
                    [AppTypeManager appTypeManagerUserAppListWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
                        //首页经典资料菜单配置
                        [HomeManager homeManagerDataDownloadConfigWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] completed:^(id obj) {
                            NSMutableArray *vipArray = [NSMutableArray arrayWithCapacity:10];
                            if (obj == nil) { return; }
                            else {
                                NSArray *array = (NSArray *)obj;
                                for (NSDictionary *dic in array) {
                                    HomeModuleModel *moduleModel = [HomeModuleModel yy_modelWithJSON:dic];
                                    moduleModel.imgUrl = [ManagerTools deleteSpaceAndNewLineWithString:moduleModel.imgUrl];
                                    [vipArray addObject:moduleModel];
                                }
                            }
                            
                            //UI
                            self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, self.navigationBar.bottom + 15, UI_SCREEN_WIDTH - 15*2, (UI_SCREEN_WIDTH - 15*2)*5/9) delegate:self placeholderImage:nil];
                            self.cycleScrollView.backgroundColor = [UIColor clearColor];
                            self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
                            self.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                            self.cycleScrollView.autoScrollTimeInterval = 2;
                            [self.view addSubview:self.cycleScrollView];
                            NSMutableArray *adImgArray = [NSMutableArray arrayWithCapacity:10];
                            for (AdInfoModel *adModel in self.adArray) {
                                [adImgArray addObject:adModel.imgUrl];
                            }
                            self.cycleScrollView.imageURLStringsGroup = adImgArray;
                            
                            self.optionView = [[OptionButtonView alloc] initWithFrame:CGRectMake(0, self.cycleScrollView.bottom + 10, UI_SCREEN_WIDTH, 50) optionArray:@[@"智能题库", @"VIP学员专享"] selectedColor:MAIN_RGB lineSpace:10 haveLineView:YES selectIndex:0];
                            self.optionView.optionViewDelegate = self;
                            [self.view addSubview:self.optionView];
                            
                            self.tableView = [[NewStudyTableView alloc] initWithFrame:CGRectMake(0, self.optionView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.cycleScrollView.height - self.optionView.height - TABBAR_HEIGHT - 15*2) style:UITableViewStylePlain];
                            self.tableView.mainType = QuestionType;
                            self.tableView.moduleArray = moduleArray;
                            self.tableView.vipArray = vipArray;
                            [self.view addSubview:self.tableView];
                            [self.view bringSubviewToFront:self.courseBgButton];
                            [XZCustomWaitingView hideWaitingMaskView];
                        }];
                    }];
                }];
            }];
        }];
    }];
}
#pragma mark - optionButtonView 代理方法
- (void)optionViewButtonClickedWithBtnTag:(NSInteger)btnTag {
    self.tableView.mainType = btnTag;
    [self.tableView reloadData];
}
#pragma mark - 注册通知
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StudyVCChangeCourse:) name:@"StudyVCChangeCourse" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StudyCollectionViewCellClicked:) name:@"StudyCollectionViewCellClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StudyCourseBtnClicked:) name:@"StudyCourseBtnClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StudyHandoutBtnClicked:) name:@"StudyHandoutBtnClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainAdverClicked:) name:@"MainAdverClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeleteAllViewAndReloadData) name:@"DeleteAllViewAndReloadData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BookBtnClicked:) name:@"BookBtnClicked" object:nil];
}
#pragma mark - 通知方法
#pragma mark - 广告点击
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    AdInfoModel *adModel = self.adArray[index];
    if ([adModel.operateType isEqualToString:@"link"]) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.naviTitle = adModel.title;
        webVC.webVCUrl = adModel.operateValue;
        [self.navigationController pushViewController:webVC animated:YES];
    } else if ([adModel.operateType isEqualToString:@"keywords"]) {
        if ([adModel.operateValue containsString:@"contactus"]) {
            NSString *qqStr;
            if ([adModel.operateValue containsString:@"_"]) {
                qqStr = [adModel.operateValue substringFromIndex:10];
            } else {
                qqStr = [USER_DEFAULTS objectForKey:ServiceQQ];
            }
            //联系客服
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:qqStr]]]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:qqStr]]]];
            } else {
                [XZCustomWaitingView showAutoHidePromptView:@"打开失败" background:nil showTime:1.2];
            }
        } else if ([adModel.operateValue isEqualToString:@"livevideolist"]) {
            self.tabBarController.selectedIndex = 2;
        } else if ([adModel.operateValue isEqualToString:@"gotowanrenmokao"]) {
            MKSignUpViewController *mkSignupVC = [[MKSignUpViewController alloc] init];
            [self.navigationController pushViewController:mkSignupVC animated:YES];
        }
    }
}
#pragma mark - 模块点击
- (void)StudyCollectionViewCellClicked:(NSNotification *)noti
{
    HomeModuleModel *moduleModel = noti.object;
    switch (moduleModel.type)
    {
        case KDZNLX:case SJCT:
        {
            [USER_DEFAULTS setBool:NO forKey:Question_IsAnalyse];
            [USER_DEFAULTS synchronize];
            QuestionViewController *questionVC = [[QuestionViewController alloc] init];
            questionVC.naviTitle = moduleModel.title;
            questionVC.VCType = RandomListVCType;
            [self.navigationController pushViewController:questionVC animated:YES];
        }
            break;
        case ZJZNLX:case ZTLX:
        {
            SectionViewController *sectionVC = [[SectionViewController alloc] init];
            sectionVC.naviTitle = moduleModel.title;
            sectionVC.sid = moduleModel.para[@"sid"];
            sectionVC.type = moduleModel.type;
            [self.navigationController pushViewController:sectionVC animated:YES];
        }
            break;
        case MKDS:
        {
            MKSignUpViewController *mkSignupVC = [[MKSignUpViewController alloc] init];
            [self.navigationController pushViewController:mkSignupVC animated:YES];
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
        case JTK:
        {
            SectionTypeViewController *secTypeVC = [[SectionTypeViewController alloc] init];
            secTypeVC.type = JTK;
            [self.navigationController pushViewController:secTypeVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 经典资料模块点击
- (void)BookBtnClicked:(NSNotification *)noti
{
    HomeModuleModel *moduleModel = (HomeModuleModel *)noti.object;
    switch (moduleModel.type) {
        case 5:case 6:case 13:case 14:  //高频数据、教材强化、历年真题、冲刺密卷
        {
            SectionViewController *sectionVC = [[SectionViewController alloc] init];
            sectionVC.naviTitle = moduleModel.title;
            sectionVC.sid = moduleModel.para[@"sid"];
            sectionVC.type = moduleModel.type;
            [self.navigationController pushViewController:sectionVC animated:YES];
        }
            break;
        case 11:  //资料下载
        {
            DataDownloadViewController *vc = [[DataDownloadViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12:  //视频解析
        {
            CourseViewController *courseVC = [[CourseViewController alloc] init];
            courseVC.isOpenCourse = YES;
            [self.navigationController pushViewController:courseVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 播放视频
- (void)StudyCourseBtnClicked:(NSNotification *)noti
{
    VideoSectionModel *vSectionModel = (VideoSectionModel *)noti.object;
    if (vSectionModel.isBuy == YES) {
        [self showPayAlertWithPid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.pid] appType:[NSString stringWithFormat:@"%ld",(long)vSectionModel.appType]];
        return;
    }
    //获取视频详情
    [VideoManager videoManagerBasicWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] vid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.vid] completed:^(id obj) {
        if (obj != nil) {
            ALiVideoPlayViewController *videoPlayVC = [[ALiVideoPlayViewController alloc] init];
            videoPlayVC.vcType = SectionVideoType;
            videoPlayVC.vSecModel = vSectionModel;
            videoPlayVC.vDetailModel = [VideoDetailModel yy_modelWithDictionary:(NSDictionary *)obj];
            videoPlayVC.vDetailModel.srTime = vSectionModel.srTime;
            videoPlayVC.vDetailModel.srid = vSectionModel.srid;
            if ([videoPlayVC.vDetailModel.vUrl hasSuffix:@"html"]) {
                videoPlayVC.isHtmlVideo = YES;
            }
//            videoPlayVC.vtfid = 1;
            //切换线路
            if ([USER_DEFAULTS integerForKey:VideoSource] != 0) {
                videoPlayVC.vDetailModel.vUrl = [videoPlayVC.vDetailModel.vUrl stringByReplacingOccurrencesOfString:VideoSource_moren withString:VideoSourceArray[[USER_DEFAULTS integerForKey:VideoSource]]];
            }
            [self.navigationController pushViewController:videoPlayVC animated:YES];
        }
    }];
}
#pragma mark - 打开讲义
- (void)StudyHandoutBtnClicked:(NSNotification *)noti
{
    VideoSectionModel *vSectionModel = (VideoSectionModel *)noti.object;
    if (vSectionModel.isBuy == YES) {
        [self showPayAlertWithPid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.pid] appType:[NSString stringWithFormat:@"%ld",(long)vSectionModel.appType]];
        return;
    }
    HandoutViewController *handoutVC = [[HandoutViewController alloc] init];
    handoutVC.naviTitle = vSectionModel.title;
    handoutVC.vid = vSectionModel.vid;
    [self.navigationController pushViewController:handoutVC animated:YES];
}
#pragma mark - 弹出购买提示
- (void)showPayAlertWithPid:(NSString *)pid appType:(NSString *)appType
{
    if (IsLocalAccount) {
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"当前为试用账号，试用账号购买后，仅在当前设备有效，一旦卸载或更换设备，权限将自动关闭，是否购买？" cancelButtonTitle:@"取消" otherButtonTitle:@"确认购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            if (buttonIndex == XZAlertViewBtnTagSure) {
                [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"您暂无权限查看该章节，请您购买后查看。" cancelButtonTitle:@"取消" otherButtonTitle:@"点击购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                    if (buttonIndex == XZAlertViewBtnTagSure) {
                        [OrderManager orderManagerAdvanceWithVC:self examid:[USER_DEFAULTS objectForKey:EIID] courseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] pid:pid num:@"1" key:@"" ciid:@"" cdkey:@"" remark:@"" payType:[USER_DEFAULTS objectForKey:Payment] appType:appType];
                    }
                    return;
                }];
            }
        }];
    } else {
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"您暂无权限查看该章节，请您购买后查看。" cancelButtonTitle:@"取消" otherButtonTitle:@"点击购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            if (buttonIndex == XZAlertViewBtnTagSure) {
                [OrderManager orderManagerAdvanceWithVC:self examid:[USER_DEFAULTS objectForKey:EIID] courseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] pid:pid num:@"1" key:@"" ciid:@"" cdkey:@"" remark:@"" payType:[USER_DEFAULTS objectForKey:Payment] appType:appType];
            }
            return;
        }];
    }
}
#pragma mark - 切换科目
- (void)StudyVCChangeCourse:(NSNotification *)noti
{
    [self courseBgButtonClicked];
    
    [self DeleteAllViewAndReloadData];
}
#pragma mark - 点击广告
- (void)MainAdverClicked:(NSNotification *)noti
{
//    AdInfoModel *adModel = (AdInfoModel *)noti.object;
//    if ([adModel.operateType isEqualToString:@"link"]) {
//        WebViewController *webVC = [[WebViewController alloc] init];
//        webVC.naviTitle = adModel.title;
//        webVC.webVCUrl = adModel.operateValue;
//        [self.navigationController pushViewController:webVC animated:YES];
//    } else if ([adModel.operateType isEqualToString:@"keywords"]) {
//        if ([adModel.operateValue containsString:@"contactus"]) {
//            //联系客服
//            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:[USER_DEFAULTS objectForKey:ServiceQQ]]]]]) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:[USER_DEFAULTS objectForKey:ServiceQQ]]]]];
//            } else {
//                [XZCustomWaitingView showAutoHidePromptView:@"打开失败" background:nil showTime:1.2];
//            }
//        }
//    }
}

#pragma mark - 代理方法
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

#pragma mark - 其他方法
#pragma mark - 删除所有子视图并重新加载
- (void)DeleteAllViewAndReloadData
{
    //删除所有控件
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIView class]]) {
            [obj removeFromSuperview];
        }
    }
    self.courseIdArray = nil;
    self.courseBgButton = nil;
    self.courseView = nil;
    [self createUI];
    return;
}
#pragma mark - 弹出强制广告提示
- (void)showCompelAdverAlertWithAdModel:(AdInfoModel *)adModel
{
    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:adModel.explain cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
        
    }];
}

#pragma mark - 获取版本更新信息
- (void)appUpdateInfo
{
    NSLog(@"%@---%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
    [HomeManager homeManagerAppUpdateVerinfoWithAppkey:@"1" appVer:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] systype:@"1" completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            if (dic.count == 0) {
                [USER_DEFAULTS setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:AppVer];
                [USER_DEFAULTS synchronize];
                return;
            }
            AppUpdateModel *appModel = [AppUpdateModel yy_modelWithDictionary:dic];
            [USER_DEFAULTS setBool:appModel.appStatus forKey:AppStatus];
            [USER_DEFAULTS setObject:appModel.appVer forKey:AppVer];
            [USER_DEFAULTS synchronize];
            
            if (![appModel.appVerName isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] && appModel.appStatus == 1) {
                //清除图片缓存
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
                //弹出新版本更新提示
                [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:appModel.updateLog cancelButtonTitle:@"前往更新" otherButtonTitle:appModel.isCoerce == 0 ? @"取消":@"" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                    if (buttonIndex == XZAlertViewBtnTagCancel) {
                        NSLog(@"%@",appModel.downUrl);
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appModel.downUrl]];
                        //https://itunes.apple.com/cn/app/id1342564341?mt=8
                    }
                }];
            }
        }
    }];
}
#pragma mark - 会员验证
- (void)userVerifyToken
{
    if (IsLocalAccount == NO) {
        [UserManager userNewestTokenWithVC:self uid:[USER_DEFAULTS objectForKey:User_uid]];
    }
}
#pragma mark - APP统一配置
- (void)getMainConfig
{
    [HomeManager MainConfigGetInfo];
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType)
    {
//        MKSignUpViewController *mkSignupVC = [[MKSignUpViewController alloc] init];
//        [self.navigationController pushViewController:mkSignupVC animated:YES];
//        return;
        [XZCustomViewManager showSystemAlertViewWithTitle:@"App意见反馈" message:@"如果您对我们的App有任何的意见或者建议，欢迎您进行反馈或者评分。" cancelButtonTitle:@"吐个槽" otherButtonTitle:@"做个评价" isTouchbackground:YES withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            if (buttonIndex == XZAlertViewBtnTagCancel) {
                AppEvaluateViewController *appEvaluateVC = [[AppEvaluateViewController alloc] init];
                [self.navigationController pushViewController:appEvaluateVC animated:YES];
            } else if (buttonIndex == XZAlertViewBtnTagSure) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1342564341?mt=8"]];
                if (NSFoundationVersionNumber > NSFoundationVersionNumber10_3) {
                    [SKStoreReviewController requestReview];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1342564341?action=write-review"]];
                }
            }
        }];
    }
    else if (btnType == RightBtnType)
    {
        
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
#pragma mark - dealloc
- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - 懒加载
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
