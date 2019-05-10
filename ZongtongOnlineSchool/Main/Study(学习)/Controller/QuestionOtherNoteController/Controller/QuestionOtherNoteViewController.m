//
//  QuestionOtherNoteViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/19.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionOtherNoteViewController.h"
#import "Tools.h"
#import "OtherNoteModel.h"
#import "OtherNoteManager.h"
#import "OtherNoteTableView.h"

@interface QuestionOtherNoteViewController ()
{
    NSInteger _page;
    NSInteger _pagesize;
    NSInteger _maxPage;
    NSInteger _rowCount;
}
@property (nonatomic, strong) NSMutableArray *noteArray;
@property (nonatomic, strong) OtherNoteTableView *tableView;
@end

@implementation QuestionOtherNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"他人笔记" naviFont:20.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    _page = 1;
    _pagesize = 20;
    self.noteArray = [NSMutableArray arrayWithCapacity:10];
    
    //获取所有笔记
    [self getAllnoteDataWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] qid:[NSString stringWithFormat:@"%ld",(long)self.qid] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
}
#pragma mark -
#pragma mark - 获取所有笔记
- (void)getAllnoteDataWithCourseid:(NSString *)courseid qid:(NSString *)qid page:(NSString *)page pagesize:(NSString *)pagesize isLoadMore:(BOOL)isLoadMore
{
    [OtherNoteManager otherNoteManagerBasicPageWithCourseid:courseid qid:qid page:page pagesize:pagesize completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([dic[@"List"] count] == 0) {
                [self showAlertView];
            } else {
                _page     = [dic[@"NowPage"]  integerValue];
                _pagesize = [dic[@"PageSize"] integerValue];
                _maxPage  = [dic[@"MaxPage"]  integerValue];
                _rowCount = [dic[@"RowCount"] integerValue];
                //遍历添加数据
                for (NSDictionary *noteDic in (NSMutableArray *)dic[@"List"]) {
                    OtherNoteModel *noteModel = [OtherNoteModel yy_modelWithDictionary:noteDic];
                    [self.noteArray addObject:noteModel];
                }
                if (isLoadMore == NO) {  //配置tableView
                    [self configTableViewWithArray:self.noteArray];
                } else {  //刷新表
                    self.tableView.noteArray = self.noteArray;
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }
    }];
}
#pragma mark - 弹出提示框
- (void)showAlertView
{
    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"暂无更多笔记" cancelButtonTitle:@"" otherButtonTitle:@"返回" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark - 创建 OtherNoteTableView
- (void)configTableViewWithArray:(NSMutableArray *)array
{
    self.tableView = [[OtherNoteTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain noteArray:array];
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
    if (self.noteArray.count < _rowCount) //还有剩余数据未加载
    {
        _page ++;
        [self getAllnoteDataWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] qid:[NSString stringWithFormat:@"%ld",(long)self.qid] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:YES];
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"已无更多数据" background:nil showTime:1.0];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
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
