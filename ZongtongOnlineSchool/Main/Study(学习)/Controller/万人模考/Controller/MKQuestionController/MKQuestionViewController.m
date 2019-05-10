//
//  MKQuestionViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKQuestionViewController.h"
#import "Tools.h"
#import "QuestionModel.h"
#import "QuestionManager.h"
#import "MKQuestionTabbar.h"
#import "QTabbarSetView.h"
#import "MKQuestionTypeView.h"
#import "MKQuestionCollectionView.h"
#import "TestReportViewController.h"
#import "QuestionCardViewController.h"
#import "VideoManager.h"
#import "AppTypeManager.h"
#import "VideoDetailModel.h"
#import "ALiVideoPlayViewController.h"
#import "MKModel.h"
#import "MKManager.h"
#import "MKStateController.h"
#import "MKGradeController.h"

@interface MKQuestionViewController () <MKQuestionCollectionViewDelegate, MKQuestionTabbarDelegate, QuestionCardDelegate, MKQTypeViewDelegate, MKGradeVCDelegate>
{
    NSInteger _nowPage;   //当前是第几页
    NSInteger _pageSize;  //每页数据容量
    NSInteger _maxPage;   //最大页数
    NSInteger _rowCount;  //数据总数
    
    NSMutableArray *_qCardArray; //答题卡数据
    NSInteger _seconds;          //计时器秒数
    
    NSInteger _eid;
}
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) QTabbarSetView *setView;
@property (nonatomic, strong) MKQuestionTabbar *qTabbar;
@property (nonatomic, strong) MKQuestionTypeView *qTypeView;
@property (nonatomic, strong) MKQuestionCollectionView *collectionView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) MKQuestionModel *mkQuestionModel;
@end

