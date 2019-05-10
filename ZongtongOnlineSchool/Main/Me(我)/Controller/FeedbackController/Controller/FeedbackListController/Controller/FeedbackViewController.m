//
//  FeedbackViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Tools.h"
#import "FeedbackModel.h"
#import "QuestionModel.h"
#import "FeedbackManager.h"
#import "UserStatisticManager.h"
#import "FeedbackTableView.h"
#import "FeedbackReplyViewController.h"

@interface FeedbackViewController () <FeedbackTableViewDelegate>
{
    NSInteger _page;
    NSInteger _pagesize;
    NSInteger _maxPage;
    NSInteger _rowCount;
    
    NSString *_qidList;
}
@property (nonatomic, strong) FeedbackTableView *tableView;
@property (nonatomic, strong) NSMutableArray *feedbackArray;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"反馈列表" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    _page = 1;
    _pagesize = 10;
    self.feedbackArray = [NSMutableArray arrayWithCapacity:10];
    //获取反馈列表
    [self getFeedbackListWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] sid:@"0" uid:[USER_DEFAULTS objectForKey:User_uid] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
}
#pragma mark - 获取反馈列表
- (void)getFeedbackListWithCourseid:(NSString *)courseid sid:(NSString *)sid uid:(NSString *)uid page:(NSString *)page pagesize:(NSString *)pagesize isLoadMore:(BOOL)isLoadMore
{
    [FeedbackManager feedbackManagerBasicPageWithCourseid:courseid sid:sid uid:uid page:page pagesize:pagesize completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([dic[@"List"] count] == 0) {
                [XZCustomWaitingView hideWaitingMaskView];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [XZCustomWaitingView showAutoHidePromptView:@"暂无更多反馈记录" background:nil showTime:1.0];
                return;
            } else {
                _page     = [dic[@"NowPage"]  integerValue];
                _pagesize = [dic[@"PageSize"] integerValue];
                _maxPage  = [dic[@"MaxPage"]  integerValue];
                _rowCount = [dic[@"RowCount"] integerValue];
                if (isLoadMore == NO) {
                    [self.feedbackArray removeAllObjects];
                }
                NSArray *netDataArray = (NSArray *)dic[@"List"];
                for (NSDictionary *dic in netDataArray) {
                    FeedbackModel *model = [FeedbackModel yy_modelWithDictionary:dic];
                    [self.feedbackArray addObject:model];
                }
                [XZCustomWaitingView hideWaitingMaskView];
                self.tableView.feedbackArray = self.feedbackArray;
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        }
    }];
}
#pragma mark - 上拉加载
- (void)mj_LoadMore
{
    [self.tableView.mj_footer beginRefreshing];
    if (self.feedbackArray.count < _rowCount) //还有剩余数据未加载
    {
        _page ++;
        //获取反馈列表
        [self getFeedbackListWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] sid:@"0" uid:[USER_DEFAULTS objectForKey:User_uid] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:YES];
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"已无更多数据" background:nil showTime:1.0];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark -
#pragma mark - tableView 代理方法
- (void)tableViewCellClickedWithIndex:(NSIndexPath *)indexPath
{
    FeedbackModel *fbModel = self.feedbackArray[indexPath.row];
    //某题信息
    [FeedbackManager feedbackManagerQuestionBasicInfoWithQid:[NSString stringWithFormat:@"%ld",(long)fbModel.qid] completed:^(id obj) {
        if (obj != nil) {
            QuestionModel *qModel = [QuestionModel yy_modelWithDictionary:(NSDictionary *)obj];
            //某些题分类
            [FeedbackManager feedbackManagerQTypeBasicListWithQtidList:[NSString stringWithFormat:@"%ld",(long)qModel.qtid] completed:^(id obj) {
                if (obj != nil) {
                    qModel.qTypeListModel = [QtypeListModel yy_modelWithDictionary:(NSDictionary *)obj[0]];
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
                    //试题统计
                    [UserStatisticManager userQuestionBasicWithUid:[USER_DEFAULTS objectForKey:User_uid] qid:[NSString stringWithFormat:@"%ld",(long)fbModel.qid] completed:^(id obj) {
                        if (obj != nil) {
                            qModel.userQModel = [UserQModel yy_modelWithDictionary:(NSDictionary *)obj];
                            FeedbackReplyViewController *feedbackReplyVC = [[FeedbackReplyViewController alloc] init];
                            feedbackReplyVC.qModel = qModel;
                            feedbackReplyVC.fbModel = fbModel;
                            [self.navigationController pushViewController:feedbackReplyVC animated:YES];
                        }
                    }];
                }
            }];
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
- (FeedbackTableView *)tableView {
    if (!_tableView) {
        _tableView = [[FeedbackTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
        _tableView.tableViewDelegate = self;
        [self.view addSubview:_tableView];
        //添加上拉加载
        if (_rowCount > _pagesize)
        {
            __weak typeof(self) weakSelf = self;
            _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
                [weakSelf mj_LoadMore];
            }];
        }
    }
    return _tableView;
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
