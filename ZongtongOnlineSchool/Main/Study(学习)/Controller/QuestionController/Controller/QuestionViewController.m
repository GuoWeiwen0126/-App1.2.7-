//
//  QuestionViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionViewController.h"
#import "Tools.h"
#import "QuestionModel.h"
#import "QuestionManager.h"
#import "MistakeCollectManager.h"
#import "QuestionTabbar.h"
#import "QTabbarSetView.h"
#import "QuestionNoteView.h"
#import "QuestionTypeView.h"
#import "QuestionCollectionView.h"
#import "TestReportViewController.h"
#import "QuestionCardViewController.h"
#import "QuestionFeedbackViewController.h"
#import "QuestionOtherNoteViewController.h"
#import "VideoManager.h"
#import "AppTypeManager.h"
#import "VideoDetailModel.h"
#import "ALiVideoPlayViewController.h"

@interface QuestionViewController () <QuestionCollectionViewDelegate, QuestionTabbarDelegate, QuestionCardDelegate, QTypeViewDelegate, TestReportVCDelegate>
{
    NSInteger _nowPage;   //当前是第几页
    NSInteger _pageSize;  //每页数据容量
    NSInteger _maxPage;   //最大页数
    NSInteger _rowCount;  //数据总数
    
    NSMutableArray *_qCardArray; //答题卡数据
    NSInteger _seconds;          //计时器秒数
}
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) QTabbarSetView *setView;
@property (nonatomic, strong) QuestionTabbar *qTabbar;
@property (nonatomic, strong) QuestionNoteView *noteView;
@property (nonatomic, strong) QuestionTypeView *qTypeView;
@property (nonatomic, strong) QuestionCollectionView *collectionView;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation QuestionViewController
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
    
    if (self.VCType == MistakeVCType || self.VCType == CollectVCType || self.VCType == QNoteVCType) {
        //获取收藏信息
        [self getCollectInfoWithArray:self.dataArray];
    } else if (self.VCType == HistoryExerciseVCType) {
        if (self.isRandomType) {
            //随机抽题 - 某些题信息
            [self getSomeQuestionInfoWithQidJson:self.qExerinfoModel.qidJson title:@""];
        } else {
            //继续做题
            _seconds = self.qExerinfoModel.useTime;
            [self continueDoExerciseWithArray:self.dataArray vcType:self.VCType];
        }
    } else if (self.VCType == HistoryTestReportVCType) {
        //测试报告查看解析
        [self testReportVCPopAndCheckAnalyseWithAnalyseArray:self.dataArray analyseType:self.analyseType];
    } else if (self.VCType == RandomListVCType) {
        //从题库随机获取列表
        [self getRandomListQuestionData];
    } else {
        //获取整套试题
        [self getQuestionBasicPageData];
    }
}
#pragma mark - 创建UI
- (void)createUI
{
    self.view.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
    //设置默认字体大小
    [USER_DEFAULTS setFloat:14.0f forKey:QLabelFont];
    [USER_DEFAULTS synchronize];
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:(self.VCType == MistakeVCType || self.VCType == CollectVCType || self.VCType == QNoteVCType) ? 18.0f:14.0f leftBtnTitle:@"back.png" rightBtnTitle:@"xuanxiang.png" bgColor:[USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_Navigationbar:MAIN_RGB];
    [self.navigationBar.titlebutton addTarget:self action:@selector(baseNaviButtonClickedWithBtnType:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark -
#pragma mark - 获取数据
#pragma mark - 获取整套试题
- (void)getQuestionBasicPageData
{
    _nowPage = 1;
    _pageSize = 50;
    NSMutableArray *netDataArray = [NSMutableArray arrayWithCapacity:10];
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取整套试题" iconName:LoadingImage iconNumber:4];
    [QuestionManager QuestionManagerBasicPageWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] sid:[NSString stringWithFormat:@"%ld",(long)self.sid] page:[NSString stringWithFormat:@"%ld",(long)_nowPage] pagesize:[NSString stringWithFormat:@"%ld",(long)_pageSize] completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dataDic = (NSDictionary *)obj;
            _nowPage = [dataDic[@"NowPage"] integerValue];
            _pageSize = [dataDic[@"PageSize"] integerValue];
            _maxPage = [dataDic[@"MaxPage"] integerValue];
            _rowCount = [dataDic[@"RowCount"] integerValue];
            if (_maxPage < 2) {  //数据少于一页
                for (NSDictionary *dic in dataDic[@"List"]) {
                    QuestionModel *qModel = [QuestionModel yy_modelWithDictionary:dic];
                    [netDataArray addObject:qModel];
                }
                //获取章节收藏信息
                [self getQidCollectListWithArray:netDataArray];
            } else {  //数据多于一页
                /*** ***  利用信号量预防For循环内发送请求出现数据顺序混乱的情况  *** ***/
                //创建一个全局队列
                dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
                //创建一个信号量(0)
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                dispatch_async(queue, ^ {
                    /* * * 遍历获取到全部的数据 * * */
                    for (NSInteger i = 1; i < _maxPage+1; i ++)
                    {
                        [QuestionManager QuestionManagerBasicPageWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] sid:[NSString stringWithFormat:@"%ld",(long)self.sid] page:[NSString stringWithFormat:@"%ld",(long)i] pagesize:[NSString stringWithFormat:@"%ld",(long)_pageSize] completed:^(id obj) {
                            if (obj != nil) {
                                NSDictionary *dataDic = (NSDictionary *)obj;
                                for (NSDictionary *dic in dataDic[@"List"]) {
                                    QuestionModel *qModel = [QuestionModel yy_modelWithDictionary:dic]; 
                                    [netDataArray addObject:qModel];
                                }
                                if (netDataArray.count == _rowCount) {
                                    //获取章节收藏信息
                                    [self getQidCollectListWithArray:netDataArray];
                                }
                            }
                            //信号量加 1
                            dispatch_semaphore_signal(semaphore);
                        }];
                        //信号量减 1
                        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                    }
                });
            }
        }
    }];
}
#pragma mark - 随机抽题 - 从题库随机获取列表
- (void)getRandomListQuestionData
{
//    [QuestionManager QuestionManagerRandomListWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:@"0" rowcount:@"0" completed:^(id obj) {
//        NSMutableArray *netDataArray = [NSMutableArray arrayWithCapacity:10];
//        for (NSDictionary *dic in (NSArray *)obj) {
//            QuestionModel *qModel = [QuestionModel yy_modelWithDictionary:dic];
//            [netDataArray addObject:qModel];
//        }
//        self.nowQIndex = 0;
//        self.qExerinfoModel = [[QExerinfoModel alloc] init];
//        //开新试卷
//        [self addNewPaperWithArray:netDataArray];
//    }];
    //随机抽题
    [QuestionManager QuestionManagerRandomExerinfoWithEiid:[USER_DEFAULTS objectForKey:EIID] courseid:[USER_DEFAULTS objectForKey:COURSEID] completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            //某些题信息
            [self getSomeQuestionInfoWithQidJson:dic[@"qidJson"] title:dic[@"title"]];
        }
    }];
}
#pragma mark - 随机抽题 - 某些题信息
- (void)getSomeQuestionInfoWithQidJson:(NSString *)qidJson title:(NSString *)title
{
    [MistakeCollectManager mistakeCollectQuestionBasicListWithQidList:qidJson completed:^(id obj) {
        if (obj != nil) {
            NSMutableArray *netDataArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *temDic in (NSArray *)obj) {
                QuestionModel *qModel = [QuestionModel yy_modelWithDictionary:temDic];
                [netDataArray addObject:qModel];
            }
            if (self.isRandomType && self.VCType == HistoryExerciseVCType) {
                [self continueDoExerciseWithArray:netDataArray vcType:self.VCType];
            } else {
                //新开试卷(新)
                [self addRandomNewPaperWithArray:netDataArray qidJson:qidJson title:title];
            }
        }
    }];
}
#pragma mark - 随机抽题 - 新开试卷(新)
- (void)addRandomNewPaperWithArray:(NSMutableArray *)array qidJson:(NSString *)qidJson title:(NSString *)title
{
    [QuestionManager QuestionManagerAddExerciseRulesWithUid:[USER_DEFAULTS objectForKey:User_uid] courserid:[USER_DEFAULTS objectForKey:COURSEID] title:title hcType:@"17" qidJson:qidJson completed:^(id obj) {
        if (obj != nil) {
            self.qExerinfoModel = [[QExerinfoModel alloc] init];
            for (QuestionModel *qModel in array) {
                qModel.isWrite = NO;
                self.qExerinfoModel.eid = [obj integerValue];
                qModel.qExerinfoBasicModel = [QExerinfoBasicModel yy_modelWithDictionary:@{@"uAnswer":@"", @"eid":(NSString *)obj, @"eiid":@"0"}];
            }
            self.nowQIndex = 0;
            //Qid收藏验证
            [self getCollectInfoWithArray:array];
        }
    }];
}
#pragma mark - 获取章节收藏信息
- (void)getQidCollectListWithArray:(NSMutableArray *)array
{
    [QuestionManager QuestionManagerQidCollectListWithUid:[USER_DEFAULTS objectForKey:User_uid] sid:[NSString stringWithFormat:@"%ld",(long)self.sid] completed:^(id obj) {
        if (obj != nil) {
            NSArray *collectArray = (NSArray *)obj;
            for (NSString *qidStr in collectArray) {
                for (QuestionModel *qModel in array) {
                    if (qModel.qid == [qidStr integerValue]) {
                        qModel.isCollect = YES;
                    }
                }
            }
            //获取章节试卷信息
            [self getUserExerinfoWithArray:array];
        }
    }];
}
#pragma mark - 获取章节试卷信息
- (void)getUserExerinfoWithArray:(NSMutableArray *)array
{
    [QuestionManager QuestionManagerUserExerinfoWithUid:[USER_DEFAULTS objectForKey:User_uid] sid:[NSString stringWithFormat:@"%ld",(long)self.sid] completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            //修改试卷信息
            self.qExerinfoModel = [QExerinfoModel yy_modelWithDictionary:dic];
            if ([dic[@"userExerList"] count] == 0) {
                //开新试卷
                _seconds = 0;
                [self addNewPaperWithArray:array];
            }
            else {
                //弹出提示（开新卷 or 继续做题）
                [XZCustomWaitingView hideWaitingMaskView];
                [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"是否继续做题？" cancelButtonTitle:@"开新试卷" otherButtonTitle:@"继续做题" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                    if (buttonIndex == XZAlertViewBtnTagCancel) {
                        _seconds = 0;
                        //开新试卷
                        [self addNewPaperWithArray:array];
                    } else {
                        [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取试卷信息" iconName:LoadingImage iconNumber:4];
                        //继续做题
                        _seconds = self.qExerinfoModel.useTime;
                        [self continueDoExerciseWithArray:array vcType:self.VCType];
                    }
                }];
            }
        }
    }];
}
#pragma mark - 开新试卷
- (void)addNewPaperWithArray:(NSMutableArray *)array
{
    [QuestionManager QuestionManagerAddExerciseWithCourserid:[USER_DEFAULTS objectForKey:COURSEID] sid:[NSString stringWithFormat:@"%ld",(long)self.sid] uid:[USER_DEFAULTS objectForKey:User_uid] title:self.naviTitle qidJson:[QuestionManager QuestionManagerConfigQidJsonWithArray:array] completed:^(id obj) {
        if (obj != nil) {
            for (QuestionModel *qModel in array) {
                qModel.isWrite = NO;
                self.qExerinfoModel.eid = [obj integerValue];
                qModel.qExerinfoBasicModel = [QExerinfoBasicModel yy_modelWithDictionary:@{@"uAnswer":@"", @"eid":(NSString *)obj, @"eiid":@"0"}];
            }
            self.nowQIndex = 0;
            //获取题分类
            [self getQuestionTypeWithArray:array];
        }
    }];
}
#pragma mark - 继续做题
- (void)continueDoExerciseWithArray:(NSMutableArray *)array vcType:(QuestionVCType)vcType
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
    if (vcType == HistoryExerciseVCType) {
        //Qid收藏验证
        [self getCollectInfoWithArray:array];
    } else {
        //获取题分类
        [self getQuestionTypeWithArray:array];
    }
}
#pragma mark - Qid收藏验证
- (void)getCollectInfoWithArray:(NSMutableArray *)array
{
    NSString *qidList = [QuestionManager QuestionManagerConfigQidJsonWithArray:array];
    [QuestionManager QuestionManagerQidCollectListWithUid:[USER_DEFAULTS objectForKey:User_uid] qidList:qidList completed:^(id obj) {
        if (obj != nil) {
            NSArray *collectArray = (NSArray *)obj;
            for (QuestionModel *qModel in array) {
                if (self.VCType == CollectVCType) {
                    qModel.isCollect = YES;
                } else {
                    for (NSString *qidStr in collectArray) {
                        if (qModel.qid == [qidStr integerValue]) {
                            qModel.isCollect = YES;
                        }
                    }
                }
            }
            //获取题分类
            [self getQuestionTypeWithArray:array];
        }
    }];
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
        if (self.VCType == MistakeVCType || self.VCType == CollectVCType) {
            break;
        }
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
    //获取云笔记点赞记录
    [self getUserNotePraiseListWithArray:array];
}
#pragma mark - 获取云笔记点赞记录
- (void)getUserNotePraiseListWithArray:(NSMutableArray *)array
{
    [QuestionManager QuestionManagerQNotePraiseListWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
        if (obj != nil) {
            if (!self.notePraiseArray) {
                self.notePraiseArray = [NSArray arrayWithArray:(NSArray *)obj];
            }
            //collectionView布局
            [self configCollectionViewWithDataArray:array];
        }
    }];
}
#pragma mark - collectionView布局
- (void)configCollectionViewWithDataArray:(NSMutableArray *)dataArray
{
    [XZCustomWaitingView hideWaitingMaskView];
    
    //添加通知
    [self registerNotification];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-self.navigationBar.height-self.qTypeView.height-self.qTabbar.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[QuestionCollectionView alloc] initWithFrame:CGRectMake(0, self.qTypeView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-self.navigationBar.height-self.qTypeView.height-self.qTabbar.height) collectionViewLayout:layout];
    self.collectionView.collectionDataArray = dataArray;
    self.collectionView.collectionViewDelegate = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.width*self.nowQIndex, 0) animated:NO];
    //刷新qTypeView、qTabbar
    QuestionModel *nowQModel = self.collectionView.collectionDataArray[self.nowQIndex];
    [self.qTypeView refreshQtypeViewWithQType:nowQModel.qTypeListModel.title qNumber:[NSString stringWithFormat:@"%ld/%ld",self.nowQIndex+1,dataArray.count]];
    [self.qTabbar qTabbarRefreshCollectBtnWithCollectState:nowQModel.isCollect];
    [self.view bringSubviewToFront:self.qTabbar];
    [self.view bringSubviewToFront:self.bgButton];
    
    //启动定时器
    if ([USER_DEFAULTS boolForKey:Question_IsAnalyse] == NO && [[USER_DEFAULTS objectForKey:Question_Mode] integerValue] == 1 && self.VCType != RandomListVCType) {
        if (self.timer) {
            [self.timer setFireDate:[NSDate distantPast]];
        }
    }
}
#pragma mark - 注册通知
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuestionShareToFriend:) name:@"QuestionShareToFriend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuestionGoToFeedback) name:@"QuestionGoToFeedback" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DanOrPanOptionClicked) name:@"DanOrPanOptionClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuestionUpUserAnswer:) name:@"QuestionUpUserAnswer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoteCellButtonClicked:) name:@"NoteCellButtonClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuestionAddNoteText:) name:@"QuestionAddNoteText" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoteCellContentLabelClicked) name:@"NoteCellContentLabelClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuestionUpdateNoteText:) name:@"QuestionUpdateNoteText" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoteCellRemoveNote) name:@"NoteCellRemoveNote" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoteCellPraiseBtnClicked) name:@"NoteCellPraiseBtnClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QTabbarSetViewBtnClicked:) name:@"QTabbarSetViewBtnClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoCellVideoBtnClicked) name:@"VideoCellVideoBtnClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LookAnalyseBtnClicked) name:@"LookAnalyseBtnClicked" object:nil];
}
#pragma mark - 定时器计时
- (void)timerCountdown
{
    _seconds ++;
    NSInteger hour   = _seconds/3600;
    NSInteger minute = (_seconds%3600)/60;
    NSInteger second = _seconds%60;
    [self.qTypeView.timerButton setTitle:[NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second] forState:UIControlStateNormal];
    if (_seconds%30 == 0) {  //每30秒，保存一次考试信息
        if (self.VCType != MistakeVCType && self.VCType != CollectVCType) {
            [self QuestionUpExerWithIsPop:NO];
        }
    }
}

