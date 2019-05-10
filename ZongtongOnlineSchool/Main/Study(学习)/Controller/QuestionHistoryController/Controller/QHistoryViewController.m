//
//  QHistoryViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/25.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QHistoryViewController.h"
#import "Tools.h"
#import "QHistoryTableView.h"
#import "QHistoryManager.h"
#import "QHistoryModel.h"
#import "QuestionManager.h"
#import "QuestionModel.h"
#import "MistakeCollectManager.h"
#import "QuestionViewController.h"
#import "TestReportViewController.h"

@interface QHistoryViewController () <OptionButtonViewDelegate, QHistoryTableViewDelegate>
{
    NSInteger _page;
    NSInteger _pagesize;
    NSInteger _maxPage;
    NSInteger _rowCount;
    
    NSInteger _nowQIndex;
}
@property (nonatomic, copy)   NSString *state;  //状态（0 正在做题， 1 已经交卷）
@property (nonatomic, strong) OptionButtonView *optionView;
@property (nonatomic, strong) QHistoryTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) QExerinfoModel *qExerinfoModel;
@end

@implementation QHistoryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //获取历史列表
    [self getHistoryListWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] state:self.state page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"练习历史" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    _page = 1;
    _pagesize = 30;
    self.state = @"0";
    self.dataArray = [NSMutableArray arrayWithCapacity:10];
}
#pragma mark - 获取历史列表
- (void)getHistoryListWithCourseid:(NSString *)courseid uid:(NSString *)uid state:(NSString *)state page:(NSString *)page pagesize:(NSString *)pagesize isLoadMore:(BOOL)isLoadMore
{
    [QHistoryManager QHistoryManagerExerListWithCourseid:courseid uid:uid state:state page:page pagesize:pagesize completed:^(id obj) {
        NSDictionary *dic = (NSDictionary *)obj;
        if ([dic[@"List"] count] == 0) {
            [self.dataArray removeAllObjects];
            self.tableView.dataArray = self.dataArray;
            self.tableView.state = [state integerValue];
            [self.tableView reloadData];
            [XZCustomWaitingView hideWaitingMaskView];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [XZCustomWaitingView showAutoHidePromptView:@"暂无更多记录" background:nil showTime:1.0];
            return;
        } else {
            _page     = [dic[@"NowPage"]  integerValue];
            _pagesize = [dic[@"PageSize"] integerValue];
            _maxPage  = [dic[@"MaxPage"]  integerValue];
            _rowCount = [dic[@"RowCount"] integerValue];
            if (isLoadMore == NO) {
                [self.dataArray removeAllObjects];
            }
            NSArray *netDataArray = (NSArray *)dic[@"List"];
            for (NSDictionary *dic in netDataArray) {
                QHistoryModel *model = [QHistoryModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            self.tableView.dataArray = self.dataArray;
            self.tableView.state = [state integerValue];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark - 配置列表
- (void)configTableViewWithArray:(NSMutableArray *)array state:(NSString *)state
{
    
}
#pragma mark - 上拉加载
- (void)mj_LoadMoreWithState:(NSString *)state
{
    [self.tableView.mj_footer beginRefreshing];
    if (self.dataArray.count < _rowCount) //还有剩余数据未加载
    {
        _page ++;
        //获取历史列表
        [self getHistoryListWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] state:self.state page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:YES];
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"已无更多数据" background:nil showTime:1.0];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma marl - 刷新列表
- (void)refreshTableViewWithArray:(NSMutableArray *)array state:(NSString *)state
{
    self.tableView.state = [state integerValue];
    self.tableView.dataArray = array;
    [self.tableView reloadData];
}
#pragma mark - OptionButtonView 代理方法
- (void)optionViewButtonClickedWithBtnTag:(NSInteger)btnTag
{
    if ([self.state integerValue] != btnTag) {
        if ([self.state integerValue] == 0) {
            self.state = @"1";
        } else {
            self.state = @"0";
        }
        _page = 1;
        //获取历史列表
        [self getHistoryListWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] state:self.state page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
    }
}

#pragma mark - tableView 点击 cell
- (void)tableViewCellClickedWithIndex:(NSIndexPath *)indexPath
{
    QHistoryModel *qHisModel = self.dataArray[indexPath.row];
    //获取试卷信息
    [QuestionManager QuestionManagerExerinfoWithUid:[USER_DEFAULTS objectForKey:User_uid] eid:[NSString stringWithFormat:@"%ld",(long)qHisModel.eid] completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            //修改试卷信息
            self.qExerinfoModel = [QExerinfoModel yy_modelWithDictionary:dic];
            if (qHisModel.hcType == 7) {  //万人模考
                [XZCustomWaitingView showAutoHidePromptView:@"请在万人模考中查看考试" background:nil showTime:1.0];
            } else if (qHisModel.hcType == 17) {  //随机抽题（isRepeat：0：重复考试，1：禁止重复考试，2：一月内重复考试）
#warning isRepeat判断
                if ([self.state integerValue] == 0) {  //正在做题
                    QuestionViewController *questionVC = [[QuestionViewController alloc] init];
                    questionVC.naviTitle = qHisModel.title;
                    questionVC.isRandomType = YES;
                    questionVC.qExerinfoModel = self.qExerinfoModel;
                    questionVC.VCType = HistoryExerciseVCType;
                    [USER_DEFAULTS setBool:NO forKey:Question_IsAnalyse];
                    if ([USER_DEFAULTS integerForKey:Question_Mode] == 2) {
                        [USER_DEFAULTS setInteger:1 forKey:Question_Mode];
                    }
                    [USER_DEFAULTS synchronize];
                    [self.navigationController pushViewController:questionVC animated:YES];
                } else {  //已经交卷
                    //获取用户的做题信息
//                    [self getExerInfoWithArray:dataArray];
                }
            } else {
                //获取整套完整试题（章节）
                [self getSectionQuestionWithQHisModel:qHisModel];
            }
        }
    }];
}
#pragma mark - 获取整套完整试题（章节）
- (void)getSectionQuestionWithQHisModel:(QHistoryModel *)qHisModel
{
    [QuestionManager QuestionManagerBasicListBySidWithCourseid:[NSString stringWithFormat:@"%ld",(long)qHisModel.courseid] uid:[USER_DEFAULTS objectForKey:User_uid] sid:[NSString stringWithFormat:@"%ld",(long)qHisModel.sid] completed:^(id obj) {
        if (obj != nil) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *temDic in (NSArray *)obj) {
                QuestionModel *qModel = [QuestionModel yy_modelWithDictionary:temDic];
                [dataArray addObject:qModel];
            }
            if ([self.state integerValue] == 0) {  //正在做题
                QuestionViewController *questionVC = [[QuestionViewController alloc] init];
                questionVC.naviTitle = qHisModel.title;
                questionVC.dataArray = dataArray;
                questionVC.qExerinfoModel = self.qExerinfoModel;
                questionVC.VCType = HistoryExerciseVCType;
                [USER_DEFAULTS setBool:NO forKey:Question_IsAnalyse];
                if ([USER_DEFAULTS integerForKey:Question_Mode] == 2) {
                    [USER_DEFAULTS setInteger:1 forKey:Question_Mode];
                }
                [USER_DEFAULTS synchronize];
                [self.navigationController pushViewController:questionVC animated:YES];
            } else {  //已经交卷
                //获取用户的做题信息
                [self getExerInfoWithArray:dataArray];
            }
        }
    }];
}
#pragma mark - 获取用户做题信息
- (void)getExerInfoWithArray:(NSMutableArray *)array
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
            _nowQIndex = i;
        }
    }
    //Qid收藏验证
    [self getCollectInfoWithArray:array];
}
#pragma mark - Qid收藏验证
- (void)getCollectInfoWithArray:(NSMutableArray *)array
{
    NSString *qidList = @"";
    for (QuestionModel *qModel in array) {
        qidList = [qidList stringByAppendingFormat:@"%ld,",(long)qModel.qid];
    }
    if (qidList.length > 0) {
        qidList = [qidList substringToIndex:qidList.length - 1];
    }
    [QuestionManager QuestionManagerQidCollectListWithUid:[USER_DEFAULTS objectForKey:User_uid] qidList:qidList completed:^(id obj) {
        if (obj != nil) {
            NSArray *collectArray = (NSArray *)obj;
            for (QuestionModel *qModel in array) {
                for (NSString *qidStr in collectArray) {
                    if (qModel.qid == [qidStr integerValue]) {
                        qModel.isCollect = YES;
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
            TestReportViewController *testReportVC = [[TestReportViewController alloc] init];
            testReportVC.dataArray = array;
            testReportVC.qExerinfoModel = self.qExerinfoModel;
            testReportVC.submitTimeStr = self.qExerinfoModel.insertTime;
            testReportVC.isHistory = YES;
            testReportVC.nowQIndex = _nowQIndex;
            [USER_DEFAULTS setBool:YES forKey:Question_IsAnalyse];
            [USER_DEFAULTS synchronize];
            [self.navigationController pushViewController:testReportVC animated:YES];
        }
    }];
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark - 懒加载
- (QHistoryTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QHistoryTableView alloc] initWithFrame:CGRectMake(0, self.optionView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.optionView.height) style:UITableViewStylePlain];
        _tableView.tableViewDelegate = self;
        [self.view addSubview:_tableView];
        //添加上拉加载
        if (_rowCount > _pagesize)
        {
            __weak typeof(self) weakSelf = self;
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
                [weakSelf mj_LoadMoreWithState:self.state];
            }];
        }
    }
    return _tableView;
}
- (OptionButtonView *)optionView {
    if (!_optionView) {
        _optionView = [[OptionButtonView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 50) optionArray:@[@"未完成", @"已完成"] selectedColor:MAIN_RGB lineSpace:15 haveLineView:YES selectIndex:0];
        _optionView.optionViewDelegate = self;
        [self.view addSubview:_optionView];
    }
    return _optionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
