//
//  MistakeCollectViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "MistakeCollectViewController.h"
#import "Tools.h"
#import "MistakeCollectManager.h"
#import "QuestionManager.h"
#import "UserStatisticManager.h"
#import "QuestionModel.h"
#import "QMistakeCollectTableView.h"
#import "QuestionViewController.h"

@interface MistakeCollectViewController () <QMistakeCollectTableViewDelegate, OptionButtonViewDelegate>
{
    NSInteger _page;
    NSInteger _pagesize;
    NSInteger _maxPage;
    NSInteger _rowCount;
    
    NSString *_qidList;
}
@property (nonatomic, strong) OptionButtonView *optionBtnView;  //做题模式切换
@property (nonatomic, strong) QMistakeCollectTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MistakeCollectViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _page = 1;
    _pagesize = 50;
    self.dataArray = [NSMutableArray arrayWithCapacity:10];
    //获取 错题/收藏 总列表
    [self getMistakeOrCollectDataSourceWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] sid:@"0" page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] type:self.mistakeCollectType isLoadMore:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:self.mistakeCollectType == MistakeType ? @"错题汇总":@"收藏列表" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.optionBtnView = [[OptionButtonView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 50) optionArray:@[@"练习模式", @"模考模式", @"浏览模式"] selectedColor:MAIN_RGB lineSpace:15 haveLineView:YES selectIndex:[USER_DEFAULTS integerForKey:Question_Mode]];
    self.optionBtnView.optionViewDelegate = self;
    [self.view addSubview:self.optionBtnView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MistakeCollectRemoveQuestion:) name:@"MistakeCollectRemoveQuestion" object:nil];
}
#pragma mark - 移除错题、收藏
- (void)MistakeCollectRemoveQuestion:(NSNotification *)noti
{
    QuestionModel *qModel = (QuestionModel *)noti.object;
    for (QuestionModel *temModel in self.dataArray.reverseObjectEnumerator) {
        if (temModel.qid == qModel.qid) {
            [self.dataArray removeObject:temModel];
        }
    }
    self.tableView.dataArray = self.dataArray;
    [self.tableView reloadData];
}
#pragma mark - 获取 错题/收藏 总列表
- (void)getMistakeOrCollectDataSourceWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize type:(MistakeCollectType)type isLoadMore:(BOOL)isLoadMore
{
    [MistakeCollectManager mistakeOrCollectBasicPageWithCourseid:courseid uid:uid sid:sid page:page pagesize:pagesize type:type completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([dic[@"List"] count] == 0) {
                [XZCustomWaitingView hideWaitingMaskView];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [XZCustomWaitingView showAutoHidePromptView:self.mistakeCollectType == MistakeType ? @"暂无更多错题":@"暂无更多收藏" background:nil showTime:1.0];
            } else {
                _page     = [dic[@"NowPage"]  integerValue];
                _pagesize = [dic[@"PageSize"] integerValue];
                _maxPage  = [dic[@"MaxPage"]  integerValue];
                _rowCount = [dic[@"RowCount"] integerValue];
                //拼接 qidList
                _qidList = @"";
                for (NSDictionary *CollectDic in (NSArray *)dic[@"List"]) {
                    _qidList = [_qidList stringByAppendingFormat:@"%@,",CollectDic[@"qid"]];
                }
                if (_qidList.length > 0) {
                    _qidList = [_qidList substringToIndex:_qidList.length - 1];
                }
                //获取某些题信息
                [MistakeCollectManager mistakeCollectQuestionBasicListWithQidList:_qidList completed:^(id obj) {
                    if (obj != nil) {
                        NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:10];
                        for (NSDictionary *dic in (NSArray *)obj) {
                            QuestionModel *qModel = [QuestionModel yy_modelWithDictionary:dic];
                            [temArray addObject:qModel];
                        }
                        //根据 qid 查试题统计
                        [UserStatisticManager userQuestionUserCountWithUid:uid qidJson:_qidList completed:^(id obj) {
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
                            [self getQuestionTypeWithArray:temArray isLoadMore:isLoadMore];
                        }];
                    }
                }];
            }
        }
    }];
}
#pragma mark - 获取题分类
- (void)getQuestionTypeWithArray:(NSMutableArray *)netDataArray isLoadMore:(BOOL)isLoadMore
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
    if (isLoadMore == NO) {
        //配置 tableView
        [self configTableViewWithArray:self.dataArray];
    } else {
        //刷新表
        self.tableView.dataArray = self.dataArray;
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma mark - 配置 tableView
- (void)configTableViewWithArray:(NSMutableArray *)array
{
    self.tableView = [[QMistakeCollectTableView alloc] initWithFrame:CGRectMake(0, self.optionBtnView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.optionBtnView.height) style:UITableViewStyleGrouped];
    self.tableView.dataArray = array;
    self.tableView.tableViewType = self.mistakeCollectType;
    self.tableView.tableViewDelegate = self;
    [self.view addSubview:self.tableView];
    //添加上拉加载
    if (_rowCount > _pagesize)
    {
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
            [weakSelf mj_LoadMore];
        }];
    }
}
#pragma mark - 上拉加载
- (void)mj_LoadMore
{
    [self.tableView.mj_footer beginRefreshing];
    if (self.dataArray.count < _rowCount) //还有剩余数据未加载
    {
        _page ++;
        [self getMistakeOrCollectDataSourceWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] sid:@"0" page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] type:self.mistakeCollectType isLoadMore:YES];
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"已无更多数据" background:nil showTime:1.0];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma mark - 
#pragma mark - tableView 点击 section 
- (void)tableViewSectionClickedWithIndex:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.section);
    QuestionViewController *questionVC = [[QuestionViewController alloc] init];
    questionVC.naviTitle = self.mistakeCollectType == MistakeType ? @"错题汇总":@"收藏列表";
    questionVC.dataArray = self.dataArray.mutableCopy;
    questionVC.VCType = self.mistakeCollectType == MistakeType ? MistakeVCType:CollectVCType;
    questionVC.nowQIndex = indexPath.section;
    questionVC.temPage = _page;
    questionVC.temPagesize = _pagesize;
    questionVC.temMaxPage = _maxPage;
//    [USER_DEFAULTS setBool:YES forKey:Question_IsAnalyse];
//    [USER_DEFAULTS synchronize];
    [self.navigationController pushViewController:questionVC animated:YES];
}
#pragma mark - 弹出提示框
- (void)showAlertView
{
    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:self.mistakeCollectType == MistakeType ? @"暂无更多错题":@"暂无更多收藏" cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
//        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark - OptionButtonView 代理方法
- (void)optionViewButtonClickedWithBtnTag:(NSInteger)btnTag
{
    [USER_DEFAULTS setInteger:btnTag forKey:Question_Mode];
    [USER_DEFAULTS synchronize];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
