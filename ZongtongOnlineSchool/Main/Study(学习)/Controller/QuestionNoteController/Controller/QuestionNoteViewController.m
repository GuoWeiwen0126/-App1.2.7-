//
//  QuestionNoteViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "QuestionNoteViewController.h"
#import "Tools.h"
#import "QuestionModel.h"
#import "QuestionManager.h"
#import "UserStatisticManager.h"
#import "MistakeCollectManager.h"
#import "QuestionNoteTableView.h"
#import "QuestionViewController.h"

@interface QuestionNoteViewController () <QNoteTableViewDelegate>
{
    NSInteger _page;
    NSInteger _pagesize;
    NSInteger _maxPage;
    NSInteger _rowCount;
    
    NSString *_qidList;
}
@property (nonatomic, strong) QuestionNoteTableView *tableView;
@property (nonatomic, strong) NSMutableArray *noteArray;
@end

@implementation QuestionNoteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"用户笔记" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    _page = 1;
    _pagesize = 30;
    self.noteArray = [NSMutableArray arrayWithCapacity:10];
    //获取用户笔记列表
    [self getUserNoteWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] sid:@"0" uid:[USER_DEFAULTS objectForKey:User_uid] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeleteUserNoteAndReloadData:) name:@"DeleteUserNoteAndReloadData" object:nil];
}
#pragma mark - 获取用户笔记
- (void)getUserNoteWithCourseid:(NSString *)courseid sid:(NSString *)sid uid:(NSString *)uid page:(NSString *)page pagesize:(NSString *)pagesize isLoadMore:(BOOL)isLoadMore
{
    [QuestionManager QuestionManagerQnoteBasicPageWithCourseid:courseid sid:sid uid:uid page:page pagesize:pagesize completed:^(id obj) {
        NSDictionary *dic = (NSDictionary *)obj;
        if ([dic[@"List"] count] == 0) {
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
                [self.noteArray removeAllObjects];
            }
            NSArray *netDataArray = (NSArray *)dic[@"List"];
            for (NSDictionary *dic in netDataArray) {
                QNoteModel *model = [QNoteModel yy_modelWithDictionary:dic];
                model.isNoteLook = @"1";
                [self.noteArray addObject:model];
            }
            [XZCustomWaitingView hideWaitingMaskView];
            self.tableView.noteArray = self.noteArray;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark - 上拉加载
- (void)mj_LoadMore
{
    [self.tableView.mj_footer beginRefreshing];
    if (self.noteArray.count < _rowCount) //还有剩余数据未加载
    {
        _page ++;
        //获取用户笔记列表
        [self getUserNoteWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] sid:@"0" uid:[USER_DEFAULTS objectForKey:User_uid] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:YES];
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"已无更多数据" background:nil showTime:1.0];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark -
#pragma mark - 通知方法
- (void)DeleteUserNoteAndReloadData:(NSNotification *)noti
{
    for (QNoteModel *qNoteModel in self.noteArray.reverseObjectEnumerator) {
        if ([noti.object integerValue] == qNoteModel.qid) {
            [self.noteArray removeObject:qNoteModel];
        }
    }
    self.tableView.noteArray = self.noteArray;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - tableView 代理方法
- (void)tableViewCellClickedWithIndex:(NSIndexPath *)indexPath
{
    //拼接 qidList
    _qidList = @"";
    for (QNoteModel *qNoteModel in self.noteArray) {
        _qidList = [_qidList stringByAppendingFormat:@"%ld,",(long)qNoteModel.qid];
    }
    if (_qidList.length > 0) {
        _qidList = [_qidList substringToIndex:_qidList.length - 1];
    }
    //获取某些题信息
    [MistakeCollectManager mistakeCollectQuestionBasicListWithQidList:_qidList completed:^(id obj) {
        if (obj != nil) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dic in (NSArray *)obj) {
                QuestionModel *qModel = [QuestionModel yy_modelWithDictionary:dic];
                for (QNoteModel *qNoteModel in self.noteArray) {
                    if (qModel.qid == qNoteModel.qid) {  //数据重新排序（按照服务器返回的顺序）
                        qModel.qNoteModel = qNoteModel;
                        [dataArray addObject:qModel];
                        continue;
                    }
                }
            }
            //根据 qid 查试题统计
            [UserStatisticManager userQuestionUserCountWithUid:[USER_DEFAULTS objectForKey:User_uid] qidJson:_qidList completed:^(id obj) {
                for (NSDictionary *dic in (NSArray *)obj) {
                    UserQModel *userQModel = [UserQModel yy_modelWithDictionary:dic];
                    for (QuestionModel *qModel in dataArray) {
                        if (qModel.qid == userQModel.qid) {
                            qModel.userQModel = userQModel;
                            break;
                        }
                    }
                }
                QNoteModel *nowQNoteModel = self.noteArray[indexPath.row];
                for (int i = 0; i < dataArray.count; i ++) {
                    QuestionModel *qModel = dataArray[i];
                    if (qModel.qid == nowQNoteModel.qid) {
                        //用户点赞记录
                        [self getNotePraiseWithArray:dataArray nowIndex:i];
                        break;
                    }
                }
            }];
        }
    }];
}
#pragma mark - 用户点赞记录
- (void)getNotePraiseWithArray:(NSMutableArray *)array nowIndex:(NSInteger)nowIndex
{
    [QuestionManager QuestionManagerQNotePraiseListWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
        if (obj != nil) {
            NSArray *temArray = [NSArray arrayWithArray:obj];
            for (NSString *nidStr in temArray) {
                for (QuestionModel *qModel in array) {
                    if ([nidStr integerValue] == qModel.qNoteModel.nid) {
                        qModel.qNoteModel.isNotePraise = @"1";
                        continue;
                    }
                }
            }
            //跳转到做题界面
            QuestionViewController *questionVC = [[QuestionViewController alloc] init];
            questionVC.naviTitle = @"用户笔记";
            questionVC.dataArray = array;
            questionVC.VCType = QNoteVCType;
            questionVC.nowQIndex = nowIndex;
            [USER_DEFAULTS setBool:YES forKey:Question_IsAnalyse];
            [USER_DEFAULTS synchronize];
            [self.navigationController pushViewController:questionVC animated:YES];
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
- (QuestionNoteTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QuestionNoteTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
        _tableView.tableViewDelegate = self;
        [self.view addSubview:_tableView];
        //添加上拉加载
        if (_rowCount > _pagesize)
        {
            __weak typeof(self) weakSelf = self;
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
                [weakSelf mj_LoadMore];
            }];
        }
    }
    return _tableView;
}

#pragma mark
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