@implementation MKQuestionViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    //添加通知
    [self registerNotification];
    
    //获取整套试题
    [self getMKExamMockQuestion];
}
#pragma mark - 创建UI
- (void)createUI
{
    self.view.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
    //设置默认字体大小
    [USER_DEFAULTS setFloat:14.0f forKey:QLabelFont];
    [USER_DEFAULTS synchronize];
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:14.0f leftBtnTitle:@"back.png" rightBtnTitle:@"xuanxiang.png" bgColor:[USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_Navigationbar:MAIN_RGB];
    [self.navigationBar.titlebutton addTarget:self action:@selector(baseNaviButtonClickedWithBtnType:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 获取数据
#pragma mark - 获取万人模考题信息
- (void)getMKExamMockQuestion
{
    [MKManager mkManagerExamMockGetMockQuestionWithUid:[USER_DEFAULTS objectForKey:User_uid] emkid:[NSString stringWithFormat:@"%ld",(long)self.temEmkid] emkiid:[NSString stringWithFormat:@"%ld",(long)self.temEmkiid] Completed:^(id obj) {
        if (obj != nil) {
            self.mkQuestionModel = [MKQuestionModel yy_modelWithDictionary:(NSDictionary *)obj];
            _seconds = self.mkQuestionModel.examTime * 60;
            NSMutableArray *netDataArray = [NSMutableArray arrayWithCapacity:10];
            NSString *qidJson = @"";
            for (NSDictionary *dic in self.mkQuestionModel.quesList) {
                QuestionModel *qModel = [QuestionModel yy_modelWithDictionary:dic];
//                NSLog(@"题目分数：***%@***",qModel.score);
                [netDataArray addObject:qModel];
                qidJson = [qidJson stringByAppendingFormat:@"%ld,",(long)qModel.qid];
            }
            if (qidJson.length > 0) {
                qidJson = [qidJson substringToIndex:qidJson.length - 1];
            }
            if (self.temEid > 0) {  //有 eid，获取考试信息，展示解析界面
                _eid = self.temEid;
                [self getMKExamExerciseInfoWithUid:[USER_DEFAULTS objectForKey:User_uid] eid:[NSString stringWithFormat:@"%ld",(long)self.temEid] array:netDataArray qidJson:qidJson];
            } else {  //没有 eid，开新试卷
                [self mkExamAddExerciseWithArray:netDataArray qidJson:qidJson];
            }
        }
    }];
}
#pragma mark - 获取万人模考开卷
- (void)mkExamAddExerciseWithArray:(NSMutableArray *)array qidJson:(NSString *)qidJson
{
    [MKManager mkManagerExamMockAddExerciseWithUid:[USER_DEFAULTS objectForKey:User_uid] courseid:[NSString stringWithFormat:@"%ld",(long)self.mkQuestionModel.courseid] nickname:[USER_DEFAULTS objectForKey:User_nickName] emkiid:[NSString stringWithFormat:@"%ld",(long)self.mkQuestionModel.emkiid] emkid:[NSString stringWithFormat:@"%ld",(long)self.mkQuestionModel.emkid] sid:[NSString stringWithFormat:@"%ld",(long)self.mkQuestionModel.sid] title:self.mkQuestionModel.courseTitle qidJson:qidJson Completed:^(id obj) {
        if (obj != nil) {
            _eid = [obj integerValue];
            for (QuestionModel *qModel in array) {
                qModel.isWrite = NO;
                self.qExerinfoModel = [[QExerinfoModel alloc] init];
                self.qExerinfoModel.eid = _eid;
                qModel.qExerinfoBasicModel = [QExerinfoBasicModel yy_modelWithDictionary:@{@"uAnswer":@"", @"eid":[NSString stringWithFormat:@"%ld",(long)_eid], @"eiid":@"0"}];
            }
            //获取题分类
            [self getQuestionTypeWithArray:array];
        }
    }];
}
#pragma mark - 获取考试信息
- (void)getMKExamExerciseInfoWithUid:(NSString *)uid eid:(NSString *)eid array:(NSMutableArray *)array qidJson:(NSString *)qidJson
{
    [MKManager mkManagerExamMockGetExerinfoWithUid:uid eid:eid Completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            //修改试卷信息
            self.qExerinfoModel = [QExerinfoModel yy_modelWithDictionary:dic];
            if ([dic[@"userExerList"] count] == 0) {
                //开新试卷
                [self mkExamAddExerciseWithArray:array qidJson:qidJson];
            }
            else {
                [self continueDoExerciseWithArray:array];
            }
        }
    }];
}
#pragma mark - 继续做题
- (void)continueDoExerciseWithArray:(NSMutableArray *)array
{
    for (NSInteger i = 0; i < array.count; i ++) {
        QuestionModel *qModel = array[i];
        qModel.qExerinfoBasicModel = [QExerinfoBasicModel yy_modelWithDictionary:@{@"uAnswer":@"", @"eid":[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.eid], @"eiid":@"0"}];
        for (QExerinfoBasicModel *qExerinfoBasicModel in self.qExerinfoModel.userExerList) {
            if (qModel.qid == qExerinfoBasicModel.qid) {
                qModel.qExerinfoBasicModel = qExerinfoBasicModel;
                qModel.isWrite = YES;
            }
        }
        if (qModel.qid == self.qExerinfoModel.nowQid) {
            self.nowQIndex = i;
        }
    }
    //获取题分类
    [self getQuestionTypeWithArray:array];
}
#pragma mark - 获取题分类
- (void)getQuestionTypeWithArray:(NSMutableArray *)array
{
    NSArray *qTypePlistArray;
    if ([FileDefaultManager fileExistsAtPath:GetFileFullPath(QtypeListPlist)]) {
        qTypePlistArray = [[NSArray alloc] initWithContentsOfFile:GetFileFullPath(QtypeListPlist)];
    }
    for (int i = 0; i < array.count; i ++) {
        QuestionModel *qModel = array[i];
        for (NSDictionary *dic in qTypePlistArray) {
            if (qModel.qtid == [dic[@"qtId"] integerValue]) {
                qModel.qTypeListModel = [QtypeListModel yy_modelWithDictionary:dic];
                break;
            }
        }
        qModel.qIndex = i;
        //重组option
        NSArray *AZArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N"];
        switch (qModel.qTypeListModel.showKey) {
            case 1:case 2:  //单选、多选
            {
                NSArray *optionArray = [qModel.option componentsSeparatedByString:@"|"];
                for (int i = 0; i < optionArray.count; i ++) {
                    QuestionOptionModel *optionModel = [[QuestionOptionModel alloc] init];
                    optionModel.AZ = AZArray[i];
                    optionModel.option = optionArray[i];
                    optionModel.value = i + 1;
                    [qModel.optionList addObject:optionModel];
                }
            }
                break;
            case 3:  //判断
            {
                NSArray *optionArray = @[@"正确", @"错误"];
                for (int i = 0; i < optionArray.count; i ++) {
                    QuestionOptionModel *optionModel = [[QuestionOptionModel alloc] init];
                    optionModel.AZ = AZArray[i];
                    optionModel.option = optionArray[i];
                    optionModel.value = i + 1;
                    [qModel.optionList addObject:optionModel];
                }
            }
                
            default:
                break;
        }
    }
    //collectionView布局
    [self configCollectionViewWithDataArray:array];
}
#pragma mark - collectionView布局
- (void)configCollectionViewWithDataArray:(NSMutableArray *)dataArray
{
    [XZCustomWaitingView hideWaitingMaskView];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-self.navigationBar.height-self.qTypeView.height-self.qTabbar.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[MKQuestionCollectionView alloc] initWithFrame:CGRectMake(0, self.qTypeView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-self.navigationBar.height-self.qTypeView.height-self.qTabbar.height) collectionViewLayout:layout];
    self.collectionView.collectionDataArray = dataArray;
    self.collectionView.MKcollectionViewDelegate = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.width*self.nowQIndex, 0) animated:NO];
    //刷新qTypeView、qTabbar
    QuestionModel *nowQModel = self.collectionView.collectionDataArray[self.nowQIndex];
    [self.qTypeView refreshQtypeViewWithQType:nowQModel.qTypeListModel.title qNumber:[NSString stringWithFormat:@"%ld/%ld",self.nowQIndex+1,dataArray.count]];
    [self.view bringSubviewToFront:self.qTabbar];
    [self.view bringSubviewToFront:self.bgButton];
    
    //启动定时器
    if ([USER_DEFAULTS boolForKey:MKQuestion_IsAnalyse] == NO) {
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCountdown) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        [self.timer setFireDate:[NSDate distantPast]];
    }
}
#pragma mark - 注册通知
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKDanOrPanOptionClicked) name:@"MKDanOrPanOptionClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKQuestionUpUserAnswer:) name:@"MKQuestionUpUserAnswer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QTabbarSetViewBtnClicked:) name:@"QTabbarSetViewBtnClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoCellVideoBtnClicked) name:@"VideoCellVideoBtnClicked" object:nil];
}
#pragma mark - 定时器计时
- (void)timerCountdown
{
    _seconds --;
    NSInteger hour   = _seconds/3600;
    NSInteger minute = (_seconds%3600)/60;
    NSInteger second = _seconds%60;
    [self.qTypeView.timerButton setTitle:[NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second] forState:UIControlStateNormal];
    if (_seconds == 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        [XZCustomViewManager showSystemAlertViewWithTitle:@"考试结束" message:@"考试时间到，请您提交您的试卷" cancelButtonTitle:@"提交试卷" otherButtonTitle:@"" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            [self submitPaperWithIsGiveUpExam:NO];
        }];
    }
}