#pragma mark -
#pragma mark - 通知方法
#pragma mark - 查看解析
- (void)LookAnalyseBtnClicked
{
    QuestionModel *nowQModel = self.collectionView.collectionDataArray[self.nowQIndex];
    nowQModel.isLookAnswer = !nowQModel.isLookAnswer;
    [self.collectionView reloadData];
}
#pragma mark - 考朋友
- (void)QuestionShareToFriend:(NSNotification *)noti
{
    //显示分享面板
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_QQ)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"分享平台：%ld",(long)platformType);
        [self shareWebPageToPlatformType:platformType qModel:(QuestionModel *)noti.object];
    }];
}
#pragma mark - 分享功能
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType qModel:(QuestionModel *)qModel
{
    UMSocialMessageObject *shareMessage = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@（%@）",[USER_DEFAULTS objectForKey:EIIDNAME],qModel.qTypeListModel.title] descr:@"我在总统网校遇到一道题，考考你吧。" thumImage:nil];
    shareObject.webpageUrl = ShareQInfoURL([USER_DEFAULTS objectForKey:EIID], (long)qModel.qid);
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
#pragma mark - 问题反馈按钮
- (void)QuestionGoToFeedback
{
    QuestionFeedbackViewController *qFeedbackVC = [[QuestionFeedbackViewController alloc] init];
    QuestionModel *nowQModel = self.collectionView.collectionDataArray[self.nowQIndex];
    qFeedbackVC.sid = nowQModel.sid;
    qFeedbackVC.qid = nowQModel.qid;
    [self presentViewController:qFeedbackVC animated:YES completion:nil];
}
#pragma mark - 单选、判断点击选项
- (void)DanOrPanOptionClicked
{
    if ([USER_DEFAULTS integerForKey:Question_Mode] != 0) {
        //调用答题卡点击方法
        if (self.nowQIndex + 1 < self.collectionView.collectionDataArray.count) {
            [self performSelector:@selector(nextQuetion) withObject:nil afterDelay:0.5];
        }
    }
}
- (void)nextQuetion
{
    [self questionCardClickedWithIndex:self.nowQIndex + 1 animated:YES];
}
#pragma mark - 保存答案
- (void)QuestionUpUserAnswer:(NSNotification *)noti
{
    if (self.VCType == MistakeVCType || self.VCType == CollectVCType) {
        return;
    }
    QuestionModel *qModel = (QuestionModel *)noti.object;
    if (self.VCType == RandomListVCType) {
        [QuestionManager QuestionManagerUpUserAnswerWithEiid:[NSString stringWithFormat:@"%ld",(long)qModel.qExerinfoBasicModel.eiid] eid:[NSString stringWithFormat:@"%ld",(long)qModel.qExerinfoBasicModel.eid] uid:[USER_DEFAULTS objectForKey:User_uid] courseid:[NSString stringWithFormat:@"%ld",(long)qModel.courseId] qid:[NSString stringWithFormat:@"%ld",(long)qModel.qid] uAnswer:qModel.qExerinfoBasicModel.uAnswer answer:qModel.answer isRight:[NSString stringWithFormat:@"%ld",(long)qModel.qExerinfoBasicModel.isRight] completed:^(id obj) {
            if (obj != nil) {
                qModel.qExerinfoBasicModel.eiid = [obj integerValue];
            }
        }];
    } else {
        [QuestionManager QuestionManagerUpUserAnswerWithEiid:[NSString stringWithFormat:@"%ld",(long)qModel.qExerinfoBasicModel.eiid] eid:[NSString stringWithFormat:@"%ld",(long)qModel.qExerinfoBasicModel.eid] uid:[USER_DEFAULTS objectForKey:User_uid] courseid:[NSString stringWithFormat:@"%ld",(long)qModel.courseId] sid:[NSString stringWithFormat:@"%ld",(long)qModel.sid] qid:[NSString stringWithFormat:@"%ld",(long)qModel.qid] uAnswer:qModel.qExerinfoBasicModel.uAnswer answer:qModel.answer isRight:[NSString stringWithFormat:@"%ld",(long)qModel.qExerinfoBasicModel.isRight] completed:^(id obj) {
            if (obj != nil) {
                qModel.qExerinfoBasicModel.eiid = [obj integerValue];
            }
        }];
    }
}
#pragma mark - 保存考试信息
- (void)QuestionUpExerWithIsPop:(BOOL)isPop
{
    self.qExerinfoModel.useTime = _seconds;
    self.qExerinfoModel.rightNum = 0;
    self.qExerinfoModel.mistakeNum = 0;
    self.qExerinfoModel.userScore = @"0";
    NSInteger doCount = 0;
    for (QuestionModel *qModel in self.collectionView.collectionDataArray) {
        self.qExerinfoModel = [QuestionManager QuestionManagerUpdateExerinfoWithQExerinfoModel:self.qExerinfoModel qModel:qModel];
        if (qModel.isWrite == YES) {
            doCount ++;
        }
    }
    NSLog(@"当前用户得分：---%f---",[self.qExerinfoModel.userScore floatValue]);
    QuestionModel *nowQModel = self.collectionView.collectionDataArray[self.nowQIndex];
    //保存考试信息
    [QuestionManager QuestionManagerUpExerWithEid:[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.eid] uid:[USER_DEFAULTS objectForKey:User_uid] useTime:[NSString stringWithFormat:@"%ld",(long)_seconds] rightNum:[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.rightNum] mistakeNum:[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.mistakeNum] userScore:[NSString stringWithFormat:@"%@",self.qExerinfoModel.userScore] nowQid:[NSString stringWithFormat:@"%ld",(long)nowQModel.qid] doCount:[NSString stringWithFormat:@"%ld",(long)doCount] completed:^(id obj) {
        if (isPop) {
            [XZCustomWaitingView hideWaitingMaskView];
            [self popController];
        }
    }];
}
#pragma mark - 笔记按钮点击（查看个人笔记、添加笔记、查看他人笔记）
- (void)NoteCellButtonClicked:(NSNotification *)noti
{
    QuestionModel *qModel = self.collectionView.collectionDataArray[self.nowQIndex];
    switch ([noti.object integerValue]) {
        case 10: {  //查看个人笔记
            if (!qModel.qNoteModel) {
                [self getQuestionNoteWithNowQModel:qModel isAddNote:NO];
            }
        }
            break;
        case 11: {  //添加笔记
            if (self.noteView.hidden == YES) {
                self.noteView.hidden = NO;
                self.noteView.state = AddNote;
                self.noteView.noteTextView.text = qModel.qNoteModel.content;
            }
        }
            break;
        case 12: {  //查看他人笔记
            QuestionOtherNoteViewController *otherNoteVC = [[QuestionOtherNoteViewController alloc] init];
            otherNoteVC.qid = qModel.qid;
            [self.navigationController pushViewController:otherNoteVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 添加云笔记
- (void)QuestionAddNoteText:(NSNotification *)noti
{
    QuestionModel *qModel = self.collectionView.collectionDataArray[self.nowQIndex];
    [QuestionManager QuestionManagerQNoteAddNoteWithCourseid:[NSString stringWithFormat:@"%ld",(long)qModel.courseId] sid:[NSString stringWithFormat:@"%ld",(long)qModel.sid] qid:[NSString stringWithFormat:@"%ld",(long)qModel.qid] uid:[USER_DEFAULTS objectForKey:User_uid] content:noti.object completed:^(id obj) {
        if (obj != nil) {  //添加成功后，重新获取该题云笔记
            [self getQuestionNoteWithNowQModel:qModel isAddNote:YES];
        }
    }];
}
#pragma mark - 点击云笔记Label
- (void)NoteCellContentLabelClicked
{
    if (self.noteView.hidden == YES) {
        self.noteView.hidden = NO;
        self.noteView.state = UpdateNote;
        QuestionModel *qModel = self.collectionView.collectionDataArray[self.nowQIndex];
        self.noteView.noteTextView.text = qModel.qNoteModel.content;
    }
}
#pragma mark - 修改云笔记
- (void)QuestionUpdateNoteText:(NSNotification *)noti
{
    QuestionModel *qModel = self.collectionView.collectionDataArray[self.nowQIndex];
    [QuestionManager QuestionManagerQNoteUpdateNoteWithNid:[NSString stringWithFormat:@"%ld",(long)qModel.qNoteModel.nid] uid:[USER_DEFAULTS objectForKey:User_uid] content:noti.object completed:^(id obj) {
        if (obj != nil) {  //修改成功后，重新获取该题云笔记
            [self getQuestionNoteWithNowQModel:qModel isAddNote:NO];
        }
    }];
}
#pragma mark - 删除云笔记
- (void)NoteCellRemoveNote
{
    QuestionModel *qModel = self.collectionView.collectionDataArray[self.nowQIndex];
    [QuestionManager QuestionManagerQNoteRemoveNoteWithNid:[NSString stringWithFormat:@"%ld",(long)qModel.qNoteModel.nid] uid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *noteDic = [NSDictionary dictionaryWithObject:@"1" forKey:@"isNoteLook"];
            qModel.qNoteModel = [QNoteModel yy_modelWithDictionary:noteDic];
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.nowQIndex inSection:0]]];
            [self.collectionView.cell.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            if (self.VCType == QNoteVCType) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteUserNoteAndReloadData" object:[NSString stringWithFormat:@"%ld",(long)qModel.qid]];
            }
        }
    }];
}
#pragma mark - 点赞云笔记
- (void)NoteCellPraiseBtnClicked
{
    QuestionModel *qModel = self.collectionView.collectionDataArray[self.nowQIndex];
    [QuestionManager QuestionManagerQNotePraiseNoteWithNid:[NSString stringWithFormat:@"%ld",(long)qModel.qNoteModel.nid] uid:[USER_DEFAULTS objectForKey:User_uid]];
}
#pragma mark - 获取该题云笔记
- (void)getQuestionNoteWithNowQModel:(QuestionModel *)nowQModel isAddNote:(BOOL)isAddNote
{
    [QuestionManager QuestionManagerQNoteBasicInfoWithCourseid:[NSString stringWithFormat:@"%ld",(long)nowQModel.courseId] qid:[NSString stringWithFormat:@"%ld",(long)nowQModel.qid] uid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
        if (obj != nil) {
            NSMutableDictionary *noteDic = (NSMutableDictionary *)obj;
            [noteDic setObject:@"1" forKey:@"isNoteLook"];
            if (isAddNote == NO) {
                for (NSString *nidStr in self.notePraiseArray) {
                    if ([nidStr integerValue] == [noteDic[@"nid"] integerValue]) {
                        [noteDic setObject:@"1" forKey:@"isNotePraise"];
                    }
                }
            }
            nowQModel.qNoteModel = [QNoteModel yy_modelWithDictionary:noteDic];
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.nowQIndex inSection:0]]];
            [self.collectionView.cell.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
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
                self.noteView.noteBgView.backgroundColor = [UIColor whiteColor];
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
                self.noteView.noteBgView.backgroundColor = Night_RGB_BGColor;
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
                        [self getQuestionVideoDetailWithQModel:qModel];
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
- (void)getQuestionVideoDetailWithQModel:(QuestionModel *)qModel
{
    //视频详情
    [VideoManager videoManagerBasicWithCourseid:[NSString stringWithFormat:@"%ld",(long)qModel.courseId] uid:[USER_DEFAULTS objectForKey:User_uid] vid:[NSString stringWithFormat:@"%ld",(long)qModel.qVideModel.qvid] completed:^(id obj) {
        if (obj != nil) {
            ALiVideoPlayViewController *videoPlayVC = [[ALiVideoPlayViewController alloc] init];
            videoPlayVC.vcType = QuestionVideoType;
            videoPlayVC.qid = [NSString stringWithFormat:@"%ld",(long)qModel.qid];
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
#pragma mark - QTypeViewDelegate（弹出倒计时提示）
- (void)qTypeViewTimerClicked
{
    [self.timer setFireDate:[NSDate distantFuture]];
    [XZCustomViewManager showSystemAlertViewWithTitle:@"休息一下" message:[NSString stringWithFormat:@"已用时%@",self.qTypeView.timerButton.titleLabel.text] cancelButtonTitle:@"继续做题" otherButtonTitle:@"" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
        [self.timer setFireDate:[NSDate distantPast]];
    }];
}
#pragma mark - collectionView（collectionView滑动停止）
- (void)questionCollectionViewScrollWithNowQModel:(QuestionModel *)nowQModel nowIndex:(NSInteger)nowIndex
{
    self.nowQIndex = nowIndex;
    nowQModel.isWrite = YES;
    [self.qTypeView refreshQtypeViewWithQType:nowQModel.qTypeListModel.title qNumber:[NSString stringWithFormat:@"%ld/%.0f",(long)nowIndex+1,self.collectionView.contentSize.width/self.collectionView.width]];
    [self.qTabbar qTabbarRefreshCollectBtnWithCollectState:nowQModel.isCollect];
}
#pragma mark - QuestionCardDelegate（答题卡点击）
- (void)questionCardClickedWithIndex:(NSInteger)index animated:(BOOL)animated
{
    self.nowQIndex = index;
    QuestionModel *nowQModel = self.collectionView.collectionDataArray[self.nowQIndex];
    nowQModel.isWrite = YES;
    [self.qTypeView refreshQtypeViewWithQType:nowQModel.qTypeListModel.title qNumber:[NSString stringWithFormat:@"%ld/%.0f",(long)index+1,self.collectionView.contentSize.width/self.collectionView.width]];
    [self.qTabbar qTabbarRefreshCollectBtnWithCollectState:nowQModel.isCollect];
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.width*index, 0) animated:animated];
}
#pragma mark - 答题卡切换页数
- (void)questionCardPageChangedWithArray:(NSMutableArray *)array page:(NSInteger)page
{
    if (self.VCType == MistakeVCType) {
        [_qTabbar createTabbarButtonWithTitleArray:@[@"收藏", @"答题卡", @"移除错题"] ImgArray:@[@"shouchang1.png", @"datika.png", @"shanchu.png"]];
    } else if (self.VCType == CollectVCType) {
        [_qTabbar createTabbarButtonWithTitleArray:@[@"收藏", @"答题卡"] ImgArray:@[@"shouchang1.png", @"datika.png"]];
    }
    
    //移除答题卡数据
    [_qCardArray removeAllObjects];
    //先移除、再配置 collectionView
    self.nowQIndex = 0;
    [self.collectionView removeFromSuperview];
    //获取收藏信息
    [self getCollectInfoWithArray:array];
    
    self.temPage = page;
}
#pragma mark - QuestionTabbarDelegate（底部tabbar点击）
- (void)QuestionTabbarClickedWithTag:(NSInteger)tag
{
    switch (tag)
    {
        case BottomCollect: //收藏
        {
            QuestionModel *nowQModel = self.collectionView.collectionDataArray[self.nowQIndex];
            [QuestionManager QuestionManagerCollectWithCourserid:[NSString stringWithFormat:@"%ld",(long)nowQModel.courseId] sid:[NSString stringWithFormat:@"%ld",(long)nowQModel.sid] qid:[NSString stringWithFormat:@"%ld",(long)nowQModel.qid] uid:[USER_DEFAULTS objectForKey:User_uid] isCollect:nowQModel.isCollect completed:^(id obj) {
                nowQModel.isCollect = !nowQModel.isCollect;
                [self.qTabbar qTabbarRefreshCollectBtnWithCollectState:nowQModel.isCollect];
            }];
            if (self.VCType == CollectVCType) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MistakeCollectRemoveQuestion" object:nowQModel];
            }
        }
            break;
        case BottomQCard:   //答题卡
        {
            QuestionCardViewController *qCardVC = [[QuestionCardViewController alloc] init];
            if (_qCardArray.count == 0 || self.VCType == MistakeVCType || self.VCType == CollectVCType)
            {
                [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取答题卡信息" iconName:LoadingImage iconNumber:4];
                _qCardArray = [QuestionManager QuestionManagerGetQCardArrayWithArray:self.collectionView.collectionDataArray];
                [XZCustomWaitingView hideWaitingMaskView];
            }
            qCardVC.qCardArray = _qCardArray;
            qCardVC.qCardDelegate = self;
            if (self.VCType == MistakeVCType || self.VCType == CollectVCType) {
                qCardVC.isMistakeCollect = YES;
                qCardVC.VCType = self.VCType == MistakeVCType ? QcardMistakeType:QcardCollectType;
                qCardVC.page = self.temPage;
                qCardVC.pagesize = self.temPagesize;
                qCardVC.maxPage = self.temMaxPage;
            }
            [self presentViewController:qCardVC animated:YES completion:nil];
        }
            break;
            //            case BottomSetting: //设置
            //            {
            //                if (self.bgButton.hidden == YES) {
            //                    self.bgButton.hidden = NO;
            //                    [UIView animateWithDuration:0.1 animations:^{
            //                        self.qTabbarSet.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 50*2, UI_SCREEN_WIDTH, 50);
            //                    }];
            //                } else {
            //                    [self bgButtonClicked];
            //                }
            //            }
            //                break;
        case BottomHandIn:  //提交试卷、移除错题
        {
            if (self.VCType == MistakeVCType) {
                [self deleteMistakeQuestion];
            } else {
                [self submitPaper];
            }
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 提交试卷
- (void)submitPaper
{
    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"请您检查无误后，再提交试卷" cancelButtonTitle:@"返回做题" otherButtonTitle:@"确认交卷" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
        if (buttonIndex == XZAlertViewBtnTagSure) {  //销毁定时器、移除通知
            [self.timer invalidate];
            self.timer = nil;
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            //更新试卷信息， 拼接对、错题的qid
            self.qExerinfoModel.useTime = _seconds;
            self.qExerinfoModel.rightNum = 0;
            self.qExerinfoModel.mistakeNum = 0;
            self.qExerinfoModel.userScore = @"0";
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
            if (self.VCType == RandomListVCType) {
                [QuestionManager QuestionManagerExerOverWithCourserid:[USER_DEFAULTS objectForKey:COURSEID] eid:[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.eid] uid:[USER_DEFAULTS objectForKey:User_uid] useTime:[NSString stringWithFormat:@"%ld",(long)_seconds] rightNum:[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.rightNum] mistakeNum:[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.mistakeNum] userScore:self.qExerinfoModel.userScore nowQid:[NSString stringWithFormat:@"%ld",(long)nowQModel.qid] rightQids:rightQidJson mistakeQids:mistakeQidJson doCount:[NSString stringWithFormat:@"%ld",(long)doCount] completed:^(id obj) {
                    if (obj != nil) {
                        NSLog(@"随机抽题交卷成功");
                        TestReportViewController *testReportVC = [[TestReportViewController alloc] init];
                        testReportVC.testReportDelegate = self;
                        testReportVC.dataArray = [NSMutableArray arrayWithArray:self.collectionView.collectionDataArray];
                        testReportVC.qExerinfoModel = self.qExerinfoModel;
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"MM-dd HH:mm"];
                        testReportVC.submitTimeStr = [NSString stringWithFormat:@"%@\n提交时间",[formatter stringFromDate:[NSDate date]]];
//                        testReportVC.totalScore = totalScore;
                        [USER_DEFAULTS setBool:YES forKey:Question_IsAnalyse];
                        [USER_DEFAULTS synchronize];
                        [self.navigationController pushViewController:testReportVC animated:YES];
                    }
                }];
            } else {
                [QuestionManager QuestionManagerExerOverWithCourserid:[NSString stringWithFormat:@"%ld",(long)nowQModel.courseId] sid:[NSString stringWithFormat:@"%ld",(long)nowQModel.sid] eid:[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.eid] uid:[USER_DEFAULTS objectForKey:User_uid] useTime:[NSString stringWithFormat:@"%ld",(long)_seconds] rightNum:[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.rightNum] mistakeNum:[NSString stringWithFormat:@"%ld",(long)self.qExerinfoModel.mistakeNum] userScore:self.qExerinfoModel.userScore nowQid:[NSString stringWithFormat:@"%ld",(long)nowQModel.qid] rightQids:rightQidJson mistakeQids:mistakeQidJson doCount:[NSString stringWithFormat:@"%ld",(long)doCount] completed:^(id obj) {
                    if (obj != nil) {
                        NSLog(@"交卷成功");
                        TestReportViewController *testReportVC = [[TestReportViewController alloc] init];
                        testReportVC.testReportDelegate = self;
                        testReportVC.dataArray = [NSMutableArray arrayWithArray:self.collectionView.collectionDataArray];
                        testReportVC.qExerinfoModel = self.qExerinfoModel;
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"MM-dd HH:mm"];
                        testReportVC.submitTimeStr = [NSString stringWithFormat:@"%@\n提交时间",[formatter stringFromDate:[NSDate date]]];
//                        testReportVC.totalScore = totalScore;
                        [USER_DEFAULTS setBool:YES forKey:Question_IsAnalyse];
                        [USER_DEFAULTS synchronize];
                        [self.navigationController pushViewController:testReportVC animated:YES];
                    }
                }];
            }
        }
    }];
}
#pragma mark - 移除错题
- (void)deleteMistakeQuestion
{
    QuestionModel *qModel = self.collectionView.collectionDataArray[self.nowQIndex];
    [QuestionManager QuestionManagerRemoveMistakeWithUid:[USER_DEFAULTS objectForKey:User_uid] qid:[NSString stringWithFormat:@"%ld",(long)qModel.qid]];
    [XZCustomWaitingView showAutoHidePromptView:@"移除成功" background:nil showTime:1.0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MistakeCollectRemoveQuestion" object:qModel];
    if (self.collectionView.collectionDataArray.count == 1) {
        [self popController];
        return;
    }
    [self.collectionView.collectionDataArray removeObjectAtIndex:self.nowQIndex];
    [self.collectionView reloadData];
    for (int i = 0; i < self.collectionView.collectionDataArray.count; i ++) {
        QuestionModel *temModel = self.collectionView.collectionDataArray[i];
        temModel.qIndex = i;
    }
    if (self.nowQIndex >= self.collectionView.collectionDataArray.count - 1) {
        self.nowQIndex = self.collectionView.collectionDataArray.count - 1;
    }
    //刷新qTypeView、qTabbar
    QuestionModel *nowQModel = self.collectionView.collectionDataArray[self.nowQIndex];
    [self.qTypeView refreshQtypeViewWithQType:nowQModel.qTypeListModel.title qNumber:[NSString stringWithFormat:@"%ld/%ld",self.nowQIndex+1,self.collectionView.collectionDataArray.count]];
    [self.qTabbar qTabbarRefreshCollectBtnWithCollectState:nowQModel.isCollect];
    NSLog(@"%f",self.collectionView.contentOffset.x/self.collectionView.width);
}
#pragma mark - 测试报告查看解析
- (void)testReportVCPopAndCheckAnalyseWithAnalyseArray:(NSMutableArray *)analyseArray analyseType:(TestReportAnalyseType)analyseType
{
    [XZCustomWaitingView showWaitingMaskView:@"正在获取题目" iconName:LoadingImage iconNumber:4];
    //移除倒计时、新建_qTabbar
    [self.qTypeView.timerButton removeFromSuperview];
    [self.qTabbar createTabbarButtonWithTitleArray:@[@"收藏", @"答题卡"] ImgArray:@[@"shouchang1.png", @"datika.png"]];
    //获取错题数据
    NSMutableArray *newDataArray = [NSMutableArray arrayWithCapacity:10];
    NSInteger mistakeQIndex = 0;
    for (int i = 0; i < analyseArray.count; i ++)
    {
        QuestionModel *qModel = analyseArray[i];
        if (analyseType == CheckAllAnalyse) {
            [newDataArray addObject:qModel];
        } else if (qModel.qExerinfoBasicModel.isRight == 2) {
            qModel.qIndex = mistakeQIndex;
            [newDataArray addObject:qModel];
            mistakeQIndex ++;
        }
    }
    //移除答题卡数据
    [_qCardArray removeAllObjects];
    //先移除、再配置 collectionView
    self.nowQIndex = 0;
    [self.collectionView removeFromSuperview];
    [self configCollectionViewWithDataArray:newDataArray];
}

#pragma mark -
#pragma mark - 背景按钮点击
- (void)bgButtonClicked
{
    self.bgButton.hidden = YES;
//    [UIView animateWithDuration:0.1 animations:^{
//        self.qTabbarSet.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 50, UI_SCREEN_WIDTH, 50);
//    }];
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        if ([USER_DEFAULTS boolForKey:Question_IsAnalyse] == YES || self.VCType == MistakeVCType || self.VCType == CollectVCType) {
            [self popController];
        } else {
            //保存做题记录
            [XZCustomWaitingView showWaitingMaskView:@"正在保存做题记录" iconName:LoadingImage iconNumber:4];
            [self QuestionUpExerWithIsPop:YES];
        }
    } else {
        if (self.bgButton.hidden == YES) {
            self.bgButton.hidden = NO;
//            [UIView animateWithDuration:0.1 animations:^{
//                self.qTabbarSet.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 50*2, UI_SCREEN_WIDTH, 50);
//            }];
        } else {
            [self bgButtonClicked];
        }
    }
}
//#pragma mark - 弹出退出提示
//- (void)showPopAndSaveQuestionInfoAlert
//{
//    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"确认退出，并保存本次做题记录吗？" cancelButtonTitle:@"取消" otherButtonTitle:@"保存并退出" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
//        if (buttonIndex == XZAlertViewBtnTagSure) {
//            //保存做题记录
//            [XZCustomWaitingView showWaitingMaskView:@"正在保存做题记录" iconName:LoadingImage iconNumber:4];
//            [self QuestionUpExerWithIsPop:YES];
//        }
//    }];
//}
#pragma mark - 销毁定时器、移除通知
- (void)popController
{
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [USER_DEFAULTS setBool:NO forKey:Question_IsAnalyse];
    [USER_DEFAULTS synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - 懒加载
- (QuestionTabbar *)qTabbar {
    if (!_qTabbar) {
        _qTabbar = [[QuestionTabbar alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 50, UI_SCREEN_WIDTH, 50) titleArray:@[@"收藏", @"答题卡", @"提交"] imgArray:@[@"shouchang1.png", @"datika.png", @"tijiao.png"]];
        _qTabbar.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:MAIN_RGB_LINE;
        _qTabbar.QTabbarDelegate = self;
        [self.view addSubview:_qTabbar];
        if (self.VCType == MistakeVCType) {
            [_qTabbar createTabbarButtonWithTitleArray:@[@"收藏", @"答题卡", @"移除错题"] ImgArray:@[@"shouchang1.png", @"datika.png", @"shanchu.png"]];
        } else if (self.VCType == CollectVCType || self.VCType == HistoryTestReportVCType || self.VCType == QNoteVCType) {
            [_qTabbar createTabbarButtonWithTitleArray:@[@"收藏", @"答题卡"] ImgArray:@[@"shouchang1.png", @"datika.png"]];
        }
    }
    return _qTabbar;
}
- (QuestionTypeView *)qTypeView {
    if (!_qTypeView) {
        _qTypeView = [[QuestionTypeView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 50)];
        _qTypeView.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
        _qTypeView.qTypeViewDelegate = self;
        if (self.VCType == MistakeVCType || self.VCType == CollectVCType || self.VCType == QNoteVCType || [[USER_DEFAULTS objectForKey:Question_Mode] integerValue] != 1) {
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
//- (QTabbarSetView *)setView {
//    if (!_setView) {
//        _setView = [[QTabbarSetView alloc] initWithFrame:CGRectMake(0, self.bgButton.height - 120, UI_SCREEN_WIDTH, 120)];
//        [self.bgButton addSubview:_setView];
//    }
//    return _setView;
//}
- (QuestionNoteView *)noteView {
    if (!_noteView) {
        _noteView = [[QuestionNoteView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
        _noteView.hidden = YES;
        [self.view addSubview:_noteView];
    }
    return _noteView;
}
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCountdown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
