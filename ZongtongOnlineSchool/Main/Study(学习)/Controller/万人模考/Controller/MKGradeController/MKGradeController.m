//
//  MKGradeController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/20.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKGradeController.h"
#import "Tools.h"
#import "MKModel.h"
#import "MKManager.h"
#import "MKGradeTableView.h"
#import "MKStateController.h"
#import "MKQuestionViewController.h"
#import "HomeModel.h"
#import "HomeManager.h"
#import "WebViewController.h"
#import "VideoSectionViewController.h"

@interface MKGradeController () <AdverViewDelegate>
{
    NSMutableArray *_dataArray;
    EmkUserGradeModel *_temGradeModel;
}
@property (nonatomic, strong) AdverView *adView;
@property (nonatomic, strong) NSMutableArray *adArray;
@property (nonatomic, strong) MKGradeTableView *tableView;
@property (nonatomic, strong) UIButton *bgButton;
@end

@implementation MKGradeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //广告列表
    [HomeManager homeManagerAdInfoServeBasicListWithPlace:@"6" system:@"1" completed:^(id obj) {
        self.adArray = [NSMutableArray arrayWithCapacity:10];
        NSArray *temArray = (NSArray *)obj;
        self.adView.delegate = self;
        if (temArray.count != 0) {
            self.adView.frame = CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*3.0/8);
        }
        for (NSDictionary *adDic in temArray) {
            AdInfoModel *adInfoModel = [AdInfoModel yy_modelWithDictionary:adDic];
            [self.adArray addObject:adInfoModel];
        }
        [self.adView refreshWithAdArray:self.adArray];
        
        //获取用户成绩
        [MKManager mkManagerExamMockGetUserScoreWithUid:[USER_DEFAULTS objectForKey:User_uid] emkid:[NSString stringWithFormat:@"%ld",(long)self.emkid] Completed:^(id obj) {
            if (obj != nil) {
                _dataArray = [NSMutableArray arrayWithCapacity:10];
                for (NSDictionary *dic in (NSArray *)obj) {
                    EmkUserGradeModel *userGradeModel = [EmkUserGradeModel yy_modelWithDictionary:dic];
                    [_dataArray addObject:userGradeModel];
                }
                if (!self.tableView) {
                    self.tableView = [[MKGradeTableView alloc] initWithFrame:CGRectMake(0, self.adView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.adView.height) style:UITableViewStylePlain dataArray:_dataArray naviTitle:self.naviTitle];
                    [self.view addSubview:self.tableView];
                }
                self.tableView.dataArray = _dataArray;
                [self.tableView reloadData];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKGradeVCLookAllAnalyse:) name:@"MKGradeVCLookAllAnalyse" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKGradeVCReExam:) name:@"MKGradeVCReExam" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKGradeVCExam:) name:@"MKGradeVCExam" object:nil];
            }
        }];
    }];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.bgButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:16.0f leftBtnTitle:@"back.png" rightBtnTitle:@"分享" bgColor:MAIN_RGB];
}
#pragma mark -
#pragma mark - 点击广告
- (void)adverViewClickedWithAdModel:(id)model
{
    AdInfoModel *adModel = (AdInfoModel *)model;
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
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
#pragma mark - 查看解析
- (void)MKGradeVCLookAllAnalyse:(NSNotification *)noti
{
    NSString *startTime = [USER_DEFAULTS objectForKey:MKNowExamSTime];
    NSString *str1 = [startTime substringToIndex:10];
    NSString *timeStr = [NSString stringWithFormat:@"%@ 10:00:00",str1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:timeStr];
    startDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:startDate];
    
    NSTimeInterval start = [startDate timeIntervalSince1970] * 1;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970] * 1;
    NSTimeInterval cha = start - now;
    if (cha > 0) {
        [XZCustomWaitingView showAutoHidePromptView:[NSString stringWithFormat:@"答案将于%@准时公布",[dateFormatter stringFromDate:startDate]] background:nil showTime:2.0];
    } else {
        //弹出提示
        self.bgButton.hidden = NO;
        _temGradeModel = (EmkUserGradeModel *)noti.object;
    }
}
- (void)videoBtnClicked
{
    VideoSectionViewController *videoSectionVC = [[VideoSectionViewController alloc] init];
    videoSectionVC.naviTitle = @"万人模考视频解析";
    videoSectionVC.courseId = [NSString stringWithFormat:@"%ld",(long)_temGradeModel.courserId];
    videoSectionVC.vtfid = [[USER_DEFAULTS objectForKey:EIID] integerValue] == 2 ? 11:6;
    [self.navigationController pushViewController:videoSectionVC animated:YES];
}
- (void)textBtnClicked
{
    [self goToQuetionVCWithModel:_temGradeModel type:MKGradeLookAllAnalyse];
}
- (void)closeBtnClicked
{
    self.bgButton.hidden = YES;
}
#pragma mark - 申请重考
- (void)MKGradeVCReExam:(NSNotification *)noti
{
    EmkUserGradeModel *model = (EmkUserGradeModel *)noti.object;
    [MKManager mkManagerExamMockAgainExerciseWithUid:[USER_DEFAULTS objectForKey:User_uid] eid:[NSString stringWithFormat:@"%ld",(long)model.eid] Completed:^(id obj) {
        if (obj != nil) {
            [MKManager mkManagerExamMockGetUserScoreWithUid:[USER_DEFAULTS objectForKey:User_uid] emkid:[NSString stringWithFormat:@"%ld",(long)self.emkid] Completed:^(id obj) {
                if (obj != nil) {
                    EmkUserGradeModel *userGradeModel = [[EmkUserGradeModel alloc] init];
                    for (NSDictionary *dic in (NSArray *)obj) {
                        EmkUserGradeModel *temModel = [EmkUserGradeModel yy_modelWithDictionary:dic];
                        if (temModel.eid == model.eid) {
                            userGradeModel = temModel;
                            break;
                        }
                    }
                    [self goToQuetionVCWithModel:userGradeModel type:MKGradeReExam];
                }
            }];
        }
    }];
}
#pragma mark - 立即考试
- (void)MKGradeVCExam:(NSNotification *)noti
{
    [self goToQuetionVCWithModel:(EmkUserGradeModel *)noti.object type:MKGradeExam];
}
#pragma mark - 跳转到做题界面
- (void)goToQuetionVCWithModel:(EmkUserGradeModel *)model type:(MKGradeVCExamType)type
{
    if (self.isLookGrade) {
        [USER_DEFAULTS setBool:type == MKGradeLookAllAnalyse ? YES:NO forKey:MKQuestion_IsAnalyse];
        [USER_DEFAULTS synchronize];
        MKQuestionViewController *mkQuestionVC = [[MKQuestionViewController alloc] init];
        mkQuestionVC.naviTitle = model.courserTitle;
        mkQuestionVC.gradeVCNaviTitle = self.naviTitle;
        mkQuestionVC.temEmkid = model.emkid;
        mkQuestionVC.temEmkiid = model.emkiid;
        mkQuestionVC.temEid = type == MKGradeReExam ? 0:model.eid;
        [self.navigationController pushViewController:mkQuestionVC animated:YES];
    } else {
        if ([self.gradeVCDelegate respondsToSelector:@selector(gradeVCPopWithUserGradeModel:type:)]) {
            [USER_DEFAULTS setBool:type == MKGradeLookAllAnalyse ? YES:NO forKey:MKQuestion_IsAnalyse];
            [USER_DEFAULTS synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            [self.gradeVCDelegate gradeVCPopWithUserGradeModel:model type:type];
        }
    }
}
#pragma mark - 分享
- (void)ShareMKExam
{
    //显示分享面板
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_QQ)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"分享平台：%ld",(long)platformType);
        for (EmkUserGradeModel *model in _dataArray) {
            if (model.emkid == self.emkid) {
                [self shareWebPageToPlatformType:platformType model:model];
                break;
            }
        }
    }];
}
#pragma mark - 分享功能
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType model:(EmkUserGradeModel *)model
{
    UMSocialMessageObject *shareMessage = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"总统网校" descr:[NSString stringWithFormat:@"我参加了总统网校《%@》的万人模考，获得了%@分，敢不敢来挑战？",model.courserTitle,model.score] thumImage:nil];
    shareObject.webpageUrl = ShareAppURL;
    shareMessage.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:shareMessage currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            [XZCustomWaitingView showAutoHidePromptView:@"分享失败" background:nil showTime:1.0];
        } else {
            NSLog(@"response data is %@",result);
        }
    }];
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MKStateController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    } else if (btnType == RightBtnType) {
        [self ShareMKExam];
    }
}
- (AdverView *)adView {
    if (!_adView) {
        _adView = [[AdverView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 0)];
        [self.view addSubview:_adView];
    }
    return _adView;
}
- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height)];
        _bgButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FIT_WITH_DEVICE(_bgButton.width * 0.8, _bgButton.width*0.6), SCREEN_FIT_WITH_DEVICE(_bgButton.width * 0.8, _bgButton.width*0.6) * 1.2)];
        imgView.center = CGPointMake(_bgButton.width/2, _bgButton.height/2 - 40);
        imgView.image = [UIImage imageNamed:@"mkjiexi.png"];
        imgView.userInteractionEnabled = YES;
        [_bgButton addSubview:imgView];
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgView.width - 50, 0, 50, 50)];
        [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:closeBtn];
        UIButton *videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgView.width * 0.1, imgView.height * 0.6, imgView.width * 0.35, imgView.width * 0.45)];
        [videoBtn addTarget:self action:@selector(videoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:videoBtn];
        UIButton *textBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgView.width * 0.55, videoBtn.top, videoBtn.width, videoBtn.height)];
        [textBtn addTarget:self action:@selector(textBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:textBtn];
        _bgButton.hidden = YES;
        [self.view addSubview:_bgButton];
    }
    return _bgButton;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