#pragma mark -
#pragma mark - 通知方法
#pragma mark - 单选、判断点击选项
- (void)MKDanOrPanOptionClicked
{
    if ([USER_DEFAULTS boolForKey:MKQuestion_IsAnalyse]) {
        return;
    }
    //调用答题卡点击方法
    if (self.nowQIndex + 1 < self.collectionView.collectionDataArray.count) {
        [self performSelector:@selector(nextQuetion) withObject:nil afterDelay:0.5];
    }
}
- (void)nextQuetion
{
    [self questionCardClickedWithIndex:self.nowQIndex + 1 animated:YES];
}
#pragma mark - 保存答案
- (void)MKQuestionUpUserAnswer:(NSNotification *)noti
{
    if ([USER_DEFAULTS boolForKey:MKQuestion_IsAnalyse]) {
        return;
    }
    QuestionModel *qModel = (QuestionModel *)noti.object;
    
    [MKManager mkManagerExamMockUpUserAnswerWithEiid:[NSString stringWithFormat:@"%ld",(long)qModel.qExerinfoBasicModel.eiid] eid:[NSString stringWithFormat:@"%ld",(long)_eid] uid:[USER_DEFAULTS objectForKey:User_uid] courseid:[NSString stringWithFormat:@"%ld",(long)qModel.courseId] sid:[NSString stringWithFormat:@"%ld",(long)qModel.sid] qid:[NSString stringWithFormat:@"%ld",(long)qModel.qid] uAnswer:qModel.qExerinfoBasicModel.uAnswer answer:qModel.answer isRight:[NSString stringWithFormat:@"%ld",(long)qModel.qExerinfoBasicModel.isRight] Completed:^(id obj) {
        if (obj != nil) {
            qModel.qExerinfoBasicModel.eiid = [obj integerValue];
        }
    }];
}
#pragma mark - 设置按钮点击
- (void)QTabbarSetViewBtnClicked:(NSNotification *)noti
{
    switch ([noti.object integerValue])
    {
        case SettingFontMinus: //字体 A-
        {
            [self changeLabelFontWithSettingType:SettingFontMinus font:[USER_DEFAULTS floatForKey:QLabelFont]];
        }
            break;
        case SettingFontAdd:   //字体 A+
        {
            [self changeLabelFontWithSettingType:SettingFontAdd font:[USER_DEFAULTS floatForKey:QLabelFont]];
        }
            break;
        case SettingDay:       //白天模式
        {
            if ([USER_DEFAULTS boolForKey:Question_DayNight] != NO) {
                [USER_DEFAULTS setBool:NO forKey:Question_DayNight];
                [USER_DEFAULTS synchronize];
                [self.setView.riJianBtn setImage:[UIImage imageNamed:@"rijianmoshise.png"] forState:UIControlStateNormal];
                [self.setView.yeJianBtn setImage:[UIImage imageNamed:@"yejianmoshi.png"] forState:UIControlStateNormal];
                self.view.backgroundColor = [UIColor whiteColor];
                self.navigationBar.backgroundColor = MAIN_RGB;
                self.qTypeView.backgroundColor = [UIColor whiteColor];
                self.qTabbar.backgroundColor = MAIN_RGB_LINE;
                self.setView.backgroundColor = [UIColor whiteColor];
                self.collectionView.cell.tableView.backgroundColor = [UIColor whiteColor];
                [self.collectionView reloadData];
            }
        }
            break;
        case SettingNight:     //夜间模式
        {
            if ([USER_DEFAULTS boolForKey:Question_DayNight] != YES) {
                [USER_DEFAULTS setBool:YES forKey:Question_DayNight];
                [USER_DEFAULTS synchronize];
                [self.setView.riJianBtn setImage:[UIImage imageNamed:@"rijianmoshi.png"] forState:UIControlStateNormal];
                [self.setView.yeJianBtn setImage:[UIImage imageNamed:@"yejianmoshise.png"] forState:UIControlStateNormal];
                self.view.backgroundColor = Night_RGB_BGColor;
                self.navigationBar.backgroundColor = Night_RGB_Navigationbar;
                self.qTypeView.backgroundColor = Night_RGB_BGColor;
                self.qTabbar.backgroundColor = Night_RGB_BGColor;
                self.setView.backgroundColor = Night_RGB_BGColor;
                self.collectionView.cell.tableView.backgroundColor = Night_RGB_BGColor;
                [self.collectionView reloadData];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - 字体大小调节
- (void)changeLabelFontWithSettingType:(QTabbarSetType)settingType font:(CGFloat)font;
{
    if (settingType == SettingFontAdd)
    {
        if (font > 16.0)
        {
            [XZCustomWaitingView showAutoHidePromptView:@"字体已经最大" background:nil showTime:1.0];
        }
        else
        {
            float labelFont = font + 1.0;
            [USER_DEFAULTS setFloat:labelFont forKey:QLabelFont];
            [USER_DEFAULTS synchronize];
            [self.collectionView reloadData];
        }
    }
    else if (settingType == SettingFontMinus)
    {
        if (font < 13.0)
        {
            [XZCustomWaitingView showAutoHidePromptView:@"字体已经最小" background:nil showTime:1.0];
        }
        else
        {
            float labelFont = font - 1.0;
            [USER_DEFAULTS setFloat:labelFont forKey:QLabelFont];
            [USER_DEFAULTS synchronize];
            [self.collectionView reloadData];
        }
    }
}
#pragma mark - 查看试题视频
- (void)VideoCellVideoBtnClicked
{
    QuestionModel *qModel = self.collectionView.collectionDataArray[self.nowQIndex];
    //试题视频
    [QuestionManager QuestionManagerQVideoBasicInfoWithQvid:[NSString stringWithFormat:@"%ld",(long)qModel.vid] qid:[NSString stringWithFormat:@"%ld",(long)qModel.qid] completed:^(id obj) {
        if (obj != nil) {
            qModel.qVideModel = [QVideoModel yy_modelWithDictionary:(NSDictionary *)obj];
            if (qModel.qVideModel.charge == 1) {  //收费
                [AppTypeManager appTypeManagerIsVerificationWithCourseid:[NSString stringWithFormat:@"%ld",(long)qModel.courseId] uid:[USER_DEFAULTS objectForKey:User_uid] apptype:[NSString stringWithFormat:@"%ld",(long)qModel.qVideModel.appType] completed:^(BOOL obj) {
                    if (obj == YES) {
                        [self getQuestionVideoDetailWithQVid:qModel.qVideModel.qvid qid:qModel.qid courseid:qModel.courseId];
                    }
                }];
            } else {
                //                [self getQuestionVideoDetailWithQVid:qModel.qVideModel.qvid qid:qModel.qid];
                ALiVideoPlayViewController *videoPlayVC = [[ALiVideoPlayViewController alloc] init];
                videoPlayVC.vcType = QuestionVideoType;
                videoPlayVC.qid = [NSString stringWithFormat:@"%ld",(long)qModel.qVideModel.qid];
                videoPlayVC.vDetailModel = [VideoDetailModel yy_modelWithDictionary:(NSDictionary *)obj];
                videoPlayVC.vDetailModel.vid = qModel.qVideModel.qvid;
                videoPlayVC.vDetailModel.vImg = qModel.qVideModel.videoImg;
                videoPlayVC.vDetailModel.vUrl = qModel.qVideModel.video;
                videoPlayVC.videoSectionDataArray = [NSMutableArray arrayWithArray:(NSArray *)self.dataArray];
                if ([videoPlayVC.vDetailModel.vUrl hasSuffix:@"html"]) {
                    videoPlayVC.isHtmlVideo = YES;
                }
                //切换线路
                if ([USER_DEFAULTS integerForKey:VideoSource] != 0) {
                    videoPlayVC.vDetailModel.vUrl = [videoPlayVC.vDetailModel.vUrl stringByReplacingOccurrencesOfString:VideoSource_moren withString:VideoSourceArray[[USER_DEFAULTS integerForKey:VideoSource]]];
                }
                [self.navigationController pushViewController:videoPlayVC animated:YES];
            }
        }
    }];
    
}
#pragma mark - 视频详情
- (void)getQuestionVideoDetailWithQVid:(NSInteger)qvid qid:(NSInteger)qid courseid:(NSInteger)courseid
{
    //视频详情
    [VideoManager videoManagerBasicWithCourseid:[NSString stringWithFormat:@"%ld",(long)courseid] uid:[USER_DEFAULTS objectForKey:User_uid] vid:[NSString stringWithFormat:@"%ld",(long)qvid] completed:^(id obj) {
        if (obj != nil) {
            ALiVideoPlayViewController *videoPlayVC = [[ALiVideoPlayViewController alloc] init];
            videoPlayVC.vcType = QuestionVideoType;
            videoPlayVC.qid = [NSString stringWithFormat:@"%ld",(long)qid];
            videoPlayVC.vDetailModel = [VideoDetailModel yy_modelWithDictionary:(NSDictionary *)obj];
            videoPlayVC.videoSectionDataArray = [NSMutableArray arrayWithArray:(NSArray *)self.dataArray];
            if ([videoPlayVC.vDetailModel.vUrl hasSuffix:@"html"]) {
                videoPlayVC.isHtmlVideo = YES;
            }
            //切换线路
            if ([USER_DEFAULTS integerForKey:VideoSource] != 0) {
                videoPlayVC.vDetailModel.vUrl = [videoPlayVC.vDetailModel.vUrl stringByReplacingOccurrencesOfString:VideoSource_moren withString:VideoSourceArray[[USER_DEFAULTS integerForKey:VideoSource]]];
            }
            [self.navigationController pushViewController:videoPlayVC animated:YES];
        }
    }];
}

#pragma mark -
#pragma mark - 代理方法
#pragma mark - MKQTypeViewDelegate（弹出倒计时提示）
- (void)MKqTypeViewTimerClicked
{
//    [self.timer setFireDate:[NSDate distantFuture]];
//    [XZCustomViewManager showSystemAlertViewWithTitle:@"休息一下" message:[NSString stringWithFormat:@"已用时%@",self.qTypeView.timerButton.titleLabel.text] cancelButtonTitle:@"继续做题" otherButtonTitle:@"" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
//        [self.timer setFireDate:[NSDate distantPast]];
//    }];
}
#pragma mark - collectionView（collectionView滑动停止）
- (void)MKquestionCollectionViewScrollWithNowQModel:(QuestionModel *)nowQModel nowIndex:(NSInteger)nowIndex
{
    self.nowQIndex = nowIndex;
    nowQModel.isWrite = YES;
    [self.qTypeView refreshQtypeViewWithQType:nowQModel.qTypeListModel.title qNumber:[NSString stringWithFormat:@"%ld/%.0f",(long)nowIndex+1,self.collectionView.contentSize.width/self.collectionView.width]];
}
#pragma mark - QuestionCardDelegate（答题卡点击）
- (void)questionCardClickedWithIndex:(NSInteger)index animated:(BOOL)animated
{
    self.nowQIndex = index;
    QuestionModel *nowQModel = self.collectionView.collectionDataArray[self.nowQIndex];
    nowQModel.isWrite = YES;
    [self.qTypeView refreshQtypeViewWithQType:nowQModel.qTypeListModel.title qNumber:[NSString stringWithFormat:@"%ld/%.0f",(long)index+1,self.collectionView.contentSize.width/self.collectionView.width]];
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.width*index, 0) animated:animated];
}
#pragma mark - 答题卡切换页数
- (void)questionCardPageChangedWithArray:(NSMutableArray *)array page:(NSInteger)page
{
    if ([USER_DEFAULTS boolForKey:MKQuestion_IsAnalyse]) {
        [_qTabbar createTabbarButtonWithTitleArray:@[@"答题卡"] ImgArray:@[@"datika.png"]];
    }
    
    //移除答题卡数据
    [_qCardArray removeAllObjects];
    //先移除、再配置 collectionView
    self.nowQIndex = 0;
    [self.collectionView removeFromSuperview];
    //获取题分类
    [self getQuestionTypeWithArray:array];
}
#pragma mark - MKQuestionTabbarDelegate（底部tabbar点击）
- (void)MKQuestionTabbarClickedWithTag:(NSInteger)tag
{
    switch (tag)
    {
        case BottomQCard:   //答题卡
        {
            QuestionCardViewController *qCardVC = [[QuestionCardViewController alloc] init];
            if (_qCardArray.count == 0)
            {
                [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取答题卡信息" iconName:LoadingImage iconNumber:4];
                _qCardArray = [QuestionManager QuestionManagerGetQCardArrayWithArray:self.collectionView.collectionDataArray];
                [XZCustomWaitingView hideWaitingMaskView];
            }
            qCardVC.qCardArray = _qCardArray;
            qCardVC.qCardDelegate = self;
            [self presentViewController:qCardVC animated:YES completion:nil];
        }
            break;
        case BottomHandIn:  //提交试卷
        {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"请您检查无误后，再提交试卷" cancelButtonTitle:@"返回做题" otherButtonTitle:@"确认交卷" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagSure) {
                    [self submitPaperWithIsGiveUpExam:NO];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 提交试卷
- (void)submitPaperWithIsGiveUpExam:(BOOL)isGiveUp
{
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //更新试卷信息， 拼接对、错题的qid
    self.qExerinfoModel.useTime = self.mkQuestionModel.examTime*60 - _seconds;
    self.qExerinfoModel.rightNum = 0;
    self.qExerinfoModel.mistakeNum = 0;
    self.qExerinfoModel.userScore = @"0";
    NSLog(@"***初始分数：%@",self.qExerinfoModel.userScore);
    NSString *rightQidJson = @"";
    NSString *mistakeQidJson = @"";
    NSInteger doCount = 0;
    for (QuestionModel *qModel in self.collectionView.collectionDataArray) {
        self.qExerinfoModel = [QuestionManager QuestionManagerUpdateExerinfoWithQExerinfoModel:self.qExerinfoModel qModel:qModel];
        if (qModel.qExerinfoBasicModel.isRight == 1) {
            rightQidJson = [rightQidJson stringByAppendingFormat:@"%ld,",(long)qModel.qid];
        } else if (qModel.qExerinfoBasicModel.isRight == 2) {
            mistakeQidJson = [mistakeQidJson stringByAppendingFormat:@"%ld,",(long)qModel.qid];
        }
        if (qModel.isWrite == YES) {
            doCount ++;
        }
    }
    if (rightQidJson.length > 0) {
        rightQidJson = [rightQidJson substringToIndex:rightQidJson.length - 1];
    }
    if (mistakeQidJson.length > 0) {
        mistakeQidJson = [mistakeQidJson substringToIndex:mistakeQidJson.length - 1];
    }
    
    //结束考试
    QuestionModel *nowQModel = self.collectionView.collectionDataArray[self.nowQIndex];
    [MKManager mkManagerExamMockExerOverWithCourserid:[NSString stringWithFormat:@"%ld",(long)nowQModel.courseId] emkid:[NSString stringWithFormat:@"%ld",(long)self.mkQuestionModel.emkid] emkiid:[NSString stringWithFormat:@"%ld",(long)self.mkQuestionModel.emkiid] sid:[NSString stringWithFormat:@"%ld",(long)nowQModel.sid] eid:[NSString stringWithFormat:@"%ld",(long)_eid] uid:[USER_DEFAULTS objectForKey:User_uid] useTime:[NSString stringWithFormat:@"%ld",self.qExerinfoModel.useTime] rightNum:[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.rightNum] mistakeNum:[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.mistakeNum] userScore:self.qExerinfoModel.userScore nowQid:[NSString stringWithFormat:@"%ld",(long)nowQModel.qid] rightQids:rightQidJson mistakeQids:mistakeQidJson doCount:[NSString stringWithFormat:@"%ld",(long)doCount] Completed:^(id obj) {
        if (isGiveUp) {
            [self mkPopController];
            return;
        }
        if (obj != nil) {
            [USER_DEFAULTS setBool:YES forKey:MKQuestion_IsAnalyse];
            [USER_DEFAULTS synchronize];
            MKGradeController *gradeVC = [[MKGradeController alloc] init];
            gradeVC.naviTitle = self.gradeVCNaviTitle;
            gradeVC.emkid = self.mkQuestionModel.emkid;
            gradeVC.isLookGrade = NO;
            gradeVC.gradeVCDelegate = self;
            [self.navigationController pushViewController:gradeVC animated:YES];
        }
    }];
}
#pragma mark - 查看解析、申请重考、立即考试
- (void)gradeVCPopWithUserGradeModel:(EmkUserGradeModel *)userGradeModel type:(MKGradeVCExamType)type
{
    [XZCustomWaitingView showWaitingMaskView:@"正在获取题目" iconName:LoadingImage iconNumber:4];
    self.temEmkid = userGradeModel.emkid;
    self.temEmkiid = userGradeModel.emkiid;
    self.temEid = userGradeModel.eid;
    //移除倒计时、新建_qTabbar
    if ([USER_DEFAULTS boolForKey:MKQuestion_IsAnalyse]) {
        [self.qTypeView.timerButton removeFromSuperview];
        [self.qTabbar createTabbarButtonWithTitleArray:@[@"答题卡"] ImgArray:@[@"datika.png"]];
    } else {
        [self.qTabbar createTabbarButtonWithTitleArray:@[@"答题卡", @"提交"] ImgArray:@[@"datika.png", @"tijiao.png"]];
    }
    [self registerNotification];
    
    //移除答题卡数据
    [_qCardArray removeAllObjects];
    //先移除、再配置 collectionView
    self.nowQIndex = 0;
    [self.collectionView removeFromSuperview];
    [self getMKExamMockQuestion];
}

#pragma mark -
#pragma mark - 背景按钮点击
- (void)bgButtonClicked
{
    self.bgButton.hidden = YES;
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        if ([USER_DEFAULTS boolForKey:MKQuestion_IsAnalyse]) {
            [self mkPopController];
        } else {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"模考中途退出，将自动结束本次考试！" cancelButtonTitle:@"返回做题" otherButtonTitle:@"确认弃考" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagSure) {
                    [self submitPaperWithIsGiveUpExam:YES];
                }
            }];
        }
    } else {
        if (self.bgButton.hidden == YES) {
            self.bgButton.hidden = NO;
        } else {
            [self bgButtonClicked];
        }
    }
}
#pragma mark - 销毁定时器、移除通知
- (void)mkPopController
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [USER_DEFAULTS setBool:NO forKey:MKQuestion_IsAnalyse];
    [USER_DEFAULTS synchronize];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MKStateController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark -
#pragma mark - 懒加载
- (MKQuestionTabbar *)qTabbar {
    if (!_qTabbar) {
        _qTabbar = [[MKQuestionTabbar alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 50, UI_SCREEN_WIDTH, 50) titleArray:@[@"答题卡", @"提交"] imgArray:@[@"datika.png", @"tijiao.png"]];
        _qTabbar.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:MAIN_RGB_LINE;
        _qTabbar.MKQTabbarDelegate = self;
        [self.view addSubview:_qTabbar];
        if ([USER_DEFAULTS boolForKey:MKQuestion_IsAnalyse]) {
            [_qTabbar createTabbarButtonWithTitleArray:@[@"答题卡"] ImgArray:@[@"datika.png"]];
        }
    }
    return _qTabbar;
}
- (MKQuestionTypeView *)qTypeView {
    if (!_qTypeView) {
        _qTypeView = [[MKQuestionTypeView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 50)];
        _qTypeView.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
        _qTypeView.MKqTypeViewDelegate = self;
        if ([USER_DEFAULTS boolForKey:MKQuestion_IsAnalyse]) {
            [_qTypeView.timerButton removeFromSuperview];
        }
        [self.view addSubview:_qTypeView];
    }
    return _qTypeView;
}
- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height)];
        _bgButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [_bgButton addTarget:self action:@selector(bgButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.hidden = YES;
        self.setView = [[QTabbarSetView alloc] initWithFrame:CGRectMake(0, self.bgButton.height - 120, UI_SCREEN_WIDTH, 120)];
        self.setView.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
        [_bgButton addSubview:self.setView];
        [self.view addSubview:_bgButton];
    }
    return _bgButton;
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
    
