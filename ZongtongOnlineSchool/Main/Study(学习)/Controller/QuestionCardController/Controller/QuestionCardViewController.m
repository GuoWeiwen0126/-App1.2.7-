//
//  QuestionCardViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/11.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionCardViewController.h"
#import "Tools.h"
#import "QCardTableView.h"
#import "QCardOptionView.h"
#import "QuestionModel.h"
#import "MistakeCollectManager.h"
#import "UserStatisticManager.h"

@interface QuestionCardViewController ()
{
    QCardOptionView *_optionView;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation QuestionCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"答题卡" naviFont:16.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    QCardTableView *tableView = [[QCardTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - (self.isMistakeCollect ? 50:0)) style:UITableViewStyleGrouped qCardArray:self.qCardArray];
    [self.view addSubview:tableView];
    
    if (self.isMistakeCollect) {
        _optionView = [[QCardOptionView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 50, UI_SCREEN_WIDTH, 50)];
        [self.view addSubview:_optionView];
        if (self.maxPage <= 1) {
            _optionView.lastBtn.canClicked = NO;
            _optionView.nextBtn.canClicked = NO;
        } else {
            if (self.page == 1) {
                _optionView.lastBtn.canClicked = NO;
                _optionView.nextBtn.canClicked = YES;
            } else if (self.page == _maxPage) {
                _optionView.lastBtn.canClicked = YES;
                _optionView.nextBtn.canClicked = NO;
            } else {
                _optionView.lastBtn.canClicked = YES;
                _optionView.nextBtn.canClicked = YES;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QCardButtonClicked:) name:@"QCardButtonClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QCardOptionButtonClicked:) name:@"QCardOptionButtonClicked" object:nil];
}
#pragma mark - 答题卡按钮点击方法
- (void)QCardButtonClicked:(NSNotification *)noti
{
    if ([self.qCardDelegate respondsToSelector:@selector(questionCardClickedWithIndex:animated:)])
    {
        [self.qCardDelegate questionCardClickedWithIndex:[noti.object integerValue] animated:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - 上一页、下一页
- (void)QCardOptionButtonClicked:(NSNotification *)noti
{
    switch ([noti.object integerValue]) {
        case 0:  //上一页
        {
            self.page --;
            [self getMistakeOrCollectDataSourceWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] sid:@"0" page:[NSString stringWithFormat:@"%ld",(long)self.page] pagesize:[NSString stringWithFormat:@"%ld",(long)self.pagesize] type:self.VCType];
        }
            break;
        case 1:  //下一页
        {
            self.page ++;
            [self getMistakeOrCollectDataSourceWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] sid:@"0" page:[NSString stringWithFormat:@"%ld",(long)self.page] pagesize:[NSString stringWithFormat:@"%ld",(long)self.pagesize] type:self.VCType];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 获取 错题/收藏 列表
- (void)getMistakeOrCollectDataSourceWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize type:(QcardType)type
{
    [MistakeCollectManager mistakeOrCollectBasicPageWithCourseid:courseid uid:uid sid:sid page:page pagesize:pagesize type:type completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([dic[@"List"] count] == 0) {
                [XZCustomWaitingView hideWaitingMaskView];
                [XZCustomWaitingView showAutoHidePromptView:self.VCType == QcardMistakeType ? @"暂无更多错题":@"暂无更多收藏" background:nil showTime:1.0];
            } else {
                self.dataArray = [NSMutableArray arrayWithCapacity:10];
                //拼接 qidList
                NSString *qidList = @"";
                for (NSDictionary *CollectDic in (NSArray *)dic[@"List"]) {
                    qidList = [qidList stringByAppendingFormat:@"%@,",CollectDic[@"qid"]];
                }
                if (qidList.length > 0) {
                    qidList = [qidList substringToIndex:qidList.length - 1];
                }
                //获取某些题信息
                [MistakeCollectManager mistakeCollectQuestionBasicListWithQidList:qidList completed:^(id obj) {
                    if (obj != nil) {
                        NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:10];
                        for (NSDictionary *dic in (NSArray *)obj) {
                            QuestionModel *qModel = [QuestionModel yy_modelWithDictionary:dic];
                            [temArray addObject:qModel];
                        }
                        //根据 qid 查试题统计
                        [UserStatisticManager userQuestionUserCountWithUid:uid qidJson:qidList completed:^(id obj) {
                            for (NSDictionary *dic in (NSArray *)obj) {
                                UserQModel *userQModel = [UserQModel yy_modelWithDictionary:dic];
                                for (QuestionModel *qModel in temArray) {
                                    if (qModel.qid == userQModel.qid) {
                                        qModel.userQModel = userQModel;
                                        break;
                                    }
                                }
                            }
                            //获取题分类
                            [self getQuestionTypeWithArray:temArray];
                        }];
                    }
                }];
            }
        }
    }];
}
#pragma mark - 获取题分类
- (void)getQuestionTypeWithArray:(NSMutableArray *)netDataArray
{
    NSArray *qTypePlistArray;
    if ([FileDefaultManager fileExistsAtPath:GetFileFullPath(QtypeListPlist)]) {
        qTypePlistArray = [[NSArray alloc] initWithContentsOfFile:GetFileFullPath(QtypeListPlist)];
    }
    for (int i = 0; i < netDataArray.count; i ++) {
        QuestionModel *qModel = netDataArray[i];
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
        [self.dataArray addObject:qModel];
    }
    [XZCustomWaitingView hideWaitingMaskView];
    
    if ([self.qCardDelegate respondsToSelector:@selector(questionCardPageChangedWithArray:page:)]) {
        [self.qCardDelegate questionCardPageChangedWithArray:self.dataArray.mutableCopy page:self.page];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
